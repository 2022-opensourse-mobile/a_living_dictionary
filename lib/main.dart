import 'package:a_living_dictionary/UI/Supplementary/Search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'UI/CommunityPage.dart';
import 'UI/MainPage.dart';
import 'UI/MyPage.dart';
import 'UI/RestaurantPage.dart';
import 'UI/DictionaryPage.dart';
import 'UI/Supplementary//ThemeColor.dart';

import 'UI/Supplementary/CommunityWritePage.dart';
import 'UI/Supplementary/CommunityPostPage.dart';

import 'UI/Supplementary/DictionaryCardPage.dart';
import 'UI/Supplementary/WriteDictionaryPage.dart';



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
      builder: (context,child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!);},
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: themeColor.getWhiteMaterialColor(),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(title: '자취 백과사전'),
      routes: {
        //'/communityPost':(context)=>CommunityPostPage(),
        '/communityWrite':(context)=>CommunityWritePage(),
        '/writeDictionary':(context)=>WriteDictionaryPage(),
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

  // final List<Widget> myTabs = <Widget>[
  //   // new Tab(
  //   //   icon: Icon(Icons.ad_units),
  //   //   text: 'LEFT'
  //   // ),
  //   // new Tab(text: 'RIGHT'),
  //   // BottomNavigationBarItem(icon: Icon(Icons.home,), label: '홈', backgroundColor: themeColor.getColor(),),
  //   // BottomNavigationBarItem(icon: Icon(Icons.book,), label: '사전', backgroundColor: themeColor.getColor(),),
  //   // BottomNavigationBarItem(icon: Icon(Icons.people,), label: '게시판', backgroundColor: themeColor.getColor(),),
  //   // BottomNavigationBarItem(icon: Icon(Icons.map_outlined,), label: '혼밥 맵', backgroundColor: themeColor.getColor(),),
  //   // BottomNavigationBarItem(icon: Icon(Icons.info,), label: '내 정보', backgroundColor: themeColor.getColor(),),
  //   Tab(icon: Icon(Icons.home_outlined), text: '홈', ),
  //   Tab(icon: Icon(Icons.book_outlined,), text: '사전'),
  //   Tab(icon: Icon(Icons.people_alt_outlined,), text: '게시판'),
  //   Tab(icon: Icon(Icons.map_outlined,), text: '혼밥 맵'),
  //   Tab(icon: Icon(Icons.info_outline,), text: '내 정보'),
  //
  // ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 5);
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
        physics:NeverScrollableScrollPhysics(),
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
        tabs: <Widget>[
          Tab(icon: _curIndex == 0? Icon(Icons.home) : Icon(Icons.home_outlined), child: Text('홈', textScaleFactor: 1,), ),
          Tab(icon: _curIndex == 1? Icon(Icons.book) : Icon(Icons.book_outlined,), child: Text('사전', textScaleFactor: 1,),),
          Tab(icon: _curIndex == 2? Icon(Icons.people_alt) : Icon(Icons.people_alt_outlined), child: Text('게시판', textScaleFactor: 1,),),
          Tab(icon: _curIndex == 3? Icon(Icons.map) : Icon(Icons.map_outlined,), child: Text('혼밥 맵', textScaleFactor: 1,),),
          Tab(icon: _curIndex == 4? Icon(Icons.info) : Icon(Icons.info_outline,), child: Text('내 정보', textScaleFactor: 1,),),
        ],
        onTap: (index) {
          setState(() {_curIndex = index;});
        },
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
}
