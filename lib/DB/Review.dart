import 'package:cloud_firestore/cloud_firestore.dart';
import 'Data.dart';

class Review extends Data<Review> {
  Review({
    this.content = "",
    this.writer = "",
  });

  String content;
  String writer;

  @override
  void add(E) {
    FirebaseFirestore.instance.collection('reviewDB').add({
      'content': E.content,
      'writer': E.writer
    });
  }

  @override
  Review getDataFromDoc(DocumentSnapshot<Object?> doc) {
    return Review(
      content: doc['content'],
      writer: doc['writer']
    );
  }

}