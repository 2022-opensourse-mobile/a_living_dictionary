import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionItem{
  QuestionItem({
    this.title ='',
    this.content = '',
    this.writerID = '',
    this.writerEmail = '',
    this.writerNickname = '',
  });
  String title;
  String content;
  late DateTime time;

  String writerID;
  String writerNickname;
  String writerEmail;

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