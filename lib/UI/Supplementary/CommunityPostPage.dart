import 'package:a_living_dictionary/DB/CommunityItem.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/CheckClick.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'CommunityWritePage.dart';
import 'PageRouteWithAnimation.dart';
//import 'Search.dart';
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
  TextEditingController commentModifyController = TextEditingController();

  Icon likeIcon = Icon(Icons.favorite_border_rounded);
  final CommunityItem item;
  final String tabName;
  late var width, height;
  bool isClickedGlobal = false;
  final CheckClick clickCheck = CheckClick();


  bool myChange = false;
  String changedDocID = '';
  bool isOnGoing = false;


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
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: themeColor.getMaterialColor(), //커서 색상
              selectionColor: Color(0xffEAEAEA), //드래그 색상
              selectionHandleColor: themeColor.getMaterialColor() //water drop 색상
          ),
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
                  getTitleWidget(item.title, item.writer_nickname),
                  getBodyWidget(item.body),
                  getLikeInfo(),
                  Divider(thickness: 0.5),
                  //const Divider(thickness: 1.0, color: Color(0xaadddddd)),
                  getCommentWriteWidget(),
                  getCommentListWidget()
                ],
              ),
            ),
          ),
        ));
  }

  // 아래는 본문에 필요한 위젯들
  //getTitleWidget : 제목 및 작성자 위젯
  //getBodyWidget : 본문 위젯
  //getModifyBtn : 본인 게시글일시 수정 삭제 버튼
  //getLikeInfo : 좋아요 버튼 출력하기 위한 정보 획득 함수
  //getLikeWidget : 좋아요 버튼 출력
  Widget getTitleWidget(String title, String writer) {
    return Column(children: [
      Container(
        width: (width > 750) ? (750) : (width),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.7),
            ),
            getModifyBtn(),
          ],
        ),
      ),
      Container(
        width: width,
        height: 50,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(item.profileImage), //프로필 사진
              ),
              Text(" $writer", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),

      Divider(thickness: 0.5),
    ]);
  }
  Widget getBodyWidget(String body) {
    return Container(
      width: (width > 750) ? (750) : (width),
      height: 300,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(body , style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
  Widget getModifyBtn(){
    if(user.uid == item.writer_id){
      return Row(
        children: [
          Row(
            children: [
              TextButton(
                  child: Text("수정", style: TextStyle(color: Colors.black)),
                  onPressed: (){
                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(CommunityWritePage(context, item));
                    Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
                  }
              ),
              TextButton(
                  child: Text("삭제", style: TextStyle(color: Colors.black)),
                  onPressed: (){
                    item.delete();
                    Navigator.pop(context);
                  }
              ),
            ],
          )
        ],
      );
    }
    else{
      return Container();
    }
  }
  Widget getLikeInfo() {
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
                  return getLikeWidget(false);
                }
                else {
                  return getLikeWidget(true);
                }
              })
        ]));
  }
  Widget getLikeWidget(isClicked){
    isClickedGlobal = isClicked;
    return Row(
      children: [
        IconButton(
          icon: (isClickedGlobal)?(Icon(Icons.favorite_rounded, color: Color(0xffD83064))):(Icon(Icons.favorite_border_rounded, color: Color(0xffD83064))),
          style: ButtonStyle(
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          ),
          tooltip: "좋아요",
          onPressed: (){
            setState(() {
              if(clickCheck.isRedundentClick(DateTime.now())) return;
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
        ),
        Text(item.like.toString()),
      ],
    );
  }



  // 아래는 댓글에 필요한 위젯들
  //getCommentWriteWidget : 댓글작성창
  //getCommentListWidget : 전체 댓글 받아오기
  //getCommentItem : 각 댓글 출력하기
  //getCommentBtnGroup : 본인 댓글일시 수정삭제 그룹 출력
  //getCommentModifyBtn : 수정 버튼
  //getCommentCompleteBtn : 수정 완료 버튼
  //getCommentDeleteBtn : 삭제 버튼
  Widget getCommentWriteWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Text('댓글', style:TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.4)),

        Container(
          width: (width > 750) ? (750) : (width),
          height: 100,
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Row(
            children: [
              SizedBox(
                width: (width > 750) ? (650) : (width-100),
                height: 120, //120
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "내용을 입력하세요",
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffededed))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffededed))),
                  ),
                  controller: commentController,
                  maxLines: null,
                  maxLength: 100,
                  minLines: 3,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 19),
                  TextButton(
                      onPressed: (){
                        if(commentController.text == '') return;
                        final it = CommentItem(
                            writer_id: user.uid,
                            writer_nickname: user.nickName,
                            body: commentController.text,
                            time:DateTime.now(),
                            change: false
                        );
                        it.add(item);
                        item.commentNum += 1;
                        FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id).update({
                          'commentNum':item.commentNum
                        });
                        commentController.text = "";
                      },
                      child: Text("등록", style: TextStyle(color: Colors.black))
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 18)
      ],
    );
  }
  Widget getCommentListWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id)
            .collection('CommentDB').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("has error");
          }

          final doc = snapshot.data!.docs;

          return Column(
            children: doc.map((e) => (getCommentItem(e))).toList(),
          );
        });
  }
  Widget getCommentItem(QueryDocumentSnapshot doc) {
    final commentItem = CommentItem.getDatafromDoc(doc);
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: (width > 750) ? (630) : (width-120),
              child: ListTile(
                title: (Text(commentItem.writer_nickname, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.black))),
                //수정 버튼을 눌렀다면 TextFromField 출력, 아니라면 댓글 내용 출력
                subtitle: (isOnGoing && commentItem.doc_id == changedDocID)?
                (TextFormField(controller: commentModifyController)):
                (Text(commentItem.body, style: const TextStyle(fontSize: 14, color: Colors.black))),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImageUrl), //프로필 사진
                ),
                minVerticalPadding: 0,
              ),
            ),
            //내가 댓글의 주인이면 수정, 삭제 버튼 출력
            (commentItem.writer_id==user.uid)?(getCommentBtnGroup(commentItem)):(Container())
          ],
        ),
        const Divider(thickness: 0.5)
      ],
    );
  }

  Widget getCommentBtnGroup(CommentItem commentItem) {
    return Row(
      children: [
        Row(
          children: [(isOnGoing && commentItem.doc_id == changedDocID)?
          (getCommentCompleteBtn(commentItem)):
          (getCommentModifyBtn(commentItem)),
            getCommentDeleteBtn(commentItem)
          ],
        )
      ],
    );
  }
  Widget getCommentModifyBtn(CommentItem commentItem) {
    return TextButton(
        child: Text("수정", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all(Size(30, 30)),
            maximumSize: MaterialStateProperty.all(Size(40, 40))),
        onPressed: () {
          setState(() {
            //버튼을 눌렀을때(최초 상태는 false)
            changedDocID = (!isOnGoing)?(commentItem.doc_id):(changedDocID);
            if(changedDocID == commentItem.doc_id){
              isOnGoing = !isOnGoing;
              commentModifyController.text = commentItem.body;
            }
          });
        });
  }
  Widget getCommentCompleteBtn(CommentItem commentItem) {
    return TextButton(
        child: Text("완료", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all(Size(30, 30)),
            maximumSize: MaterialStateProperty.all(Size(40, 40))),
        onPressed: () {
          setState(() {
            //버튼을 눌렀을 때
            if(commentItem.doc_id == changedDocID) {
              isOnGoing = !isOnGoing;
              FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id)
                  .collection('CommentDB').doc(commentItem.doc_id).update({'body': commentModifyController.text});
            }
          });
        });
  }
  Widget getCommentDeleteBtn(CommentItem commentItem) {
    return TextButton(
        child: Text("삭제", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
            padding:
            MaterialStateProperty.all(EdgeInsets.fromLTRB(10, 0, 0, 0)),
            minimumSize: MaterialStateProperty.all(Size(30, 30)),
            maximumSize: MaterialStateProperty.all(Size(40, 40))),
        onPressed: () {
          FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id)
              .collection('CommentDB').doc(commentItem.doc_id).delete();
          item.commentNum -= 1;
          FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id).update({'commentNum': item.commentNum});
        });
  }
}