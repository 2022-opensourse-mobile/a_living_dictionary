
import 'package:a_living_dictionary/UI/Supplementary/CommunityPostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Data.dart';

class CommunityItem extends Data<CommunityItem>{
  String title;
  String writer_id;
  String body;
  int like;
  DateTime? time;
  int boardType;
  String hashTag;

  CommunityItem({
    this.title = '',
    this.writer_id = '',
    this.body = '',
    this.like = 0,
    this.time,
    this.boardType = 1,
    this.hashTag = ''}) {}

  //add Post
  @override
  void add(E) {
    CommunityItem it = E as CommunityItem;
    Timestamp stamp = Timestamp.fromDate(it.time!);
    FirebaseFirestore.instance.collection('CommunityDB').add({
      'title': it.title,
      'like': it.like,
      'writer_id': it.writer_id,
      'body':it.body,
      'time': stamp,
      'boardType':it.boardType,
      'hashTag':it.hashTag
    });
  }

  void postAdd(){
    for(int i = 0; i < 10; i++){
      CommunityItem it = CommunityItem(
        writer_id: "a",
        boardType: 0,
        title: i.toString(),
        body: i.toString(),
        hashTag: "자유",
        like: i,
        time: DateTime.now()
      );
      add(it);
    }
  }


  //일반 build
  @override
  Widget build(DocumentSnapshot<Object?> doc, BuildContext context) {
    final item = getDataFromDoc(doc);
    String t = '${item.time!.hour.toString()}:${item.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
        child: Card(
          child: ListTile(
            title: Text(item.title.toString() + " " + item.writer_id),
            subtitle: Text(item.body),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(style: BorderStyle.none)),
            trailing: Text(t),
            style: ListTileStyle.list,
            onTap: (){
              String tabName;
              switch(item.boardType){
                case 1:
                  tabName = "인기게시판";
                  break;
                case 2:
                  tabName = "공지게시판";
                  break;
                default:
                  tabName = "자유게시판";
                  break;
              }

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CommunityPostPage(tabName, doc.id))
              );
            },
          ),
        )
    );
  }

  //Firebase db의 데이터를 Post로 변환
  CommunityItem getDataFromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final item = CommunityItem(
        title: doc['title'],
        writer_id: doc['writer_id'],
        body: doc['body'],
        like: doc['like'],
        time: stamp.toDate(),
        boardType: doc['boardType'],
        hashTag: doc['hashTag']);
    return item;
  }
  //MainPage에서 사용, 하나의 doc을 받아서 하나의 리스트 원소 출력
  Widget buildMain(DocumentSnapshot doc) {
    final item = getDataFromDoc(doc);
    String t = '${item.time!.hour.toString()}:${item.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
        child: ListTile(
          title: Text(item.title),
          visualDensity: VisualDensity(vertical: -4),
          dense: true,
          trailing: Text(t),
          onTap: (){},
        ));
  }
  //document 리스트를 일부 elements만 뽑아서 return
  List<Widget> getWidgetList(List<QueryDocumentSnapshot<Object?>> doc){
    final d = doc.where((doc){return doc['id'] < 7 == true;});
    var dl = d.map((e) => buildMain(e)).toList();
    return dl;
  }
}