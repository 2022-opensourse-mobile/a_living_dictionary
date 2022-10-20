import 'package:flutter/material.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자취 백과사전'),
      ),
      body: Center(child: Text('Hi')),
    );;
  }
}
