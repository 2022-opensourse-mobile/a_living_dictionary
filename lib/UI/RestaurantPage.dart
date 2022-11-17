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
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true, // 현재 위치를 파란색 점으로 표시
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
    final GoogleMapController controller = await _controller.future;
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

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
          tilt: 0,
          zoom: 16.0,
        )
    ));

  }
}