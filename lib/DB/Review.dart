import 'package:cloud_firestore/cloud_firestore.dart';
import 'Data.dart';

class Review extends Data<Review> {
  Review({
    this.content = "",
    this.writer = "",
    this.time
  });

  String content;
  String writer;
  DateTime? time;

  @override
  void add(E) {
    FirebaseFirestore.instance.collection('reviewDB').add({
      'content': E.content,
      'writer': E.writer,
      'time': E.time,
    });
  }

  @override
  Review getDataFromDoc(DocumentSnapshot<Object?> doc) {
    return Review(
      content: doc['content'],
      writer: doc['writer'],
      time: doc['time']
    );
  }

}