
import 'package:a_living_dictionary/UI/Supplementary/CommunityPostPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Data.dart';

class Post extends Data<Post>{
  static int n = 0;
  int id;
  String title;
  String writer_name;
  String writer_id;
  String body;
  int like;
  DateTime? time;
  int boardType;
  String hashTag;

  Post({
    this.id = 0,
    this.title = '',
    this.writer_name = '',
    this.writer_id = '',
    this.body = '',
    this.like = 0,
    this.time,
    this.boardType = 1,
    this.hashTag = ''}) {}

  //add Post
  @override
  void add(E) {
    Timestamp stamp = Timestamp.now();
    FirebaseFirestore.instance.collection('communityDB').add({
      'id':E.id,
      'title': E.toString(),
      'like':E.like,
      'writer_name':E.toString(),
      'writer_id':E.toString(),
      'body':E.toString(),
      'time': stamp,
      'boardType':1,
      'hashTag':E.hashTag.toString()
    });
  }

  //일반 build
  @override
  Widget build(DocumentSnapshot<Object?> doc, BuildContext context) {
    final post = getDataFromDoc(doc);
    String t = '${post.time!.hour.toString()}:${post.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
        child: Card(
          child: ListTile(
            title: Text(post.id.toString() + " " + post.title),
            subtitle: Text(post.body),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(style: BorderStyle.none)),
            trailing: Text(t),
            style: ListTileStyle.list,
            onTap: (){
              String tabName;
              switch(post.boardType){
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
                  MaterialPageRoute(builder: (context) => CommunityPostPage(tabName))
              );
            },
          ),
        )
    );
  }

  //Firebase db의 데이터를 Post로 변환
  Post getDataFromDoc(DocumentSnapshot doc){
    Timestamp stamp = doc['time'];
    final post = Post(
        id: doc['id'],
        title: doc['title'],
        writer_name: doc['writer_name'],
        writer_id: doc['writer_id'],
        body: doc['body'],
        like: doc['like'],
        time: stamp.toDate(),
        boardType: doc['boardType'],
        hashTag: doc['hashTag']);
    return post;
  }
  //MainPage에서 사용, 하나의 doc을 받아서 하나의 리스트 원소 출력
  Widget buildMain(DocumentSnapshot doc) {
    final post = getDataFromDoc(doc);
    String t = '${post.time!.hour.toString()}:${post.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
        child: ListTile(
          title: Text(post.title),
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