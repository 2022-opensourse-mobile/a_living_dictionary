import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

ThemeColor themeColor = ThemeColor();

// Google Map API Key
final _mapApiKey = 'AIzaSyDV1uWDF4S16dDx5oQAAJ399p3e9Cbot90';

final GlobalKey searchKey = GlobalKey(); // 키 생성


class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          restaurantSearch(),
          tempMap(),
          recommendList(),
        ],
      ),
      floatingActionButton: editButton(),
    );
  }
}

/* -------------------------------- 검색 위젯: 일단 3개 작성 (삭제 금지) */
Widget restaurantSearch(){
  return Row(
    key: searchKey,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10,0,10,10),
          child: TextButton(
            onPressed: () {}, //버튼 눌렀을 때 주소 검색지로 이동해야 함
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xfff2f3f6))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('위치 검색', style: TextStyle(color: Color(0xff81858d)), textScaleFactor: 1.1),
                Icon(Icons.search_rounded, color: Color(0xff81858d)),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget searchDesign() {
  return Row(
    children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 4),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Color(0xfff2f3f6),
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.search_rounded, color: Color(0xff81858d)),
              ),
              Text("검색", style: TextStyle(color: Color(0xff81858d)),),
            ],
          ),
        ),
      )
    ],
  );
}

Widget textfieldSearch() {
  return Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
    child: TextFormField(
      onTap: () {},
      decoration: InputDecoration(
        suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.search), color: Color(0xff81858d),),
        hintText: '위치 검색',
        hintStyle: TextStyle(
          fontSize: (16/360),
          color: Color(0xff81858d),
        ),
        border: InputBorder.none,
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(20)),
        // ),
        filled: true,
        fillColor: Color(0xfff2f3f6),
      ),
    ),
  );
}

/* -------------------------------- Map 불러올 임시 공간 */
Widget tempMap() {
  return Container(
    width: double.infinity,
    height: 450,
    color: Colors.grey,
    child: Map(),
  );
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;

  // TODO: DB marker 정리
  static int id = 0; // 마커 id
  static int id2 = 0; // DB에서 긁어올 임시 id
  final List<Marker> markers = []; // 마커를 등록할 목록

  // 지도 클릭 시, 마커 등록
  void addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
          position: coordinate,
          markerId: MarkerId((++id).toString()),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('MapDB')
                    .where('latitude', isEqualTo: coordinate.latitude)
                    .where('longitude', isEqualTo: coordinate.longitude).snapshots(),

                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData)
                      return CircularProgressIndicator();
                    final documents = snapshot.data!.docs;

                    return Column(
                      children: [
                        Text("가게 이름: ${documents[0]['store'].toString()}"),
                        Text("주소: ${documents[0]['address'].toString()}"),
                        Text("좋아요 수: ${documents[0]['like'].toString()}"),
                        // Text("markId: ${documents[0]['markId'].toString()}"),
                      ],
                    );
                  },
                );
              },
            );
          }
      ));
    });
  }

  // // addMarker_마커 위에 달리는 정보
  // infoWindow: InfoWindow(
  //   onTap: () {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => ShowInformation()));
  //   }
  // )

  // DB에 저장된 마커 지도에 추가하기
  Widget getMarker(BuildContext context) {
    double lat, lng;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;

        for (int i=0; i<documents.length; i++) {
          lat = double.parse(documents[i]['latitude'].toString());
          lng = double.parse(documents[i]['longitude'].toString());
          markers.add(Marker(
            position: LatLng(lat, lng),
            // markerId: MarkerId(documents[i]['markId'].toString()), // TODO: 마커 정리되면 코드 이걸로 변경
            markerId: MarkerId((++id2).toString()),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      Text("가게 이름: ${documents[i]['store'].toString()}"),
                      Text("주소: ${documents[i]['address'].toString()}"),
                      Text("좋아요 수: ${documents[i]['like'].toString()}"),
                    ],
                  );
                }
              );
            }
          ));
        }
        return googleMap();
      },
    );
  }

  // 구글 지도
  Widget googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialLocation,

      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _controller = controller;
        });
      },
      markers: markers.toSet(),
      myLocationEnabled: true, // 현재 위치를 파란색 점으로 표시
      myLocationButtonEnabled: true, // 현재 위치 버튼
      onTap: (coordinate) { // 클릭한 위치 중앙에 표시
        _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
        addMarker(coordinate); // 마커 추가
        saveLocation(context, coordinate.latitude, coordinate.longitude, id); // 마커 위치 DB에 저장
      },
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()
        )
      },
    );
  }

  // 초기 위치 설정(금오공대)
  static final CameraPosition _initialLocation = CameraPosition(
    target: LatLng(36.1461382, 128.3934882),
    zoom: 16.0,
  );

  // DB에 마커 위치 저장
  Future<void> saveLocation(BuildContext context, lat, double lng, int id) async {
    var url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat}, ${lng}&key=${_mapApiKey}&language=ko';

    var response = await http.get(Uri.parse(url));
    var responseBody = convert.utf8.decode(response.bodyBytes);

    var address = convert.jsonDecode(responseBody)['results'][0]['formatted_address'];

    FirebaseFirestore.instance.collection('MapDB').add({
      'latitude': lat, 'longitude': lng, 'like': 0,
      'address': address,
      'store': "테스트 $id",
      'markId': id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getMarker(context),
    );
  }
}






/* -------------------------------- 추천 리스트 (수정 중) */
Widget recommendList(){
  return Container(
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10,20,10,10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('근처 추천 맛집', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.4),
                  //Icon(Icons.star_rounded, color: Colors.amberAccent),
                ],
              ),
              postList('메가커피 금오공대점', '4.5', '딸기쿠키프라페 짱!!'),
              postList('아리랑컵밥 금오공대점', '5.0', '낙지컵밥 냠냠'),
              postList('어벤더치 금오공대점', '5.0', '아이스크림 맛있어요'),
              postList('메가커피 금오공대점', '4.5', '딸기쿠키프라페 짱!!'),
              postList('아리랑컵밥 금오공대점', '5.0', '낙지컵밥 냠냠'),
            ],
          ),
        ),
      ],
    )
  );
}

/* -------------------------------- 게시글 출력 (수정 중) */
Widget postList(String text, String star, String description) {
  return Row(
    children: [
      Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('$text', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.20), //가게명
                    Icon(Icons.star_rounded, color: Colors.amberAccent,),
                    Text('$star', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.20), //별점
                  ],
                ),
                Text('$description', style: TextStyle(color: Colors.grey), textScaleFactor: 1.0), //평가 (서술)
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

/* -------------------------------- 글 쓰기 버튼 (수정 중) */
Widget editButton() {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              tooltip: "맨 위로",
              onPressed: () { Scrollable.ensureVisible(searchKey.currentContext!); },
              child: Icon(Icons.arrow_upward_rounded),
              backgroundColor: themeColor.getColor(),
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              tooltip: "글 쓰기",
              onPressed: () {},
              child: Icon(Icons.edit),
              backgroundColor: themeColor.getColor(),
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
            ),
          ),
        ],
      ),
    ],
  );
}