
import 'package:flutter/material.dart';


class Logineduser  with ChangeNotifier {
  String doc_id = '';
  String uid = '';
  String nickName ='';
  String email ='';
  String profileImageUrl = '';

  void setInfo(uid, nickName, email, profileImageUrl) {
    this.uid = uid;
    this.nickName = nickName;
    this.email = email;
    this.profileImageUrl = profileImageUrl;

    notifyListeners();
  }

  void setNickName(nickName) {
    this.nickName = nickName;

    notifyListeners();
  }

  void setDocID(doc_id) {
    this.doc_id = doc_id;
  }
}