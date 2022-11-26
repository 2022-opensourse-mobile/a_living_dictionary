

import 'package:flutter/cupertino.dart';

class Logineduser  with ChangeNotifier {
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
}