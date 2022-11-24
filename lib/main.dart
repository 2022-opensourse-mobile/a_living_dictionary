import 'dart:convert';
// import 'dart:html';

import 'package:a_living_dictionary/LOGIN/Authentication.dart';
import 'package:a_living_dictionary/LOGIN/Logineduser.dart';
import 'package:a_living_dictionary/LOGIN/kakao_login.dart';
import 'package:a_living_dictionary/LOGIN/main_view_model.dart';
import 'package:a_living_dictionary/UI/Supplementary/Search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutterfire_ui/auth.dart';
import 'firebase_options.dart';

import 'UI/CommunityPage.dart';
import 'UI/MainPage.dart';
import 'UI/MyPage.dart';
import 'UI/RestaurantPage.dart';
import 'UI/DictionaryPage.dart';
import 'UI/Supplementary//ThemeColor.dart';

import 'UI/Supplementary/CommunityWritePage.dart';

import 'UI/Supplementary/DictionaryCardPage.dart';
import 'UI/Supplementary/WriteDictionaryPage.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

// android/app/src/google-services.json과 firebase_options.dart는 gitignore
// https://funncy.github.io/flutter/2021/03/10/firebase-auth/


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
        '/communityWrite':(context)=>CommunityWritePage(),
        '/writeDictionary':(context)=>WriteDictionaryPage(),
        '/authPage': (context)=> Authentication()
      },
    );
  }
}

late Logineduser loginedUser;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  MainViewModel viewModel = new MainViewModel(KakaoLogin());

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


  Future<UserCredential> signInWithNaver() async {
    final clientState = Uuid().v4();
    final url = Uri.https('nid.naver.com', '/oauth2.0/authorize', {
      'response_type': 'code',
      'client_id': 'bTYjIh0nr6vnD0mi8SWh',
      'response_mode': 'form_post',
      'redirect_uri': 
        'https://loveyou.run.goorm.io/callbacks/naver/sign_in',
      'state': clientState
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: "webauthcallback");
      

    final body = Uri.parse(result).queryParameters;
    final tokenUrl = Uri.https('nid.naver.com', '/oauth2.0/token', {
      'grant_type' : 'authorization_code',
      'client_id': 'bTYjIh0nr6vnD0mi8SWh',
      'client_secret': 'yXkEij1Zvt',
      
      'state': clientState,
      'code': body['code']
    });

    
    var response = await http.post(tokenUrl);
    var accessTokenResult = json.decode(response.body);
    var responseCustomToken = await http.post(
      Uri.parse("https://loveyou.run.goorm.io/callbacks/naver/token"),
      body: {"accessToken": accessTokenResult['access_token']}
    );

    return await FirebaseAuth.instance
      .signInWithCustomToken(responseCustomToken.body);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges() , // 로그인 되고 안될때마다 새로운 스트림이 들어옴
      builder: (BuildContext context, snapshot) {
        
        if(!snapshot.hasData) { // 로그인이 안 된 상태 - 로그인 화면
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  viewModel = new MainViewModel(KakaoLogin());

                  setState((){}); // 화면 갱신만 하는 것 

                   // FirebaseAuth 닉네임 받아와서 user객체 만들거나/ 찾아서 객체에 넣기
                  String user_id = '';
                  String user_nickname = '';
                  String user_email = '';
                  String user_profileImageUrl = '';

                  if (FirebaseAuth.instance.currentUser != null) {
                    user_id = FirebaseAuth.instance.currentUser!.uid;
                    user_nickname = viewModel.user?.kakaoAccount?.profile?.nickname ?? '';
                    user_email = viewModel.user?.kakaoAccount?.email  ?? '';
                    user_profileImageUrl = viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? '';
                  }

                 
                  // 금방 로그인한 유저에 대한 정보로 객체 만듦
                  loginedUser = new Logineduser(user_id, user_nickname, user_email, user_profileImageUrl);

                  // 데이터베이스에 유저가 저장되어있는지 확인
                  bool hasUserData = false;
                  FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_id).get().then( (QuerySnapshot snap) {
                    snap.docs.forEach((doc) {
                      hasUserData = true;
                    });
                    }
                  );

                  // 데이터베이스에 유저가 저장되어있지 않다면 document하나 추가
                  if (!hasUserData && user_id != '') {
                    FirebaseFirestore.instance.collection('userInfo').add({'uid': user_id, 'nickName': user_nickname, 'email': user_email, 'profileImageUrl': user_profileImageUrl});
                  }

                 
                }, 
                child: const Text('카카오로 로그인')
              ),
              ElevatedButton(
                // onPressed: () async {
                //   String naver_url = 'https://loveyou.run.goorm.io/naver';
                //   var _nToken = await Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (BuildContext context) => WebviewScaffold(
                //         url: naver_url,
                //         javascriptChannels: Set.from([
                //           JavascriptChannel(
                //             name: "james",
                //             onMessageReceived: (JavascriptMessage result) async {
                //               if (result.message != null)
                //                 return Navigator.of(context).pop(result.message);

                //               return Navigator.of(context).pop();
                //             }
                //           )
                //         ])
                //       )
                //     )
                  
                //   );

                //   // if(_nToken != null) return Navigator.of(context).pushAndRemoveUntil(
                //   //   MaterialPageRoute(
                //   //     builder: (BuildContext context) => MainPage(userName: _textEditingController.text)
                //   //   ),
                //   //   (route) => false
                //   // );
                  

                //   // viewModel = new MainViewModel(KakaoLogin());
                //   // await viewModel.login();
                //   // setState((){}); // 화면 갱신만 하는 것 

                // }, 
                onPressed: (){
                  signInWithNaver();

                  // // FirebaseAuth 닉네임 받아와서 user객체 만들거나/ 찾아서 객체에 넣기
                  // String user_id = FirebaseAuth.instance.currentUser!.uid;
                  // String user_nickname = viewModel.user?.kakaoAccount?.profile?.nickname ?? '';
                  // String user_email = viewModel.user?.kakaoAccount?.email  ?? '';


                  // // 금방 로그인한 유저에 대한 정보로 객체 만듦
                  // loginedUser = new Logineduser(user_id, user_nickname, user_email);

                  // // 데이터베이스에 유저가 저장되어있는지 확인
                  // bool hasUserData = false;
                  // FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_id).get().then( (QuerySnapshot snap) {
                  //   snap.docs.forEach((doc) {
                  //     hasUserData = true;
                  //   });
                  //   }
                  // );

                  // // 데이터베이스에 유저가 저장되어있지 않다면 document하나 추가
                  // if (!hasUserData) {
                  //   FirebaseFirestore.instance.collection('userInfo').add({'uid': user_id, 'nickName': user_nickname, 'email': user_email});
                  // }

                },
                child: const Text('네이버로 로그인')
              ),
              ElevatedButton(
                onPressed: () async {
                  loginedUser = await Navigator.pushNamed(context, '/authPage') as Logineduser;
                }, 
                child: const Text('이메일로 로그인')
              ),
            ],
          );
        }


        // 로그인이 된 상태
        return Scaffold(
          appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              elevation: 0.0,
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (viewModel != null) {    // social login
                      await viewModel.logout();
                    } else {                    // email login
                      FirebaseAuth.instance.signOut();
                    }              
                    setState((){}); // 화면 갱신만 하는 것 
                  }, 
                  child:  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: Text('logout', style: TextStyle(fontSize: 20, color: Colors.amber),))
                ),
                // Text(loginedUser.nickName),
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
