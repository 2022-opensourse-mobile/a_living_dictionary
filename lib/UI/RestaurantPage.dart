import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  late GoogleMapController _controller;

  int id = 1; // 임시 마커 id
  final List<Marker> markers = []; // 마커를 등록할 목록

  // 지도 클릭 시, 마커 등록
  addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
          position: coordinate,
          markerId: MarkerId((id++).toString()),
          infoWindow: InfoWindow(
              title: "마커${id-1}",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowInformation())); // 마커 클릭 시 임시 페이지로 이동
              }
          )
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialLocation,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: markers.toSet(),
        myLocationEnabled: true, // 현재 위치를 파란색 점으로 표시

        onTap: (coordinate) { // 클릭한 위치 중앙에 표시
          _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
          addMarker(coordinate);
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _currentLocation,
        label: Text('현재 위치'),
        icon: Icon(Icons.my_location_outlined),
      ),
    );
  }

  // 초기 위치 설정(금오공대)
  static final CameraPosition _initialLocation = CameraPosition(
    target: LatLng(36.1461382, 128.3934882),
    zoom: 16.0,
  );

  // 현재 위치 구하기
  void _currentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? _currentLocation;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // 위치 권한 확인
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.granted) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        tilt: 0,
        zoom: 17.0,
      ),
    ));

  }
}

// 마커 클릭 시 나타나는 임시 페이지
class ShowInformation extends StatelessWidget {
  const ShowInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("임시 페이지")),
    );
  }
}