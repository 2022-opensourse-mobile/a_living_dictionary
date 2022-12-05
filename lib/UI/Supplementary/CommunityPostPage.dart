
import 'package:a_living_dictionary/DB/CommunityItem.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/CheckClick.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CommunityWritePage.dart';
import 'PageRouteWithAnimation.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();


class CommunityPostPage extends StatefulWidget {
  const CommunityPostPage(this.tabName, this.item,{Key? key, this.commentItemID}) : super(key: key);
  final String tabName;
  final CommunityItem item;
  final String? commentItemID;

  @override
  State<CommunityPostPage> createState() => _CommunityPostPageState(tabName, item, coloredCommentItemID: commentItemID);
}

class _CommunityPostPageState extends State<CommunityPostPage> with SingleTickerProviderStateMixin {
  _CommunityPostPageState(this.tabName, this.item, {this.coloredCommentItemID});

  TextEditingController commentController = TextEditingController();
  TextEditingController commentModifyController = TextEditingController();


  Icon likeIcon = Icon(Icons.favorite_border_rounded);
  final CommunityItem item;
  final String? coloredCommentItemID;
  final String tabName;
  late dynamic width, height;
  bool isClickedGlobal = false;
  final CheckClick clickCheck = CheckClick();

  static const int KOR = 15;
  static const int ENG = 10;
  static const int NUM = 10;
  static const double SPACIAL = 9.5;
  static const int SPACE = 4;



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
              title: Text(tabName, style: const TextStyle(color: Colors.black)),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => {
                    //showSearch(context: context, delegate:Search(null))
                  },
                )
              ],
            ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: (width > 750) ? (750) : (width),
              color: Colors.white,
              child: ListView(
                children: [
                  getTitleWidget(item.title, item.writerNickname),
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
        child : Align(
          alignment: Alignment.centerLeft,
          child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(item.hashTag,
                    style: TextStyle(color: themeColor.getColor()),
                    textScaleFactor: 1.0)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: (user.uid == item.writerID)
                      ? ((width > 750) ? (620) : (width - 130))
                      : ((width > 750) ? (700) : (width - 50)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.7),
                  ),
                ),
                getModifyBtn(),
              ],
            ),
          ],
        ),),
      ),
      Container(
        width: ((width > 750) ? (750) : (width)),
        height: 50,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xffe0e0e0),
                child: CircleAvatar(
                  radius: 19.5,
                  backgroundImage: NetworkImage(item.profileImage), //프로필 사진
                ),
              ),
              Text(" $writer", style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
      Divider(thickness: 0.5),
    ]);
  }
  Widget getBodyWidget(String body) {
    int line = getLineNum(body);
    bool isOvered = (line > 15)?(true):(false);
    double h = ((isOvered)?(19.5*line):(300)).toDouble();

    return Container(
      width: (width > 750) ? (750) : (width),
      height: h.toDouble(),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(body , style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
  Widget getModifyBtn(){
    if(user.uid == item.writerID){
      return Row(
        children: [
          Row(
            children: [
              TextButton(
                  child: const Text("수정", style: TextStyle(color: Colors.black)),
                  onPressed: (){
                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(CommunityWritePage(context, item));
                    Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
                  }
              ),
              TextButton(
                  child: const Text("삭제", style: TextStyle(color: Colors.black)),
                  onPressed: (){
                    item.delete(user);
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
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("error!");
                }
                final documents = snapshot.data!.docs;

                final isLiked = documents.where((element) => element['like_doc_id'] == item.doc_id);
                if (isLiked.isEmpty) {
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
          icon: (isClickedGlobal)?(const Icon(Icons.favorite_rounded, color: Color(0xffD83064))):(const Icon(Icons.favorite_border_rounded, color: Color(0xffD83064))),
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
  int getLineNum(String body){
    RegExp koreanReg = RegExp(r"^[ㄱ-ㅎ가-힣]*$");
    RegExp engReg = RegExp(r"^[a-zA-Z]*$");
    RegExp numReg = RegExp(r"^[0-9]*$");
    RegExp spaceReg = RegExp(r"\s+");
    RegExp spacialReg = RegExp(r'[@#^$%&*?"<>]');
    RegExp spacial2Reg = RegExp(r'[!(),.:{}|]');

    List<RegExpMatch?> regExpMatch = <RegExpMatch?>[];

    double sum = 0;
    int line = 1;
    for(int i = 0; i < body.length; i++){
      regExpMatch.add(koreanReg.firstMatch(body[i]));
      regExpMatch.add(engReg.firstMatch(body[i]));
      regExpMatch.add(numReg.firstMatch(body[i]));
      regExpMatch.add(spacialReg.firstMatch(body[i]));
      regExpMatch.add(spacial2Reg.firstMatch(body[i]));
      regExpMatch.add(spaceReg.firstMatch(body[i]));


      if(regExpMatch[0]?.end == 1){
        sum += KOR;
      } else if(regExpMatch[1]?.end == 1){
        sum += ENG;
      } else if(regExpMatch[2]?.end == 1){
        sum += NUM;
      }else if(regExpMatch[3]?.end == 1){
        sum += SPACIAL;
      }else if(regExpMatch[4]?.end == 1){
        sum += SPACIAL;
      }else if(regExpMatch[5]?.end == 1){
        sum += SPACE;
      }

      if(sum >= width || body[i] == '\n'){
        sum = 0;
        line++;
      }
    }//
    return line;
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
                          writerID: user.uid,
                          writerNickname: user.nickName,
                          profileImage: user.profileImageUrl,
                          body: commentController.text,
                          time:DateTime.now(),
                        );
                        it.add(item);
                        Future.delayed(const Duration(milliseconds: 1000), () {
                        FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('CommentList').add({
                          'comment_id' : it.doc_id,
                          'community_id' : item.doc_id,
                          'time' : Timestamp.fromDate(it.time!)
                          });
                        });
                        commentController.text = "";
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Text("등록", style: TextStyle(color: Colors.black))
                      ),
                      SizedBox(height: 18)
                ],
              )
            ],
          ),
    ), SizedBox(height: 30)]);
  }
  Widget getCommentListWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id)
            .collection('CommentDB').orderBy('time', descending: true).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("has error");
          }

          final documents = snapshot.data!.docs;
          return Column(
            children: documents.map<Widget>((doc) => (getCommentItem(doc))).toList(),
          );
        });
  }
  Widget getCommentItem(QueryDocumentSnapshot doc) {
    final commentItem = CommentItem.getDatafromDoc(doc);
    Color charColor = Colors.black;
    if(coloredCommentItemID != null){
      if(commentItem.doc_id == coloredCommentItemID!){
        charColor = Colors.red;
      }
    }
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: (width > 750) ? (630) : (width-120),
              child: ListTile(
                title: (Text(commentItem.writerNickname, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: charColor))),
                //수정 버튼을 눌렀다면 TextFromField 출력, 아니라면 댓글 내용 출력
                subtitle: (isOnGoing && commentItem.doc_id == changedDocID)?
                  (TextFormField(controller: commentModifyController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                  ),)):
                  (Text(commentItem.body, style: TextStyle(fontSize: 14, color: charColor))),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xffe0e0e0),
                  child: CircleAvatar(
                    radius: 19.5,
                    backgroundImage: NetworkImage(commentItem.profileImage), //프로필 사진
                  ),
                ),
                minVerticalPadding: 0,
              ),
            ),
            //내가 댓글의 주인이면 수정, 삭제 버튼 출력
            (commentItem.writerID==user.uid)?(getCommentBtnGroup(commentItem)):(Container())
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
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          minimumSize: MaterialStateProperty.all(const Size(30, 30)),
          maximumSize: MaterialStateProperty.all(const Size(40, 40))),
      onPressed: () {
        setState(() {
          //버튼을 눌렀을때(최초 상태는 false)
          changedDocID = (!isOnGoing) ? (commentItem.doc_id) : (changedDocID);
          if (changedDocID == commentItem.doc_id) {
            isOnGoing = !isOnGoing;
            commentModifyController.text = commentItem.body;
          }
        });
      },
      child: const Text("수정", style: TextStyle(color: Colors.black)),
    );
  }
  Widget getCommentCompleteBtn(CommentItem commentItem) {
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          minimumSize: MaterialStateProperty.all(const Size(30, 30)),
          maximumSize: MaterialStateProperty.all(const Size(40, 40))),
      onPressed: () {
        setState(() {
          if (commentItem.doc_id == changedDocID) {
            isOnGoing = !isOnGoing;
            FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id).collection('CommentDB')
                .doc(commentItem.doc_id).update({'body': commentModifyController.text});
          }
        });
      },
      child: const Text("완료", style: TextStyle(color: Colors.black)),
    );
  }
  Widget getCommentDeleteBtn(CommentItem commentItem) {
    return TextButton(
      style: ButtonStyle(
          padding:MaterialStateProperty.all(const EdgeInsets.fromLTRB(10, 0, 0, 0)),
          minimumSize: MaterialStateProperty.all(const Size(30, 30)),
          maximumSize: MaterialStateProperty.all(const Size(40, 40))),
      onPressed: () {
        commentItem.delete(item, user);
      },
      child: const Text("삭제", style: TextStyle(color: Colors.black)),
    );
  }
}