
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Data<E>{
  //DB에서 데이터 받아서 클래스로 바꾸는 함수
  E getPostFromDoc(DocumentSnapshot doc);
  //DB로 데이터 저장하는 함수
  void add(E);
  //해당 페이지에서 사용, DB의 데이터를 Widget으로 바꾸는 함수
  //페이지에서 children: documents.map((doc)=> Post.buildListItemDB(doc)).toList() 와 같이 사용
  Widget build(DocumentSnapshot doc);
}
