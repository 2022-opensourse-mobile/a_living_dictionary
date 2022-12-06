import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionItem{
  String title;
  String content;
  String writerID;
  String writerNickname;
  String writerEmail;
  late DateTime time;

  QuestionItem({
    this.title ='',
    this.content = '',
    this.writerID = '',
    this.writerEmail = '',
    this.writerNickname = '',
  });

  void add(DateTime inputTime){
    time = inputTime;
    FirebaseFirestore.instance.collection('QuestionDB').add({
      'title': title,
      'content' : content,
      'writerID' : writerID,
      'writerEmail' : writerEmail,
      'writerNickname' : writerNickname,
      'time' : time
    });
  }
}