
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Data<E>{
  //DB에서 데이터 받아서 클래스로 바꾸는 함수
  E getDataFromDoc(DocumentSnapshot doc);
  //DB로 데이터 저장하는 함수
  void add(E);
}
