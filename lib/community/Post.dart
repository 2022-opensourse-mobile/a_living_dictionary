
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
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


  static Post getPostFromDoc(DocumentSnapshot doc){
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
  static void addPost(int i){
    Timestamp stamp = Timestamp.now();
    FirebaseFirestore.instance.collection('communityDB').add({
      'id':i,
      'title': i.toString(),
      'like':i,
      'writer_name':i.toString(),
      'writer_id':i.toString(),
      'body':i.toString(),
      'time': stamp,
      'boardType':1,
      'hashTag':i.toString()
    });
  }

  static Widget buildMainListItemDB(DocumentSnapshot doc) {
    final post = getPostFromDoc(doc);
    String t = '${post.time!.hour.toString()}:${post.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: ListTile(
          title: Text(post.title),
          visualDensity: VisualDensity(vertical: -4),
          dense: true,
          trailing: Text(t),
          onTap: (){},
        ));
  }

  static Widget buildListItemDB(DocumentSnapshot doc) {
    final post = getPostFromDoc(doc);
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
          ),
        )
    );
  }

  static List<Widget> getWidgetList(List<QueryDocumentSnapshot<Object?>> doc){
    final d = doc.where((doc){return doc['id'] < 7 == true;});
    var dl = d.map((e) => buildMainListItemDB(e)).toList();
    return dl;
  }
}