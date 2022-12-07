
import 'package:flutter/material.dart';


class LoginedUser  with ChangeNotifier {
  String doc_id = '';
  String uid = '';
  String nickName ='';
  String email ='';
  String profileImageUrl = '';
  bool admin = false;

  void setInfo(uid, nickName, email, profileImageUrl, admin) {
    this.uid = uid;
    this.nickName = nickName;
    this.email = email;
    this.profileImageUrl = profileImageUrl;
    this.admin = admin;

  }

  void setNickName(nickName) {
    this.nickName = nickName;

    notifyListeners();
  }

  void setProfileImageUrl(profileImageUrl) {
    this.profileImageUrl = profileImageUrl;

    notifyListeners();
  }

  void setDocID(doc_id) {
    this.doc_id = doc_id;
  }

  String getDocID() {
    return this.doc_id;
  }
}