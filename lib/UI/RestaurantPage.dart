import 'package:a_living_dictionary/PROVIDERS/MapInfo.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:a_living_dictionary/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as locator;
import 'package:provider/provider.dart';
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

final GlobalKey scrollKey = GlobalKey(); // 키 생성

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Map(),
      ),
      floatingActionButton: upButton(),
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
  MapInfo mapInfo = MapInfo();

  final List<Marker> markers = []; // 마커를 등록할 목록
  String m_id = ""; // Map Id

  // DB에 저장된 마커 지도에 추가(좋아요 100개 이상인 마커만)
  // TODO: 좋아요 100개 넘는 DB 따로 만들어서 가져오기
  Widget getMarker(BuildContext context) {
    double lat, lng;
    String store;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();

        final documents = snapshot.data!.docs;

        for (int i = 0; i < documents.length; i++) {
          lat = double.parse(documents[i]['latitude'].toString());
          lng = double.parse(documents[i]['longitude'].toString());
          store = documents[i]['store'];
          if (int.parse(documents[i]['like'].toString()) >= 100) { // 좋아요가 100개 이상인 것만 마커 추가
            markers.add(Marker(
                position: LatLng(lat, lng),
                markerId: MarkerId(store),
                infoWindow: InfoWindow(
                  title: store,
                ),
                // onTap: () {
                //   m_id = documents[i].id;
                //   mapInfo.setInfo(m_id, documents[i]['address'], documents[i]['store'], lat, lng,
                //       documents[i]['like'], documents[i]['markId']);
                //   Provider.of<MapInfo>(context, listen: false).setInfo(m_id, documents[i]['address'], documents[i]['store'], lat, lng,
                //       documents[i]['like'], documents[i]['markId']);
                //   Navigator.push(context, MaterialPageRoute(
                //     builder: (context) => detailPage(context, m_id),
                //   ));
                // }
            ));
          }
        }
        return googleMap(context);
      },
    );
  }

  // 각 사용자 DB에 저장된 마커(좋아요 표시) 지도에 추가
  Widget getUserMarker(BuildContext context) {
    double lat, lng;
    String store;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userInfo').doc(loginedUser.doc_id).collection('MapLikeList').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();

        final documents = snapshot.data!.docs;

        for (int i = 0; i < documents.length; i++) {
          lat = double.parse(documents[i]['latitude'].toString());
          lng = double.parse(documents[i]['longitude'].toString());
          store = documents[i]['store'];
          markers.add(Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: LatLng(lat, lng),
            markerId: MarkerId(store),
            infoWindow: InfoWindow(
              title: store,
            ),
            // onTap: () {
            //   m_id = documents[i].id;
            //   mapInfo.setInfo(m_id, documents[i]['address'], documents[i]['store'], lat, lng,
            //       documents[i]['like'], documents[i]['markId']);
            //   Provider.of<MapInfo>(context, listen: false).setInfo(m_id, documents[i]['address'], documents[i]['store'], lat, lng,
            //       documents[i]['like'], documents[i]['markId']);
            //   Navigator.push(context, MaterialPageRoute(
            //     builder: (context) => detailPage(context, m_id),
            //   ));
            // }
          ));
        }
        return getMarker(context);
      },
    );
  }

  // 음식점 좋아요 누른 경우, 개별 지도에 마커 추가
  void addMarker(BuildContext context, double lat, double lng, String store) {
    setState(() {
      markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // 마커 파란색
        position: LatLng(lat, lng),
        markerId: MarkerId(store),
        infoWindow: InfoWindow(
          title: store,
        ),
      ));
    });
  }

  void deleteMarker(BuildContext context, String store) {
    MarkerId id = MarkerId(store);
    setState(() {
      // markers.removeWhere((marker) => marker.markerId == MarkerId(store));
      // markers.remove(marker);
      // markers.removeWhere(());
      markers.remove(
        markers.firstWhere((Marker marker) => marker.markerId == MarkerId(store))
      );
    });
  }

  // 좋아요 아이콘
  Widget likeIcon(MapInfo mapProvider, Logineduser userProvider) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
          .where('docID', isEqualTo: mapProvider.doc_id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();

        // 이미 좋아요 누른 경우
        if (snapshot.data!.size != 0) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
            onPressed: () {
              FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                  .where('docID', isEqualTo: mapProvider.doc_id).get().then((value) {
                value.docs.forEach((element) {
                  FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                      .doc(element.id).delete();
                });
              });
              mapProvider.subLikeNum(mapProvider.doc_id);
              // TODO: 좋아요 취소 시, 마커 삭제가 안됨..
              deleteMarker(context, mapProvider.store);
            },
          );
        }
        // 좋아요 안 누른 경우
        else {
          return IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () {
              FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList').add({
                'docID': mapProvider.doc_id,
                'latitude' : mapProvider.latitude,
                'longitude' : mapProvider.longitude,
                'store' : mapProvider.store,
              });
              mapProvider.addLikeNum(mapProvider.doc_id);
              addMarker(context, mapProvider.latitude, mapProvider.longitude, mapProvider.store);
            },
          );
        }
      },
    );
  }
  bool testCheck = false;

  // 마커 클릭 시 나오는 페이지
  // TODO: UI 수정
  Widget detailPage(BuildContext context, String id) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상세 페이지"),
        elevation: 0.0,
      ),
      body: Consumer2<MapInfo, Logineduser>(
          builder: (context, mapProvider, userProvider, child) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('MapDB').doc(id).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return CircularProgressIndicator();

                      final mapDocument = snapshot.data!;

                      return Column(
                        children: [
                          Divider(),
                          // 가게명, 좋아요 수
                          ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    child: Text(mapDocument['store'], textScaleFactor: 1.2,),
                                    // child: Padding(
                                    //   padding: EdgeInsets.all(10),
                                    //   child: Text(mapDocument['store'], textScaleFactor: 1.2,),
                                    // )
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        likeIcon(mapProvider, userProvider),
                                        Text(mapDocument['like'].toString(), textScaleFactor: 1.0,)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          ListTile(title: Text("주소: ${mapDocument['address']}", textScaleFactor: 1.0, overflow: TextOverflow.ellipsis, maxLines: 1,)), Divider(),
                          ListTile(
                            title: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => reviewPage(),
                                ));
                              },
                              child: Text("후기 작성"),
                            ),
                          ),
                          Divider(),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('MapDB').doc(id).collection('reviewDB').orderBy('time', descending: true).snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();

                                final reviewDocuments = snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: reviewDocuments.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(reviewDocuments[index]['content'].toString()),
                                    );
                                  },
                                );
                              }
                          ),
                        ],
                      );
                      // return Column(
                      //   children: [
                      //     Row(
                      //     children: [
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * 0.8,
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text("${mapDocument['store']}", textScaleFactor: 1.2,),
                      //               Text("${documents[0]['address']}",
                      //     textScaleFactor: 1.0,
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 1,
                      //     style: TextStyle(
                      //     color: Colors.grey
                      //     ),),
                      //     ],
                      //     ),
                      //     ),
                      //       ],
                      //     ),
                      // );

                    //   return Column(
                    //     children: [
                    //       ListTile(title: Text(mapDocument['store'])), Divider(),
                    //       ListTile(
                    //         title: Row(
                    //           children: [
                    //             Text("좋아요 수: ${mapProvider.like}"),
                    //             Spacer(),
                    //             likeIcon(mapProvider, userProvider),
                    //
                    //             // StreamBuilder(
                    //             //   stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                    //             //       .where('docID', isEqualTo: mapProvider.doc_id).snapshots(),
                    //             //   builder: (context, snapshot) {
                    //             //     if (!snapshot.hasData)
                    //             //       return CircularProgressIndicator();
                    //             //
                    //             //     // 이미 좋아요 누른 경우
                    //             //     if (snapshot.data!.size != 0) {
                    //             //       return IconButton(
                    //             //         icon: Icon(
                    //             //           Icons.favorite,
                    //             //           color: Colors.pink,
                    //             //           size: 30,
                    //             //         ),
                    //             //         onPressed: () {
                    //             //           FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                    //             //               .where('docID', isEqualTo: mapProvider.doc_id).get().then((value) {
                    //             //             value.docs.forEach((element) {
                    //             //               FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                    //             //                   .doc(element.id).delete();
                    //             //             });
                    //             //           });
                    //             //           mapProvider.subLikeNum(mapProvider.doc_id);
                    //             //           // 마커 삭제 코드 넣기
                    //             //           // deleteMarker 함수 추가해야 함(아마 addMarker와 매개변수 비슷하게 주면 될 듯)
                    //             //           // userInfo에 정보(가게명, 주소, lat, lng) 삭제하기
                    //             //         },
                    //             //       );
                    //             //     }
                    //             //     // 좋아요 안 누른 경우
                    //             //     else {
                    //             //       return IconButton(
                    //             //         icon: Icon(
                    //             //           Icons.favorite_border,
                    //             //           color: Colors.pink,
                    //             //           size: 30,
                    //             //         ),
                    //             //         onPressed: () {
                    //             //           FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList').add({
                    //             //             'docID': mapProvider.doc_id
                    //             //           });
                    //             //           mapProvider.addLikeNum(mapProvider.doc_id);
                    //             //           // 마커 추가 코드 넣기
                    //             //           // addMarker에 userProvider.doc_id랑 mapProvider.doc_id 넘겨주기
                    //             //           // userInfo에 MapDB로부터 가게명, 주소, lat, lng 가져와서 저장 후 마커 찍기
                    //             //         },
                    //             //       );
                    //             //     }
                    //             //   },
                    //             // ),
                    //           ],
                    //         ),
                    //       ),
                    //       Divider(),
                    //       ListTile(title: Text("주소: ${mapDocument['address']}")), Divider(),
                    //       ListTile(
                    //         title: Row(
                    //           children: [
                    //             Text("${mapDocument['store']} 후기"),
                    //             Spacer(),
                    //             ElevatedButton(
                    //               onPressed: () {
                    //                 Navigator.push(context, MaterialPageRoute(
                    //                   builder: (context) => reviewPage(),
                    //                 ));
                    //               },
                    //               child: Text("후기 작성"),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Divider(),
                    //       StreamBuilder(
                    //           stream: FirebaseFirestore.instance.collection('MapDB').doc(id).collection('reviewDB').orderBy('time', descending: true).snapshots(),
                    //           builder: (context, AsyncSnapshot snapshot) {
                    //             if (!snapshot.hasData)
                    //               return CircularProgressIndicator();
                    //
                    //             final reviewDocuments = snapshot.data!.docs;
                    //
                    //             return ListView.builder(
                    //               shrinkWrap: true,
                    //               itemCount: reviewDocuments.length,
                    //               itemBuilder: (context, index) {
                    //                 return ListTile(
                    //                   title: Text(reviewDocuments[index]['content'].toString()),
                    //                 );
                    //               },
                    //             );
                    //           }
                    //       ),
                    //     ],
                    //   );
                    }
                ),
              ),
            );
          }
      ),
    );
  }

  // review 작성 페이지
  // TODO: UI 수정
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
            height: MediaQuery.of(context).size.height * 0.5,
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
                  'writer': loginedUser.nickName,
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

  // 현재 위치 기준, 근처 음식점 정보 및 주소 구하기
  void getNearbyPlaces(double lat, double lng) async {
    var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${lng}&radius=1000&key=${_mapApiKey}&types=restaurant&language=ko';
    var response = await http.post(Uri.parse(url));

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(convert.jsonDecode(response.body));

    if(nearbyPlacesResponse.results != null)
      for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++) {
        Results results = nearbyPlacesResponse.results![i];
        String store = results.name!;
        double lat = double.parse(results.geometry!.location!.lat.toString());
        double lng = double.parse(results.geometry!.location!.lng.toString());
        saveLocation(store, lat, lng);
      }
    setState(() {});
  }

  // 음식점 정보 DB에 저장
  Future<void> saveLocation(String store, double lat, double lng) async {
    // 주소 구하기
    var url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat}, ${lng}&key=${_mapApiKey}&language=ko';
    var response = await http.get(Uri.parse(url));
    var responseBody = convert.utf8.decode(response.bodyBytes);

    var address = convert.jsonDecode(responseBody)['results'][0]['formatted_address'];

    await FirebaseFirestore.instance.collection('MapDB').where('store', isEqualTo: store).get().then((QuerySnapshot snapshot) => {
      if (snapshot.size == 0) {
        FirebaseFirestore.instance.collection('MapDB').add({
          'latitude': lat, 'longitude': lng,
          'like': 0,
          'address': address,
          'store': store,
        })
      }
    });
  }

  // 근처 음식점 정보 위젯으로 출력
  Widget nearbyPlacesWidget(Results results) {
    String store = results.name!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').where('store', isEqualTo: store).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        final documents = snapshot.data!.docs;

        return Consumer2<MapInfo, Logineduser>(
          builder: (context, mapProvider, userProvider, child) {
            return Column(
              children: [
                InkWell(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("$store", textScaleFactor: 1.2,),
                                  Text("${documents[0]['address']}",
                                    textScaleFactor: 1.0,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.grey
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                children: [
                                  // TODO: 가능하면 음식점 리스트에서도 좋아요 클릭할 수 있도록 하기
                                  // likeIcon(mapProvider, userProvider),
                                  Icon(Icons.favorite_outlined, size: 30, color: themeColor.getColor(),),
                                  Text("${documents[0]['like'].toString()}", textScaleFactor: 1.0,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    m_id = documents[0].id;
                    mapInfo.setInfo(m_id, documents[0]['address'], store, documents[0]['latitude'], documents[0]['longitude'], documents[0]['like']);
                    Provider.of<MapInfo>(context, listen: false).setInfo(m_id, documents[0]['address'], store, documents[0]['latitude'], documents[0]['longitude'], documents[0]['like']);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => detailPage(context, m_id),
                    ));
                  },
                ),
                Divider(),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: scrollKey,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.grey,
          child: Stack(
            children: [
              getUserMarker(context),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                      color: Colors.black12, width: 1
                      )
                    ),
                    child: FloatingActionButton(
                      heroTag: "location",
                      tooltip: "현재 위치",
                      onPressed: () {
                        _currentLocation();
                      },
                      child: Icon(Icons.my_location, size: MediaQuery.of(context).size.width * 0.08,),
                      shape: RoundedRectangleBorder(),
                      elevation: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if(nearbyPlacesResponse.results != null)
          for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
            nearbyPlacesWidget(nearbyPlacesResponse.results![i]),
      ],
    );
  }
}

// 상단으로 가는 버튼
Widget upButton() {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.black12, width: 1
                  )
              ),
              child: FloatingActionButton(
                heroTag: "upper",
                tooltip: "맨 위로",
                onPressed: () {
                  Scrollable.ensureVisible(
                      scrollKey.currentContext!,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Icon(Icons.arrow_upward_rounded),
                focusColor: Colors.white54,
                backgroundColor: Colors.white,
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// /* -------------------------------- 추천 리스트 (수정 중) */
// Widget recommendList(){
//   return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(10,20,10,10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text('근처 추천 맛집', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.4),
//                     //Icon(Icons.star_rounded, color: Colors.amberAccent),
//                   ],
//                 ),
//                 postList('메가커피 금오공대점', '4.5', '딸기쿠키프라페 짱!!'),
//                 postList('아리랑컵밥 금오공대점', '5.0', '낙지컵밥 냠냠'),
//                 postList('어벤더치 금오공대점', '5.0', '아이스크림 맛있어요'),
//                 postList('메가커피 금오공대점', '4.5', '딸기쿠키프라페 짱!!'),
//                 postList('아리랑컵밥 금오공대점', '5.0', '낙지컵밥 냠냠'),
//                 postList('어벤더치 금오공대점', '5.0', '아이스크림 맛있어요'),
//                 postList('메가커피 금오공대점', '4.5', '딸기쿠키프라페 짱!!'),
//                 postList('아리랑컵밥 금오공대점', '5.0', '낙지컵밥 냠냠'),
//                 postList('어벤더치 금오공대점', '5.0', '아이스크림 맛있어요'),
//               ],
//             ),
//           ),
//         ],
//       )
//   );
// }
//
// /* -------------------------------- 게시글 출력 (수정 중) */
// Widget postList(String text, String star, String description) {
//   return Row(
//     children: [
//       Expanded(
//         child: Card(
//           margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
//           child: Padding(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text('$text', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.20), //가게명
//                     Icon(Icons.star_rounded, color: Colors.amberAccent,),
//                     Text('$star', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.20), //별점
//                   ],
//                 ),
//                 Text('$description', style: TextStyle(color: Colors.grey), textScaleFactor: 1.0), //평가 (서술)
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
// /* -------------------------------- 검색 위젯: 일단 3개 작성 (삭제 금지) */
// Widget restaurantSearch(){
//   return Row(
//     key: scrollKey,
//     children: [
//       Expanded(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(10,0,10,5),
//           child: TextButton(
//             onPressed: () {}, //버튼 눌렀을 때 주소 검색지로 이동해야 함
//             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xfff2f3f6))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('위치 검색', style: TextStyle(color: Color(0xff81858d), leadingDistribution: TextLeadingDistribution.even,), textScaleFactor: 1.1),
//                 Icon(Icons.search_rounded, color: Color(0xff81858d)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
// Widget searchDesign() {
//   return Row(
//     children: [
//       Expanded(
//         child: Container(
//           margin: EdgeInsets.fromLTRB(10, 10, 10, 4),
//           padding: EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25.0),
//             color: Color(0xfff2f3f6),
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 onPressed: () => {},
//                 icon: Icon(Icons.search_rounded, color: Color(0xff81858d)),
//               ),
//               Text("검색", style: TextStyle(color: Color(0xff81858d)),),
//             ],
//           ),
//         ),
//       )
//     ],
//   );
// }
// Widget textfieldSearch() {
//   return Padding(
//     padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
//     child: TextFormField(
//       onTap: () {},
//       decoration: InputDecoration(
//         suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.search), color: Color(0xff81858d),),
//         hintText: '위치 검색',
//         hintStyle: TextStyle(
//           fontSize: (16/360),
//           color: Color(0xff81858d),
//         ),
//         border: InputBorder.none,
//         // enabledBorder: OutlineInputBorder(
//         //   borderRadius: BorderRadius.all(Radius.circular(20)),
//         // ),
//         filled: true,
//         fillColor: Color(0xfff2f3f6),
//       ),
//     ),
//   );
// }