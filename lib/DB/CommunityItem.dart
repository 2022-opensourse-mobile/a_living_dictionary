
import 'package:a_living_dictionary/UI/Supplementary/CommunityPostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Data.dart';

class CommunityItem with ChangeNotifier{
  String title = '';
  String writer_id = '';
  String body = '';
  int like = 0;
  DateTime? time;
  int boardType = 0;
  String hashTag = '';
  String doc_id = '';

  CommunityItem({
    this.title = '',
    this.writer_id = '',
    this.body = '',
    this.like = 0,
    this.boardType = 0,
    this.hashTag = '',
    this.doc_id = '',
    this.time
  }){}

  //add Post
  @override
  void add() {
    Timestamp stamp = Timestamp.fromDate(this.time!);
    FirebaseFirestore.instance.collection('CommunityDB').add({
      'title': this.title,
      'like': this.like,
      'writer_id': this.writer_id,
      'body':this.body,
      'time': stamp,
      'boardType':this.boardType,
      'hashTag':this.hashTag
    });
  }


  //일반 build
  @override
  Widget build(BuildContext context) {
    String t = '${this.time!.hour.toString()}:${this.time!.minute.toString()}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Column(
        children: [
          ListTile(
            title: Text("${this.title}  ${this.writer_id}"),
            subtitle: Text(this.body),
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

  //Firebase db의 데이터를 Post로 변환
  static CommunityItem getDataFromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommunityItem(
        doc_id : doc.id,
        title : doc['title'],
        writer_id : doc['writer_id'],
        body : doc['body'],
        like : doc['like'],
        time : stamp.toDate(),
        boardType : doc['boardType'],
        hashTag : doc['hashTag']);
    return item;
  }
  //MainPage에서 사용, 하나의 doc을 받아서 하나의 리스트 원소 출력
  Widget buildMain(BuildContext context) {
    String t = '${this.time!.hour.toString()}:${this.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
        child: ListTile(
          title: Text(this.title),
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
  //document 리스트를 일부 elements만 뽑아서 return
  List<Widget> getWidgetList(BuildContext context, List<QueryDocumentSnapshot<Object?>> doc, int boardType){
    final board = doc.where((item)=> item['boardType'] == boardType).toList();
    final subList = board.sublist(0,4);
    final buildList = subList.map((doc){
      final item = CommunityItem.getDataFromDoc(doc);
      return item.buildMain(context);
    }).toList();
    return buildList;
  }
}


class CommentItem{
  String writer_id;
  String body;
  DateTime? time;
  CommentItem({this.writer_id = '', this.body = '', this.time});

  void add(String doc_id){
    if(time == null){
      print("comment add error : there's no time");
      return;
    }
    FirebaseFirestore.instance.collection('CommunityDB').doc(doc_id).collection('CommentDB').add({
      'body': this.body,
      'writer_id':this.writer_id,
      'time':this.time
    });
  }
  static CommentItem getDatafromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommentItem(
      writer_id : doc['writer_id'],
      body : doc['body'],
      time : stamp.toDate()
    );
    return item;
  }


}