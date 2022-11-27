import 'dart:convert';
// import 'dart:html';

import 'package:a_living_dictionary/LOGIN/Authentication.dart';
import 'package:a_living_dictionary/LOGIN/kakao_login.dart';
import 'package:a_living_dictionary/LOGIN/main_view_model.dart';
import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/Search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'UI/CommunityPage.dart';
import 'UI/MainPage.dart';
import 'UI/MyPage.dart';
import 'UI/RestaurantPage.dart';
import 'UI/DictionaryPage.dart';
import 'UI/Supplementary//ThemeColor.dart';

import 'UI/Supplementary/CommunityWritePage.dart';

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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>DictionaryItemInfo()),
        ChangeNotifierProvider(create: (_)=>Logineduser())
      ],
      child: MyApp(),
    ),
  );
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

Logineduser loginedUser  = new Logineduser();

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
    String user_docID = '';
    String user_uid = '';
    String user_nickName ='';
    String user_email ='';
    String user_profileImageUrl = '';

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
                  await viewModel.login();
                  setState((){}); // 화면 갱신만 하는 것 

                  // FirebaseAuth 닉네임 받아와서 user객체 만들거나/ 찾아서 객체에 넣기
                  if (FirebaseAuth.instance.currentUser != null) {
                    user_uid = FirebaseAuth.instance.currentUser!.uid;
                    user_nickName = viewModel.user?.kakaoAccount?.profile?.nickname ?? '';
                    user_email = viewModel.user?.kakaoAccount?.email  ?? '';
                    user_profileImageUrl = viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? '';
                  }

                  // 금방 로그인한 유저에 대한 정보
                  // 데이터베이스에 유저가 저장되어있는지 확인
                  FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_uid).get().then( (QuerySnapshot snap) {
                    String doc_id = '';

                    if (snap.size == 0) {// 데이터베이스에 유저가 저장되어있지 않다면 document하나 추가
                      FirebaseFirestore.instance.collection('userInfo').add({
                        'uid': user_uid, 'nickName': user_nickName, 'email': user_email, 'profileImageUrl': user_profileImageUrl, 'docID': ''
                      }).then((value) {
                        doc_id =  value.id.toString();

                        FirebaseFirestore.instance.collection('userInfo').doc(doc_id).update({
                          'docID': doc_id
                        });
                      });
                    }
                  }
                  );
                }, 
                child: const Text('카카오로 로그인')
              ),
              ElevatedButton(
                onPressed: () async {
                  await signInWithNaver();

                    // FirebaseAuth 닉네임 받아와서 user객체 만들거나/ 찾아서 객체에 넣기
                  if (FirebaseAuth.instance.currentUser != null) {
                    user_uid = FirebaseAuth.instance.currentUser!.uid;
                    user_nickName = FirebaseAuth.instance.currentUser!.displayName ?? '';
                    user_email = FirebaseAuth.instance.currentUser!.email ?? '';
                    user_profileImageUrl = FirebaseAuth.instance.currentUser!.photoURL ?? '';

                    // 금방 로그인한 유저에 대한 정보
                    // 데이터베이스에 유저가 저장되어있는지 확인
                    FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_uid).get().then( (QuerySnapshot snap) {
                      String doc_id = '';

                      if (snap.size == 0) {// 데이터베이스에 유저가 저장되어있지 않다면 document하나 추가
                        FirebaseFirestore.instance.collection('userInfo').add({
                          'uid': user_uid, 'nickName': user_nickName, 'email': user_email, 'profileImageUrl': user_profileImageUrl, 'docID': ''
                        }).then((value) {
                          doc_id =  value.id.toString();

                          FirebaseFirestore.instance.collection('userInfo').doc(doc_id).update({
                            'docID': doc_id
                          });
                        });
                      }
                    }
                    );
                  }
                },
                child: const Text('네이버로 로그인')
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/authPage') as Logineduser;
                }, 
                child: const Text('이메일로 로그인')  
              )
                
            ],
          );
        }

        // 사용자의 uid
        user_uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_uid).get().then( (QuerySnapshot snap) {
          snap.docs.forEach((doc) {
            loginedUser.nickName = doc['nickName'];
            loginedUser.email = doc['email'];
            loginedUser.doc_id = doc.id;
            loginedUser.profileImageUrl = doc['profileImageUrl'];
            loginedUser.uid = user_uid;
          }); 
          }
        );

        Provider.of<Logineduser>(context, listen: false).setDocID(loginedUser.doc_id);
        Provider.of<Logineduser>(context, listen: false).setInfo(loginedUser.uid, loginedUser.nickName, loginedUser.email, loginedUser.profileImageUrl);

        // 로그인이 된 상태
        return Scaffold(
          appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              elevation: 0.0,
              actions: <Widget>[
                Text(loginedUser.nickName ?? 'ㄴㄴ'),
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
