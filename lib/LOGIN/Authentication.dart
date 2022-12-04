

import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


//https://firebase.google.com/codelabs/firebase-auth-in-flutter-apps#5

// 이메일 로그인 구현중
class Authentication extends StatelessWidget {
   Authentication({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nickNameController = TextEditingController();


  
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(), // 로그인 로그아웃 이거 구독하고 있다가 builder로 화면 새롭게그려줌
      builder: (context, snapshot) {
        

        if (!snapshot.hasData) {// 인증을 받지 않았으면 로그인화면
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: themeColor.getMaterialColor(),
              scaffoldBackgroundColor: Colors.white,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            home: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // 화면 밖을 눌렀을 때 키보드 숨김
              child: Scaffold(
                resizeToAvoidBottomInset: true,   // 키보드가 화면을 가리지 않게 스크롤 가능
                body: SignInScreen(
                  styles: const {
                    EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
                  },
                  headerBuilder: ((context, constraints, shrinkOffset) {
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: AspectRatio(
                        aspectRatio: 1, //  child 위젯의 넓이가 높이의 1배
                        child: Image(
                            image: AssetImage('assets/app_icon.png')
                        ),
                      ),
                    );
                  }),
                        
                  providerConfigs: [
                    EmailProviderConfiguration(),  // 이메일 인증 가능하게 해주는 기능
                  ],
                        
                        
                subtitleBuilder: (context, action) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: action == AuthAction.signIn
                        ? const Text('로그인을 진행하세요.\n회원가입을 원하시는 분은 Register를 눌러주세요.')
                        : const Text('회원가입을 진행하세요.'),
                  );
                },
                        
                // footerBuilder: (context, action) {
                //    return const Padding(
                //      padding: EdgeInsets.only(top: 16),
                //      child: Text(
                //        'By signing in, you agree to our terms and conditions.',
                //        style: TextStyle(color: Colors.grey),
                //      ),
                //    );
                //  },
                        
                 sideBuilder: (context, shrinkOffset) {   // 화면 늘렸을 때 나오는 사진
                   return Padding(
                     padding: const EdgeInsets.all(20),
                     child: AspectRatio(
                       aspectRatio: 1,
                       child: Image.asset('assets/app_icon.png'),
                     ),
                   );
                 },
                  
                  // showAuthActionSwitch: false,  
                ),
              ),
            ),
          );
        } 




        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {

            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }

            if (snapshot.data!.size == 0) {   // 사용자 해당 정보가 디비에 없을 때
            //void setInfo(uid, nickName, email, profileImageUrl)
              // Logineduser logineduser = new Logineduser();
              // logineduser.setInfo(FirebaseAuth.instance.currentUser!.uid, '',FirebaseAuth.instance.currentUser!.email ?? '', 'https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/techmo.png?alt=media&token=d8bf4d4e-cc31-4523-8cba-8694e6572260');
              // logineduser.setDocID('');
              


              FirebaseFirestore.instance.collection('userInfo').add({
                'uid': FirebaseAuth.instance.currentUser!.uid, 'nickName': FirebaseAuth.instance.currentUser!.uid, 'email': FirebaseAuth.instance.currentUser!.email ?? '', 
                'profileImageUrl': 'https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/techmo.png?alt=media&token=d8bf4d4e-cc31-4523-8cba-8694e6572260',
                'admin': false
              }).then((value) {
                String doc_id =  value.id.toString();
                
                FirebaseFirestore.instance.collection('userInfo').doc(doc_id).update({
                  'docID': doc_id
                });

                Provider.of<Logineduser>(context, listen: false).setDocID(doc_id);
                Provider.of<Logineduser>(context, listen: false).setInfo(
                    FirebaseAuth.instance.currentUser!.uid,
                    '',
                    FirebaseAuth.instance.currentUser!.email ?? '',
                    'https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/techmo.png?alt=media&token=d8bf4d4e-cc31-4523-8cba-8694e6572260',
                    false
                );
              });

              Future.delayed(Duration.zero, () => nickNameAlert(context));

              return Container(color: Colors.white,);
            }

            return onboardingScreen('email');
          }
        );
        
      }
      // Signin 위젯이 있다. flutterfire_ui 깔기
      );
  }

  void nickNameAlert(BuildContext context) {
    
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text('사용할 닉네임 입력',
              style: TextStyle(
                color: themeColor.getMaterialColor(),
                fontWeight: FontWeight.bold
              )
            ),
            content: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Stack(
                children: [
                     //           Positioned(
            //             right: -40.0,
            //             top: -40.0,
            //             child: InkResponse(
            //               onTap: () {
            //                 Navigator.of(context).pop();
                        
            //               },
            //               child: CircleAvatar(
            //                 child: Icon(Icons.close),
            //                 backgroundColor: Colors.red,
            //               ),
            //             ),
            //           ),
                  TextFormField(
                    controller: _nickNameController,
                    // onSaved: (name) {myNickname = name!;},
                    validator: (value) {
                      if(value!.isEmpty) return '닉네임을 입력하세요';
                    },
                    cursorColor: themeColor.getMaterialColor(),
                    decoration: InputDecoration(
                      hintText: '닉네임',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor()),
                      ),
                      border: const UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: themeColor.getMaterialColor()),
                      ),),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<Logineduser>(
                builder: (context, userProvider, child) {
                  return TextButton(child: Text('확인',
                    style: TextStyle(color: themeColor.getMaterialColor(),
                      fontWeight: FontWeight.bold,),),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()) {
                          String inputText = _nickNameController.text.trim();
      
                          //닉네임 중복 확인
                          bool isduplicate = false;
                          await FirebaseFirestore.instance.collection('userInfo').where("nickName", isEqualTo: inputText).get().then((value) {
                          if (value.docs.length != 0) {
                            isduplicate = true;
                            }
                          });
        
                          if (inputText.length < 2) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('잘못된 입력',
                                    style: TextStyle(
                                        color: themeColor.getMaterialColor(),
                                        fontWeight: FontWeight.bold)),
                                content: Text('닉네임을 두 글자 이상 입력해주세요.'),
                                actions: [
                                  TextButton(child: Text('확인',
                                    style: TextStyle(color: themeColor.getMaterialColor(),
                                      fontWeight: FontWeight.bold,),),
                                      onPressed: () { Navigator.pop(context); }),
                                ],
                              ),
                            );
                          } else if (isduplicate) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('닉네임 중복',
                                    style: TextStyle(
                                        color: themeColor.getMaterialColor(),
                                        fontWeight: FontWeight.bold)),
                                content: Text('중복된 닉네임입니다. 다른 닉네임을 입력하세요.'),
                                actions: [
                                  TextButton(child: Text('확인',
                                    style: TextStyle(color: themeColor.getMaterialColor(),
                                      fontWeight: FontWeight.bold,),),
                                      onPressed: () { Navigator.pop(context); }),
                                ],
                              ),
                            );
                          } else {
                            Provider.of<Logineduser>(context, listen: false).setNickName(inputText);
                            FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).update({'nickName': inputText});
                            Navigator.pop(context);
                            SnackBar(
                              content: Text('닉네임 설정이 완료되었습니다'), //내용
                              duration: Duration(seconds: 2), //올라와 있는 시간
                            );
                          }
                        }
                  });
                }
              ),
            ],
          ),
        ),
      ),
    );
  
        

  }
}



