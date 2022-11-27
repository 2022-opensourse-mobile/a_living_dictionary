import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DictionaryItemInfo with ChangeNotifier{
  String doc_id ='';
  var author='';
  int card_num=0;
  DateTime? date= DateTime.now(); //Timestamp.now().toDate(),
  var hashtag='';
  int scrapnum=0;
  
  String thumbnail='';
  String title='';

  void setInfo(doc_id, author, card_num, date, hashtag, scrapnum, thumbnail, title) {
    this.doc_id = doc_id;
    this.author = author;
    this.card_num = card_num;
    this.date = date.toDate();
    this.hashtag = hashtag;
    this.scrapnum = scrapnum;
    this.thumbnail = thumbnail;
    this.title = title; 
  }

  void addScrapNum(dic_id) {  // 스크랩 수를 하나 늘림
    scrapnum++;
    FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).update({
      'scrapnum': scrapnum
    }); 
    notifyListeners();
  }

  void subScrapNum(dic_id) {  // 스크랩 수를 하나 줄임
    scrapnum--;
    FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).update({
      'scrapnum': scrapnum
    });
    notifyListeners();
  }
}