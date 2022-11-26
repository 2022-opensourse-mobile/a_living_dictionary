

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Logineduser  with ChangeNotifier {
  String uid = '';
  String nickName ='';
  String email ='';
  String profileImageUrl = '';
  String doc_id = '';


  void setInfo(uid, nickName, email, profileImageUrl) {
    this.uid = uid;
    this.nickName = nickName;
    this.email = email;
    this.profileImageUrl = profileImageUrl;
  }
  void setDocID(doc_id){
    this.doc_id = doc_id;
  }
}