//TODO: 이미지 가로버전에서 오버플로우 되는 거 고치기
class onboardingScreen extends StatefulWidget {
  onboardingScreen(this.loginType, {Key? key}) : super(key: key);
  String loginType;

  @override
  State<onboardingScreen> createState() => _onboardingScreenState(loginType);
}

class _onboardingScreenState extends State<onboardingScreen> {
  _onboardingScreenState(this.loginType);
  String loginType;


  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 80),
            child: PageView(
              controller: controller,
              children: [
                buildPage(
                    context: context,
                    urlImage: 'assets/page1.png',
                    title: '백과사전',
                    subtitle: '자취에 대한 정보들을 한번에!'
                ),
                buildPage(
                    context: context,
                    urlImage: 'assets/page2.png',
                    title: '커뮤니티',
                    subtitle: '자유롭게 소통할 수 있어요'
                ),
                buildPage(
                    context: context,
                    urlImage: 'assets/page3.png',
                    title: '맛집지도',
                    subtitle: '내 주변 맛집들을 찾아보세요'
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: 70,
          color: Colors.white,
          child: Column(
            children: [
                  Center(
                    child: SmoothPageIndicator(controller: controller, count: 3,
                      effect: SlideEffect(
                        dotHeight: 7,
                        dotWidth: 7,
                        dotColor: Colors.black12,
                        activeDotColor: themeColor.getColor(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (loginType == 'email') {   // 이메일 로그인일 때만 데이터베이스 넣는 코드
                            // FirebaseAuth 닉네임 받아와서 user객체 만들거나/ 찾아서 객체에 넣기
                            String user_id = FirebaseAuth.instance.currentUser!.uid;

                            // 금방 로그인한 유저에 대한 정보
                            // 데이터베이스에 유저가 저장되어있는지 확인
                            await FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_id).get().then( (QuerySnapshot snap) {
                              String doc_id = '';

                              if (snap.size == 0) { // 데이터베이스에 유저가 저장되어있지 않다면 document하나 추가
                                FirebaseFirestore.instance.collection('userInfo').add({
                                  'uid': user_id, 'nickName': '', 'email': FirebaseAuth.instance.currentUser!.email ?? '', 
                                  'profileImageUrl': 'https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/techmo.png?alt=media&token=d8bf4d4e-cc31-4523-8cba-8694e6572260',
                                  'admin': false
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

                          Navigator.pop(context);

                        },
                        child:  Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: Text('Skip',  style: TextStyle(fontSize: 20, color: Colors.black),))
                        ),
                    ],
                  ),
            ],
          ),
        )
    );
  }

  Widget buildPage({
    required String urlImage,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return SingleChildScrollView( child:
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(title,
                  style: TextStyle(
                      color: themeColor.getColor(),
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.8),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(subtitle,
                    style: TextStyle(color: Colors.black38),
                    textScaleFactor: 1.4),
              ),
              SizedBox(height: 60),
              Container(
                width: double.infinity,
                child:
                    //TODO: 이미지 출력
                    Image.asset(
                      urlImage,
                      fit: BoxFit.fill,
                      // width: double.infinity,
                      //height: MediaQuery.of(context).size.height * 0.3,
                    ),
              )
            ],
          ),
        ));
  }
}
