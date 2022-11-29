import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as locator;
import 'Supplementary//ThemeColor.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:a_living_dictionary/nearby_response.dart';

ThemeColor themeColor = ThemeColor();

// Google Map API Key
final _mapApiKey = 'AIzaSyDV1uWDF4S16dDx5oQAAJ399p3e9Cbot90';

final GlobalKey searchKey = GlobalKey(); // 키 생성

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Map(),
      ),
      floatingActionButton: editButton(),
    );
  }
}

/* -------------------------------- Map 공간 */
class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;
  TextEditingController _textEditingController = TextEditingController();
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  static int id = 1; // 마커 id
  final List<Marker> markers = []; // 마커를 등록할 목록
  String m_id = ""; // Map Id & 선택한 장소

  // DB에 저장된 마커 지도에 추가하기(좋아요 100개 이상인 마커만)
  // TODO: 좋아요 100개 넘는 DB 따로 나눌 것
  Widget getMarker(BuildContext context) {
    double lat, lng;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();

        final documents = snapshot.data!.docs;

        for (int i=0; i<documents.length; i++) {
          lat = double.parse(documents[i]['latitude'].toString());
          lng = double.parse(documents[i]['longitude'].toString());
          if (int.parse(documents[i]['like'].toString()) >= 100) {
            markers.add(Marker(
                position: LatLng(lat, lng),
                markerId: MarkerId(documents[i]['markId'].toString()),
                onTap: () {
                  m_id = documents[i].id;
                  id = documents[i]['markId'];
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return detailPage(context, m_id, documents[i]['store'], documents[i]['address'], documents[i]['like']);
                      }
                  );
                }
            ));
          }
        }
        return googleMap(context);
      },
    );
  }

  // 음식점 좋아요 누른 경우, 개별 지도에 마커 추가
  // TODO: 좋아요 DB 연결 후 수정할 것
  void addMarker(BuildContext context, double lat, double lng) {
    setState(() {
      markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // 마커 파란색
          position: LatLng(lat, lng),
          markerId: MarkerId((++id).toString()),
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('MapDB')
                        .where('latitude', isEqualTo: lat)
                        .where('longitude', isEqualTo: lng).snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData)
                        return CircularProgressIndicator();
                      final documents = snapshot.data!.docs;
                      m_id = documents[0].id;

                      return detailPage(context, m_id, documents[0]['store'], documents[0]['address'], documents[0]['like']);
                    },
                  );
                }
            );
          }
      ));
    });
  }

  // 마커 클릭 시 나오는 페이지
  // TODO: 좋아요 DB 연결 후 두 버전 중 선택하기(DB 접근 1번, but 입력받는 인자 많음 VS DB 접근 2번, but 입력받는 인자 적음)
  // doc id, store, address, like 수 입력받는 버전 - DB 접근 1번
  Widget detailPage(BuildContext context, String id, String store, String address, int like) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${store} 상세 정보"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('MapDB').doc(id).collection('reviewDB').orderBy('time', descending: true).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return CircularProgressIndicator();

              final documents = snapshot.data!.docs;

              return Column(
                children: [
                  ListTile(title: Text(store),), Divider(),
                  // ListTile(title: Text("좋아요 수: ${like}"),), Divider(),
                  ListTile(
                    title: Row(
                      children: [
                        Text("좋아요 수: ${like}"),
                        Spacer(),
                        IconButton(
                            onPressed: () {

                            },
                            icon: Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(title: Text("주소: ${address}"),), Divider(),
                  ListTile(
                    title: Row(
                      children: [
                        Text("$store 후기"),
                        Spacer(),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => reviewPage(),
                            ));
                          },
                          child: Text("후기 작성"),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(documents[index]['content'].toString()),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  // doc id만 입력받는 버전 - DB 2번 접근
  // Widget detailPage(BuildContext context, String id) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("상세 페이지"),
  //     ),
  //     body: Container(
  //       height: MediaQuery.of(context).size.height,
  //       child: SingleChildScrollView(
  //         child: StreamBuilder(
  //           stream: FirebaseFirestore.instance.collection('MapDB').doc(id).snapshots(),
  //           builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //             if (!snapshot.hasData)
  //               return CircularProgressIndicator();
  //
  //             final mapDocument = snapshot.data!;
  //
  //             return Column(
  //               children: [
  //                 ListTile(title: Text(mapDocument['store'])), Divider(),
  //                 ListTile(
  //                   title: Row(
  //                     children: [
  //                       Text("좋아요 수: ${mapDocument['like']}"),
  //                         Spacer(),
  //                         IconButton(
  //                           onPressed: () {
  //
  //                           },
  //                           icon: Icon(Icons.favorite_border),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Divider(),
  //                   ListTile(title: Text("주소: ${mapDocument['address']}")), Divider(),
  //                   ListTile(
  //                     title: Row(
  //                       children: [
  //                         Text("${mapDocument['store']} 후기"),
  //                         Spacer(),
  //                         ElevatedButton(
  //                           onPressed: (){
  //                             Navigator.push(context, MaterialPageRoute(
  //                               builder: (context) => reviewPage(),
  //                             ));
  //                           },
  //                           child: Text("후기 작성"),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Divider(),
  //                   StreamBuilder(
  //                     stream: FirebaseFirestore.instance.collection('MapDB').doc(id).collection('reviewDB').orderBy('time', descending: true).snapshots(),
  //                     builder: (context, AsyncSnapshot snapshot) {
  //                       if (!snapshot.hasData)
  //                         return CircularProgressIndicator();
  //
  //                       final reviewDocuments = snapshot.data!.docs;
  //
  //                       return ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: reviewDocuments.length,
  //                         itemBuilder: (context, index) {
  //                           return ListTile(
  //                             title: Text(reviewDocuments[index]['content'].toString()),
  //                           );
  //                         },
  //                       );
  //                     }
  //                   ),
  //
  //               ],
  //             );
  //           },
  //         )
  //       ),
  //     ),
  //   );
  // }

  // review 작성 페이지

  Widget reviewPage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("후기 작성"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: TextField(
              decoration: const InputDecoration(
                hintText: "후기 작성",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
              controller: _textEditingController,
              maxLines: null,
              maxLength: 50,
              cursorColor: Colors.black,
            ),
          ),
          ElevatedButton(
            onPressed: (){
              Timestamp timestamp = Timestamp.now();
              if (_textEditingController.text != "") {
                FirebaseFirestore.instance.collection('MapDB').doc(m_id).collection('reviewDB').add({
                  'content': _textEditingController.text.toString(),
                  'writer': '작성자',
                  'time': timestamp,
                });
                _textEditingController.text = "";
                Navigator.pop(context);
              }
            },
            child: Text("후기 등록", textScaleFactor: 1,),
          ),
        ],
      ),
    );
  }

  // 구글 지도
  Widget googleMap(BuildContext context) {
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
      myLocationButtonEnabled: false, // 현재 위치 버튼
      onTap: (coordinate) { // 클릭한 위치 중앙에 표시
        _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
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

  // 현재 위치 구하기
  void _currentLocation() async {
    locator.Location location = new locator.Location();

    bool _serviceEnabled;
    locator.PermissionStatus _permissionGranted;
    locator.LocationData? _currentLocation;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // 위치 권한 확인
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locator.PermissionStatus.granted) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != locator.PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    double curLat = _currentLocation.latitude!;
    double curLng = _currentLocation.longitude!;

    // 현재 위치로 카메라(뷰) 이동
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(curLat, curLng),
        tilt: 0,
        zoom: 17.0,
      ),
    ));

    getNearbyPlaces(curLat, curLng);
  }

 // 현재 위치 기준, 근처 음식점 정보 구하기
  void getNearbyPlaces(double lat, double lng) async {
    var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${lng}&radius=1000&key=${_mapApiKey}&types=restaurant&language=ko';

    var response = await http.post(Uri.parse(url));

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(convert.jsonDecode(response.body));

    if(nearbyPlacesResponse.results != null)
      for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++) {
        Results results = nearbyPlacesResponse.results![i];
        saveLocation(results.name!, results.vicinity!, double.parse(results.geometry!.location!.lat.toString()),
            double.parse(results.geometry!.location!.lng.toString()));
      }
    setState(() {});
  }

  // 음식점 정보 DB에 저장
  Future<void> saveLocation(String store, String addres, double lat, double lng) async {
    await FirebaseFirestore.instance.collection('MapDB').where('store', isEqualTo: store).get().then((QuerySnapshot snapshot) => {
      if (snapshot.size == 0) {
        FirebaseFirestore.instance.collection('MapDB').add({
          'latitude': lat, 'longitude': lng,
          'like': 0,
          'address': addres,
          'store': store,
          'markId': id,
        })
      }
    });
  }

  // 근처 음식점 정보 위젯으로 출력
  Widget nearbyPlacesWidget(Results results) {
    String store = results.name!;
    String address = results.vicinity!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').where('store', isEqualTo: store).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();
        
        final documents = snapshot.data!.docs;

        return Container(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Card(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("음식점: $store"),
                    Text("주소: $address"),
                    // if(results.rating != null) Text("평점: " + results.rating!.toString()),
                    Text("오픈 여부: " + (results.openingHours != null ? "Open" : "Closed")),
                  ],
                ),
              ),
            ),
            onTap: () {
              m_id = documents[0].id;
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => detailPage(context, m_id, store, address, documents[0]['like']),
              ));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 450,
          color: Colors.grey,
          child: Stack(
            children: [
              getMarker(context),
              FloatingActionButton(
                onPressed: () {
                  _currentLocation();
                },
                child: Icon(Icons.location_searching),
              ),
            ],
          ),
        ),
        Divider(thickness: 0.5,),
        if(nearbyPlacesResponse.results != null)
          for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
            nearbyPlacesWidget(nearbyPlacesResponse.results![i])
      ],
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
                postList('어벤더치 금오공대점', '5.0', '아이스크림 맛있어요'),
                postList('메가커피 금오공대점', '4.5', '딸기쿠키프라페 짱!!'),
                postList('아리랑컵밥 금오공대점', '5.0', '낙지컵밥 냠냠'),
                postList('어벤더치 금오공대점', '5.0', '아이스크림 맛있어요'),
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
              heroTag: 'up', // 에러나서 floatingActionButton 구분할 Tag 추가
              tooltip: "맨 위로",
              onPressed: () {
                Scrollable.ensureVisible(
                    searchKey.currentContext!,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
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
              heroTag: 'write', // 에러나서 floatingActionButton 구분할 Tag 추가
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

/* -------------------------------- 검색 위젯: 일단 3개 작성 (삭제 금지) */
Widget restaurantSearch(){
  return Row(
    key: searchKey,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10,0,10,5),
          child: TextButton(
            onPressed: () {}, //버튼 눌렀을 때 주소 검색지로 이동해야 함
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xfff2f3f6))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('위치 검색', style: TextStyle(color: Color(0xff81858d), leadingDistribution: TextLeadingDistribution.even,), textScaleFactor: 1.1),
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