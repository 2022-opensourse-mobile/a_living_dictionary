import 'package:cloud_firestore/cloud_firestore.dart';
import 'Data.dart';

class Map extends Data<Map> {
  Map({
    this.address = "",
    this.store = "",
    this.latitude = 36.1461382,
    this.longitude = 128.3934882,
    this.like = 0,
    this.markId = 0,
  });

  String address; // 주소
  String store; // 가게명
  double latitude; // 위도
  double longitude; // 경도
  int like; // 좋아요 수
  int markId; // 마커 번호

  @override
  void add(E) {
    FirebaseFirestore.instance.collection('MapDB').add({
      'address': E.address,
      'store': E.store,
      'latitude': E.latitude,
      'longitude': E.longitude,
      'like': E.like,
      'markId': E.markId,
    });
  }

  @override
  Map getDataFromDoc(DocumentSnapshot<Object?> doc) {
    return Map(
      address: doc['address'],
      store: doc['store'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      like: doc['like'],
      markId: doc['markId'],
    );
  }
}