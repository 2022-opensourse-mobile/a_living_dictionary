import 'package:a_living_dictionary/Search.dart';
import 'package:flutter/material.dart';
import 'CommunityPage.dart';
import 'MainPage.dart';
import 'MyPage.dart';
import 'RestaurantPage.dart';
import 'DictionaryPage.dart';
import 'ThemeColor.dart';
import 'community/writePost.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//123
//page0 : Main
//page1 : Dictionary
//page2 : community
//page3 : restaurant map
//page4 : my Page

ThemeColor themeColor = ThemeColor();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: themeColor.getWhiteMaterialColor()),
      home: MyHomePage(title: '자취 백과사전'),
      routes: {
        '/writePost':(context)=>WritePostPage()
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<String> list = List.generate(10, (index) => "Text $index");
  late TabController _tabController;
  int _curIndex = 0;

  final List<Widget> myTabs = <Widget>[
    // new Tab(
    //   icon: Icon(Icons.ad_units),
    //   text: 'LEFT'
    // ),
    // new Tab(text: 'RIGHT'),
    // BottomNavigationBarItem(icon: Icon(Icons.home,), label: '홈', backgroundColor: themeColor.getColor(),),
    // BottomNavigationBarItem(icon: Icon(Icons.book,), label: '사전', backgroundColor: themeColor.getColor(),),
    // BottomNavigationBarItem(icon: Icon(Icons.people,), label: '게시판', backgroundColor: themeColor.getColor(),),
    // BottomNavigationBarItem(icon: Icon(Icons.map_outlined,), label: '혼밥 맵', backgroundColor: themeColor.getColor(),),
    // BottomNavigationBarItem(icon: Icon(Icons.info,), label: '내 정보', backgroundColor: themeColor.getColor(),),
    Tab(icon: Icon(Icons.home,), text: '홈', ),
    Tab(icon: Icon(Icons.book,), text: '사전'),
    Tab(icon: Icon(Icons.people,), text: '게시판'),
    Tab(icon: Icon(Icons.map_outlined,), text: '혼밥 맵'),
    Tab(icon: Icon(Icons.info,), text: '내 정보'),

  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: themeColor.getColor()),),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.search),
              onPressed: () => {
                showSearch(context: context, delegate:Search(list))
              },
            )
          ]
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MainPage(tabController: _tabController),
          DictionaryPage(),
          CommunityPage(),
          RestaurantPage(),
          MyPage()
        ],
      ),
      // Center(child: _getPage()),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: myTabs,
        onTap: (index) {
          setState(() {_curIndex = index;});
        },
        // labelColor: ?,
      ),


      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (index){
      //     setState(() {_curIndex = index;});
      //   },
      //   currentIndex: _curIndex,
      //   backgroundColor: Colors.black,

      //   unselectedIconTheme: IconThemeData(color:Colors.white70,opacity: 100),
      //   selectedIconTheme: IconThemeData(color:Colors.white,opacity: 100),
      //   items: myTabs
      // ),
    );
  }

  Widget _getPage(){
    switch(_curIndex){
      case 0: return MainPage(tabController: _tabController);
      case 1: return DictionaryPage();
      case 2: return CommunityPage();
      case 3: return RestaurantPage();
      case 4: return MyPage();
      default: return MainPage(tabController: _tabController);
    }
  }
}
