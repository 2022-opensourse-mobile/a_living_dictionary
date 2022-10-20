import 'package:flutter/material.dart';


class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('혼밥 맵'),
      ),
      body: Center(child: Text('Hi')),
    );;
  }
}
