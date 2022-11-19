import 'package:a_living_dictionary/LOGIN/kakao_login.dart';
import 'package:a_living_dictionary/LOGIN/main_view_model.dart';
import 'package:a_living_dictionary/UI/Supplementary/Search.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
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

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

// android/app/src/google-services.json과 firebase_options.dart는 gitignore

//123
//page0 : Main
//page1 : Dictionary
//page2 : community
//page3 : restaurant map
//page4 : my Page

ThemeColor themeColor = ThemeColor();


void main() async {

  kakao.KakaoSdk.init(nativeAppKey: 'b599e335086be99a1a5e12a1e9f80e68');

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
  late var viewModel;

  final List<String> list = List.generate(10, (index) => "Text $index");
  late TabController _tabController;
  int _curIndex = 0;


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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // 로그인 되고 안될때마다 새로운 스트림이 들어옴
      builder: (context, snapshot) {
        // if(!snapshot.hasData) { // 로그인이 안 된 상태
        //   return Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       ElevatedButton(
        //         onPressed: () async {
        //           viewModel = new MainViewModel(KakaoLogin());
        //           await viewModel.login();
        //           setState((){}); // 화면 갱신만 하는 것 

        //         }, 
        //         child: const Text('카카오로 로그인')
        //       ),
        //       ElevatedButton(
        //         onPressed: () async {
        //           viewModel = new MainViewModel(KakaoLogin());
        //           await viewModel.login();
        //           setState((){}); // 화면 갱신만 하는 것 

        //         }, 
        //         child: const Text('이메일로 로그인')
        //       ),
        //     ],
        //   );
        // }

        // 로그인이 된 상태
        return Scaffold(
          appBar: AppBar(
              title: Text(widget.title, style: TextStyle(color: themeColor.getColor()),),
              elevation: 0.0,
              actions: <Widget>[
                // ElevatedButton(
                //   onPressed: () async {
                //     await viewModel.logout();
                //     setState((){}); // 화면 갱신만 하는 것 
                //   }, 
                //   child: const Text('logout')
                // ),
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
    
        );
      }
    );
  }
}
