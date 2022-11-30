
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/CommunityPostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityItem with ChangeNotifier{
  String doc_id = '';
  String title = '';
  String writer_id = '';
  String writer_nickname = '';
  String body = '';
  int like = 0;
  DateTime? time;
  int boardType = 0;
  String hashTag = '';
  int commentNum = 0;
  String profileImage;


  CommunityItem({
    this.title = '',
    this.writer_id = '',
    this.body = '',
    this.like = 0,
    this.boardType = 0,
    this.hashTag = '',
    this.doc_id = '',
    this.writer_nickname = '',
    this.time,
    this.commentNum = 0,
    this.profileImage = ''
  }){}



  void add() {
    Timestamp stamp = Timestamp.fromDate(this.time!);
    FirebaseFirestore.instance.collection('CommunityDB').add({
      'title': this.title,
      'like': this.like,
      'writer_id': this.writer_id,
      'body':this.body,
      'time': stamp,
      'boardType':this.boardType,
      'hashTag':this.hashTag,
      'writer_nickname':this.writer_nickname,
      'commentNum' : this.commentNum,
      'profileImage' : this.profileImage
    });
  }
  void delete(){
    FirebaseFirestore.instance.collection('CommunityDB').doc(this.doc_id).delete();
  }
  static CommunityItem getDataFromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommunityItem(
        doc_id : doc.id,
        title : doc['title'],
        writer_id : doc['writer_id'],
        writer_nickname: doc['writer_nickname'],
        profileImage: doc['profileImage'],
        body : doc['body'],
        like : doc['like'],
        time : stamp.toDate(),
        boardType : doc['boardType'],
        hashTag : doc['hashTag'],
        commentNum: doc['commentNum']
    );
    if(item.like >= 10 && item.boardType == 0){
      item.boardType = 1;
      FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id).update({'boardType' : item.boardType});
    }
    return item;
  }


  void addLikeNum(){
    this.like++;
    FirebaseFirestore.instance.collection('CommunityDB').doc(this.doc_id).update({
      'like': this.like
    });
    if(isHotPost()){
      updateBoardType(1);
    }
  }
  void subLikeNum(){
    this.like--;
    FirebaseFirestore.instance.collection('CommunityDB').doc(this.doc_id).update({
      'like': this.like
    });
    if(!isHotPost()){
      updateBoardType(0);
    }
  }
  bool isHotPost(){
    return (this.like >= 10);
  }
  void updateBoardType(i){
    boardType = i;
    FirebaseFirestore.instance.collection('CommunityDB').doc(this.doc_id).update({
      'boardType': this.boardType
    });
  }
  void registerThisPost(Logineduser user){
    FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('LikeList').add({
      'like_doc_id' : this.doc_id
    }).then((value) => FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('LikeList').doc(value.id).update(
        {'id':value.id}));
  }
  void unRegisterThisPost(Logineduser user) async {
    final instance = FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('LikeList');
    await for (var snapshot in instance.snapshots()){
      for (var doc in snapshot.docs){
        if(doc['like_doc_id'] == this.doc_id){
          instance.doc(doc['id']).delete();
        }
      }
    }
  }



  Widget build(BuildContext context) {
    String t = '${this.time!.hour.toString()}:${this.time!.minute.toString()}';

    int n = this.body.indexOf('\n');
    if(n == -1) {
      n = (this.body.length > 10) ?(10):(this.body.length);
    }
    String omittedBody = this.body.substring(0, n);
    if(n == 10) omittedBody += "...";

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        children: [
          ListTile(
            title: Text("${this.title}"),
            subtitle: Text(omittedBody),
            shape: const RoundedRectangleBorder(
                side: BorderSide(style: BorderStyle.none)
            ),
            trailing: Text(t),
            style: ListTileStyle.list,
            onTap: () {
              String tabName = getTabName(this.boardType);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityPostPage(tabName, this))
              );
            },
          ),
          const Divider(thickness: 1.0)
        ],
      ),
    );
  }
  Widget buildMain(BuildContext context) {
    String t = '${this.time!.hour.toString()}:${this.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: ListTile(
          title: Text(this.title, style: TextStyle(fontSize: 15.8)),
          visualDensity: const VisualDensity(vertical: -4),
          dense: true,
          trailing: Text(t),
          onTap: (){
            String tabName = getTabName(this.boardType);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommunityPostPage(tabName, this))
            );
          },
        ));
  }
  String getTabName(int boardType){
    switch(boardType){
      case 1:
        return "인기게시판";
      case 2:
        return "공지게시판";
      default:
        return "자유게시판";
    }
  }

  List<Widget> getWidgetList(BuildContext context, List<QueryDocumentSnapshot<Object?>> doc, int boardType){
    final board = doc.where((item)=> item['boardType'] == boardType).toList();
    int n = (board.length >= 4)?(4):(board.length);
    final subList = board.sublist(0,n);
    final buildList = subList.map((doc){
      final item = CommunityItem.getDataFromDoc(doc);
      return item.buildMain(context);
    }).toList();
    return buildList;
  }
}


class CommentItem{
  String writer_id;
  String writer_nickname;
  String body;
  DateTime? time;
  String doc_id;

  bool change;
  CommentItem({this.writer_id = '', this.body = '', this.time, this.writer_nickname = '', this.doc_id = '', this.change=false});

  void add(CommunityItem communityItem){
    if(time == null){
      print("comment add error : there's no time");
      return;
    }
    FirebaseFirestore.instance.collection('CommunityDB').doc(communityItem.doc_id).collection('CommentDB').add({
      'body': this.body,
      'writer_id':this.writer_id,
      'time':this.time,
      'writer_nickname' : this.writer_nickname,
      'change' : this.change
    });
    // if(communityItem.commentNum == 0){
    //   FirebaseFirestore.instance.collection('CommunityDB').doc(communityItem.doc_id).set({"modify":""});
    //   print("modified Comment Number");
    // }
  }
  static CommentItem getDatafromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommentItem(
      writer_id : doc['writer_id'],
      writer_nickname: doc['writer_nickname'],
      body : doc['body'],
      time : stamp.toDate(),
      doc_id: doc.id,
      change: doc['change']
    );
    return item;
  }
  void setChange(){
    this.change = !this.change;
  }
}