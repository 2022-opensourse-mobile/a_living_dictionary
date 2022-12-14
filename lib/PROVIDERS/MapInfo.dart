import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapInfo with ChangeNotifier {
  String doc_id;
  String address;
  String store;
  double latitude;
  double longitude;
  int like;

  MapInfo({
    this.doc_id = "",
    this.address = "",
    this.store = "",
    this.latitude=0.0,
    this.longitude=0.0,
    this.like=0,
  });

  void setInfo(doc_id, address, store, latitude, longitude, like) {
    this.doc_id = doc_id;
    this.address = address;
    this.store = store;
    this.latitude = latitude;
    this.longitude = longitude;
    this.like = like;
  }

  // 좋아요 수 1 증가
  void addLikeNum(doc_id) {
    like++;
    FirebaseFirestore.instance.collection('MapDB').doc(doc_id).update({
      'like': like
    });
    notifyListeners();
  }

  // 좋아요 수 1 감소
  void subLikeNum(doc_id) {
    like--;
    FirebaseFirestore.instance.collection('MapDB').doc(doc_id).update({
      'like': like
    });
    notifyListeners();
  }
}