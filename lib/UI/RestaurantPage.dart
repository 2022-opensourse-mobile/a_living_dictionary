import 'package:a_living_dictionary/PROVIDERS/MapInfo.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
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
import 'Supplementary/CheckClick.dart';
import 'package:a_living_dictionary/UI/Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();
CheckClick checkClick = CheckClick();

// Google Map API Key
final _mapApiKey = 'AIzaSyDV1uWDF4S16dDx5oQAAJ399p3e9Cbot90';

final GlobalKey scrollKey = GlobalKey(); // 키 생성
final formKey = GlobalKey<FormState>();
final navigatorKey = GlobalKey<NavigatorState>();

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: restaurantMap(),
      ),
      floatingActionButton: upButton(),
    );
  }
}

class restaurantMap extends StatefulWidget {
  restaurantMap({Key? key}) : super(key: key);

  @override
  State<restaurantMap> createState() => restaurantMapState();
}

class restaurantMapState extends State<restaurantMap> {
  late GoogleMapController _controller;
  late TextEditingController reviewController;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  MapInfo mapInfo = MapInfo();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String m_id = ""; // Map Id

  // DB에 저장된 마커 지도에 추가(좋아요 100개 이상인 마커만)
  Widget getMarker(BuildContext context) {
    double lat, lng;
    String store;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final documents = snapshot.data!.docs;
        for (int i = 0; i < documents.length; i++) {
          lat = double.parse(documents[i]['latitude'].toString());
          lng = double.parse(documents[i]['longitude'].toString());
          store = documents[i]['store'];
          if (int.parse(documents[i]['like'].toString()) >= 100) { // 좋아요가 100개 이상인 것만 마커 추가
            final MarkerId markerId = MarkerId(store);

            markers[markerId] = Marker(
              position: LatLng(lat, lng),
              markerId: MarkerId(store),
              infoWindow: InfoWindow(
                title: store,
                snippet: "좋아요: ${documents[i]['like']}",
              ),
            );
          }
        }
        return googleMap(context);
      },
    );
  }

  // 각 사용자 DB에 저장된 마커(좋아요 표시) 지도에 추가
  Widget getUserMarker(BuildContext context) {
    double lat, lng;
    String store, udoc_id;

    return Consumer<Logineduser>(
      builder: (context, userProvider, child) {
        udoc_id = userProvider.getDocID();
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('userInfo').doc(udoc_id).collection('MapLikeList').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            final documents = snapshot.data!.docs;

            for (int i = 0; i < documents.length; i++) {
              lat = double.parse(documents[i]['latitude'].toString());
              lng = double.parse(documents[i]['longitude'].toString());
              store = documents[i]['store'];
              final MarkerId markerId = MarkerId(store);

              markers[markerId] = Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                position: LatLng(lat, lng),
                markerId: MarkerId(store),
                infoWindow: InfoWindow(
                  title: store,
                ),
              );
            }
            return getMarker(context);
          },
        );
      },
    );
  }

  // 음식점 좋아요 누른 경우, 개별 지도에 마커 추가
  void addMarker(BuildContext context, double lat, double lng, String store) {
    final MarkerId markerId = MarkerId(store);

    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(lat, lng),
      markerId: markerId,
      infoWindow: InfoWindow(
        title: store,
      ),
    );

    if (this.mounted) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  // 좋아요 취소 시, 마커 삭제
  void deleteMarker(BuildContext context, String store) {
    markers.removeWhere((key, value) => key == MarkerId(store));
    getUserMarker(context);
  }

  // 좋아요 아이콘
  Widget likeIcon(MapInfo mapProvider, Logineduser userProvider) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
          .where('docID', isEqualTo: mapProvider.doc_id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // 이미 좋아요 누른 경우
        if (snapshot.data!.size != 0) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: Color(0xffD83064),
              size: 30,
            ),
            onPressed: () {
              if (checkClick.isRedundentClick(DateTime.now()))
                return;
              FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                  .where('docID', isEqualTo: mapProvider.doc_id).get().then((value) {
                value.docs.forEach((element) {
                  FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection('MapLikeList')
                      .doc(element.id).delete();
                });
              });
              mapProvider.subLikeNum(mapProvider.doc_id);
              deleteMarker(context, mapProvider.store);
            },
          );
        }
        // 좋아요 안 누른 경우
        else {
          return IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Color(0xffD83064),
              size: 30,
            ),
            onPressed: () {
              if (checkClick.isRedundentClick(DateTime.now()))
                return;
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

  // 마커 클릭 시 나오는 페이지
  Widget detailPage(BuildContext context, String store, String id) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(title: Text('$store 상세 정보'), elevation: 0.0),
      floatingActionButton: editUI(),
      body: Consumer2<MapInfo, Logineduser>(
        builder: (context, mapProvider, userProvider, child) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('MapDB').doc(id).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final mapDocument = snapshot.data!;

              return ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15,10,15,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$store', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.8),
                          Text('${mapDocument['address']}', style: TextStyle(color: Colors.grey, height: 1.6), textScaleFactor: 1.2),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(4,0,0,0),
                      child: Row(
                        children: [
                          likeIcon(mapProvider, userProvider),
                          Text('${mapDocument['like']}', textScaleFactor: 1.2),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.5),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15,15,15,15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$store 후기', style:TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.4),
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection(
                              'MapDB').doc(id)
                              .collection('reviewDB')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());

                            final reviewDocuments = snapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reviewDocuments.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: width,
                                  child: ListTile(
                                    leading: Icon(Icons.chevron_right_rounded),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              reviewDocuments[index]['content']
                                                  .toString()),
                                        ),
                                        reviewDocuments[index]['writer'] == userProvider.uid?
                                        Container(child: modifyReview(reviewDocuments[index].id, reviewDocuments[index]['content']), width: width * 0.25,) : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                      ),
                    ),
                  ]
              );
            },
          );
        },
      ),
    );
  }

  // 리뷰 작성 폼
  Widget editUI() {
    String? review;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.black12, width: 1
            )
        ),
        child: Consumer<Logineduser>(
          builder: (context, userProvider, child) {
            return FloatingActionButton(
                tooltip: "후기 작성하기",
                child: Icon(Icons.edit, color: Colors.black,),
                focusColor: Colors.white54,
                backgroundColor: Colors.white,
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                onPressed: () {
                  editDialog("작성", "", userProvider.uid);
                }
            );
          },
        ),
      ),
    );
  }

  // 후기 수정 및 삭제
  Widget modifyReview(String rid, String text) {
    String id = FirebaseFirestore.instance.collection('MapDB').doc(m_id).collection('reviewDB').doc(rid).id;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () {
              editDialog("수정", text, rid);
            },
            child: const Text("수정", style: TextStyle(color: Colors.grey)),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('MapDB').doc(m_id).collection('reviewDB').doc(id).delete();
            },
            child: const Text("삭제", style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  // 후기 작성 팝업창
  void editDialog(String write, String text, String id) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        reviewController = TextEditingController(text: text);
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('후기 $write하기',
                  style: TextStyle(
                      color: themeColor.getMaterialColor(),
                      fontWeight: FontWeight.bold)),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  controller: reviewController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if(value!.isEmpty) return '내용을 입력하세요';
                  },
                  cursorColor: themeColor.getMaterialColor(),
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: '내용을 입력하세요',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor(),)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor(),)),
                  ),
                ),
              ),
              actions: [
                TextButton(child: Text('취소',
                  style: TextStyle(color: themeColor.getMaterialColor(),
                    fontWeight: FontWeight.bold,),),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                TextButton(child: Text('확인',
                  style: TextStyle(color: themeColor.getMaterialColor(),
                    fontWeight: FontWeight.bold,),),
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        if (write == "수정") { // 수정인 경우
                          FirebaseFirestore.instance.collection('MapDB').doc(m_id).collection('reviewDB').doc(id).update({
                            'content': reviewController.text
                          });
                          Navigator.pop(context);
                        }
                        else { // 처음 작성인 경우
                          Timestamp timestamp = Timestamp.now();
                          FirebaseFirestore.instance.collection('MapDB').doc(m_id).collection('reviewDB').add({
                            'content': reviewController.text,
                            'writer': id,
                            'time': timestamp,
                          });
                          Navigator.pop(context);
                        }
                      }
                    }),
              ],
            ),
          ),
        );
      }
    );
  }

  // 근처 음식점 정보 위젯으로 출력
  Widget nearbyPlacesWidget(String store) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MapDB').where('store', isEqualTo: store).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        if (!snapshot.hasData)
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
                                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                      child: Text("$store", textScaleFactor: 1.2,),),
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
                                    Icon(Icons.favorite_outlined, size: 30, color: Color(0xffD83064),),
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
                      PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(detailPage(context, store, m_id));
                      Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                    },
                  ),
                  Divider(thickness: 0.5,),
                ],
              );
            }
        );
      },
    );
  }

  // 구글 지도
  Widget googleMap(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialLocation,

      onMapCreated: (GoogleMapController controller) {
        if (this.mounted) {
          setState(() {
            _controller = controller;
            _currentLocation();
          });
        }
      },
      markers: Set<Marker>.of(markers.values),
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
    if (this.mounted) {
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), () {});
    double W = MediaQuery.of(context).size.width;
    double H = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        Container(
          key: scrollKey,
          width: W,
          height: isPortrait? H * 0.7 : H * 0.55,
          color: Colors.grey,
          child: Stack(
            children: [
              getUserMarker(context),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    width: 50,
                    height: 50,
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
                      child: Icon(Icons.my_location, size: 35, color: Colors.black54,),
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
            nearbyPlacesWidget(nearbyPlacesResponse.results![i].name!),
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
                child: Icon(Icons.arrow_upward_rounded, color: Colors.black,),
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