import 'package:a_living_dictionary/DB/CommunityItem.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'Search.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();


class CommunityPostPage extends StatefulWidget {
  const CommunityPostPage(this.tabName, this.item, {Key? key}) : super(key: key);
  final String tabName;
  final CommunityItem item;
  @override
  State<CommunityPostPage> createState() => _CommunityPostPageState(tabName, item);
}

class _CommunityPostPageState extends State<CommunityPostPage> with SingleTickerProviderStateMixin {
  _CommunityPostPageState(this.tabName, this.item);

  TextEditingController commentController = TextEditingController();
  Icon likeIcon = Icon(Icons.thumb_up_off_alt);
  final CommunityItem item;
  late var width, height;
  bool isClickedGlobal = false;
  final String tabName;

  late Logineduser user = Provider.of<Logineduser>(context, listen: true);


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: themeColor.getWhiteMaterialColor(),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text(tabName, style: TextStyle(color: Colors.black)),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () => {
                    //showSearch(context: context, delegate:Search(null))
                  },
                )
              ],
            ),
          //Body : 싱글 스크롤
          body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: (width > 750) ? (750) : (width),
              color: Colors.white,
              child: ListView(
                children: [
                  getTitleWidget(item.title, item.writer_id),
                  getBodyWidget(item.body),
                  getLikeWidget(),
                  const Divider(thickness: 1.0, color: Color(0xaadddddd)),
                  getCommentWriteWidget(),
                  getCommentWidget()
                ],
              ),
            ),
          ),
        ));
  }

  Widget getTitleWidget(String title, String writer) {
    return Column(children: [
      Container(
        width: (width > 750) ? (750) : (width),
        height: 40,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xAAdadada), width: 1.5),
              bottom: BorderSide(color: Color(0xAAdadada), width: 1.3),
            ),
            color: Color(0xAAefefef)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
          child: Text(title, style: TextStyle(fontSize: 25)),
        ),
      ),
      Container(
        width: width,
        height: 30,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xAAdadada), width: 1.3))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
          child: Text(writer, style: TextStyle(fontSize: 15)),
        ),
      ),
    ]);
  }
  Widget getBodyWidget(String body) {
    return Container(
      width: (width > 750) ? (750) : (width),
      height: 300,
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(body , style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
  Widget getLikeWidget() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Row(children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection("LikeList").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("error!");
                }
                final documents = snapshot.data!.docs;

                final a = documents.where((element) => element['like_doc_id'] == item.doc_id);
                if (a.isEmpty) {
                  return buildLikeButton(false);
                }
                else {
                  return buildLikeButton(true);
                }
              })
        ]));
  }
  Widget buildLikeButton(isClicked){
    isClickedGlobal = isClicked;
    return IconButton(
      icon: (isClickedGlobal)?(Icon(Icons.thumb_up_off_alt_rounded)):(Icon(Icons.thumb_up_off_alt)),
      style: ButtonStyle(
        mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
      ),
      onPressed: (){
        setState(() {
          isClickedGlobal = !isClickedGlobal;
          if(isClickedGlobal){
            item.addLikeNum();
            item.registerThisPost(user);
          }
          else{
            item.subLikeNum();
            item.unRegisterThisPost(user);
          }
        });
      },
    );
  }

  Widget getCommentWriteWidget(){
    return Container(
      width: (width > 750) ? (750) : (width),
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xAAdadada), width: 1.0)
      ),
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Row(
        children: [
          SizedBox(
            width: (width > 750) ? (650) : (width-100),
            height: 120,
            child: TextField(
              decoration: const InputDecoration(
                hintText: "댓글 입력",
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: commentController,
              maxLines: null,
              maxLength: 100,
              cursorColor: Colors.black,
            ),
          ),
          TextButton(
              onPressed: (){
                final it = CommentItem(
                    writer_id: "a", body: commentController.text, time:DateTime.now()
                );
                it.add(item.doc_id);
                commentController.text = "";
              },
              child: Text("등록", style: TextStyle(color: Colors.black))
          )
        ],
      ),
    );
  }
  Widget getCommentWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id)
            .collection('CommentDB').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("has error");
          }

          final doc = snapshot.data!.docs;

          return Column(
            children: doc.map((e) => (buildComWidget(e))).toList(),
          );
        });
  }
  Widget buildComWidget(QueryDocumentSnapshot doc) {
    final it = CommentItem.getDatafromDoc(doc);
    return Column(
      children: [
        ListTile(
          title: Text(it.writer_id,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
          subtitle: Text(it.body,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
          leading: const Icon(Icons.account_box),
          minVerticalPadding: 0,
        ),
        const Divider(thickness: 0.7)
      ],
    );
  }
}



