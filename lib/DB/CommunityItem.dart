
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/CommunityPostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:a_living_dictionary/UI/Supplementary/PageRouteWithAnimation.dart';

class CommunityItem{
  String doc_id = '';
  String title = '';
  String writerID = '';
  String writerNickname = '';
  String body = '';
  int like = 0;
  DateTime? time;
  int boardType = 0;
  String hashTag = '';
  String profileImage;


  CommunityItem({
    this.title = '',
    this.writerID = '',
    this.body = '',
    this.like = 0,
    this.boardType = 0,
    this.hashTag = "#잡담",
    this.doc_id = '',
    this.writerNickname = '',
    this.time,
    this.profileImage = ''
  });


  void add() {
    Timestamp stamp = Timestamp.fromDate(time!);
    FirebaseFirestore.instance.collection('CommunityDB').add({
      'title': title,
      'like': like,
      'writer_id': writerID,
      'body':body,
      'time': stamp,
      'boardType':boardType,
      'hashTag':hashTag,
      'writer_nickname':writerNickname,
      'profileImage' : profileImage
    }).then((value) => FirebaseFirestore.instance.collection('CommunityDB').doc(value.id).update({'doc_id':value.id}));

  }
  Future<void> delete(Logineduser user) async {
    final instance = FirebaseFirestore.instance.collection('CommunityDB').doc(doc_id).collection('CommentDB');
    await FirebaseFirestore.instance.collection('CommunityDB').doc(doc_id).delete();
    await for (var snapshot in instance.snapshots()){
      for (var doc in snapshot.docs){
        CommentItem.getDatafromDoc(doc).delete(this, user);
      }
    }
  }
  static CommunityItem getDataFromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommunityItem(
        doc_id : doc.id,
        title : doc['title'],
        writerID : doc['writer_id'],
        writerNickname: doc['writer_nickname'],
        profileImage: doc['profileImage'],
        body : doc['body'],
        like : doc['like'],
        time : stamp.toDate(),
        boardType : doc['boardType'],
        hashTag : doc['hashTag'],
    );
    if(item.like >= 10 && item.boardType == 0){
      item.boardType = 1;
      FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id).update({'boardType' : item.boardType});
    }
    return item;
  }


  void addLikeNum(){
    like++;
    FirebaseFirestore.instance.collection('CommunityDB').doc(doc_id).update({
      'like': like
    });
    if(isHotPost() && boardType != 2){
      updateBoardType(1);
    }
  }
  void subLikeNum(){
    like--;
    FirebaseFirestore.instance.collection('CommunityDB').doc(doc_id).update({
      'like': like
    });
    if(!isHotPost() && boardType != 2){
      updateBoardType(0);
    }
  }
  bool isHotPost(){
    return (like >= 10);
  }
  void updateBoardType(i){
    boardType = i;
    FirebaseFirestore.instance.collection('CommunityDB').doc(doc_id).update({
      'boardType': boardType
    });
  }
  void registerThisPost(Logineduser user){
    FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('LikeList').add({
      'like_doc_id' : doc_id
    }).then((value) => FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('LikeList').doc(value.id).update(
        {'id':value.id}));
  }
  void unRegisterThisPost(Logineduser user) async {
    final instance = FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('LikeList');
    await for (var snapshot in instance.snapshots()){
      for (var doc in snapshot.docs){
        if(doc['like_doc_id'] == doc_id){
          instance.doc(doc['id']).delete();
        }
      }
    }
  }



  Widget build(BuildContext context, {String? commentItemID}) {
    String timeText = getTime();
    String omittedBody = getOmittedBody();

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                    child: Text(hashTag, style: TextStyle(color: themeColor.getColor()), textScaleFactor: 0.8)
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                    child: Text(title.toString()),
                ),
              ],
            ),

            subtitle: Text(omittedBody),
            shape: const RoundedRectangleBorder(
                side: BorderSide(style: BorderStyle.none)
            ),
            trailing: Text(timeText),
            style: ListTileStyle.list,
            onTap: () {
              String tabName = getTabName(boardType);
              PageRouteWithAnimation pageRouteWithAnimation = (commentItemID == null)
                  ? (PageRouteWithAnimation(CommunityPostPage(tabName, this)))
                  : (PageRouteWithAnimation(CommunityPostPage(tabName, this, commentItemID: commentItemID)));
              Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
            },
          ),
          const Divider(thickness: 1.0)
        ],
      ),
    );
  }
  String getOmittedBody(){
    int n = body.indexOf('\n');
    if(n == -1) {
      n = (body.length > 10) ?(10):(body.length);
    }
    String omittedBody = body.substring(0, n);
    if(n == 10) omittedBody += "...";
    return omittedBody;
  }
  String getTime(){
    int hour = time!.hour;
    int minute = time!.minute;
    String hourText = (hour < 10)?("0$hour"):("$hour");
    String minuteText = (minute < 10)?("0$minute"):("$minute");
    return "$hourText:$minuteText";
  }

  Widget buildMain(BuildContext context) {
    String timeText = getTime();
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontSize: 15.8)),
          visualDensity: const VisualDensity(vertical: -4),
          dense: true,
          trailing: Text(timeText),
          onTap: (){
            String tabName = getTabName(boardType);
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
        return "인기글";
      case 2:
        return "공지글";
      default:
        return "최신글";
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
  String writerID;
  String writerNickname;
  String profileImage;
  String body;
  DateTime? time;
  String doc_id;
  CommentItem({this.writerID = '', this.body = '', this.time, this.writerNickname = '', this.doc_id = '', this.profileImage = ''});

  void add(CommunityItem communityItem) async {
    final instance = FirebaseFirestore.instance.collection('CommunityDB').doc(communityItem.doc_id).collection('CommentDB');
    if(time == null){
      return;
    }
    instance.add({
      'body': body,
      'writer_id':writerID,
      'time':time,
      'writer_nickname' : writerNickname,
      'profileImage' : profileImage
    }).then((value) async {
      instance.doc(value.id).update({'doc_id':value.id});
      await for(var snap in instance.snapshots()){
        for(var doc in snap.docs){
          if(doc.id == value.id){
            doc_id = doc.id;
          }
        }
      }
    });

  }
  void delete (CommunityItem item, Logineduser user) async {
    FirebaseFirestore.instance.collection('CommunityDB').doc(item.doc_id)
        .collection('CommentDB').doc(doc_id).delete();

    final instance = FirebaseFirestore.instance.collection('userInfo').doc(user.doc_id).collection('CommentList');
    await for(var snapshot in instance.snapshots()){
      for (var doc in snapshot.docs){
        if(doc.get('comment_id') == doc_id) {
          instance.doc(doc.id).delete();
        }
      }
    }
  }
  static CommentItem getDatafromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommentItem(
      writerID : doc['writer_id'],
      writerNickname: doc['writer_nickname'],
      body : doc['body'],
      time : stamp.toDate(),
      doc_id: doc.id,
      profileImage: doc['profileImage']
    );
    return item;
  }
}