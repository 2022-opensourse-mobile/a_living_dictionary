import 'package:flutter/material.dart';


//page0 : Main
//page1 : Dictionary
//page2 : community
//page3 : restaurant map
//page4 : my Info

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: const MyHomePage(title: '자취 백과사전'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: Text('Hi')),
    );
  }

  Widget _getPage(){
    switch(_curIndex){
      case 0: return MainPage();
      case 1: return DictionaryPage();
      case 2: return CommunityPage();
      case 3: return RestaurantPage();
      case 4: return MyPage();
    }
  }
}
