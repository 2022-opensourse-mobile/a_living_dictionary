import 'package:flutter/material.dart';
import 'CommunityPage.dart';
import 'MainPage.dart';
import 'MyPage.dart';
import 'RestaurantPage.dart';
import 'DictionaryPage.dart';
import 'ThemeColor.dart';

//page0 : Main
//page1 : Dictionary
//page2 : community
//page3 : restaurant map
//page4 : my Page

ThemeColor themeColor = ThemeColor();


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: themeColor.getMaterialColor()),
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
          title: Text(widget.title, style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'Hi!',
              onPressed: () => {
                // 검색 화면으로 이동
              },
            )
          ]
      ),
      body: Center(child: _getPage()),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {_curIndex = index;});
        },
        currentIndex: _curIndex,
        backgroundColor: Colors.black,

        unselectedIconTheme: IconThemeData(color:Colors.white70,opacity: 100),
        selectedIconTheme: IconThemeData(color:Colors.white,opacity: 100),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: '홈', backgroundColor: themeColor.getColor(),),
          BottomNavigationBarItem(icon: Icon(Icons.book,), label: '사전', backgroundColor: themeColor.getColor(),),
          BottomNavigationBarItem(icon: Icon(Icons.people,), label: '게시판', backgroundColor: themeColor.getColor(),),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined,), label: '혼밥 맵', backgroundColor: themeColor.getColor(),),
          BottomNavigationBarItem(icon: Icon(Icons.info,), label: '내 정보', backgroundColor: themeColor.getColor(),),
        ],
      ),
    );
  }

  Widget _getPage(){
    switch(_curIndex){
      case 0: return MainPage();
      case 1: return DictionaryPage();
      case 2: return CommunityPage();
      case 3: return RestaurantPage();
      case 4: return MyPage();
      default: return MainPage();
    }
  }
}
