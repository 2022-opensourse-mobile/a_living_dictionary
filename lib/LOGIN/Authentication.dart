

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';


//https://firebase.google.com/codelabs/firebase-auth-in-flutter-apps#5

// 이메일 로그인 구현중
class Authentication extends StatelessWidget {
  const Authentication({super.key});
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(), // 로그인 로그아웃 이거 구독하고 있다가 builder로 화면 새롭게그려줌
      builder: (context, snapshot) {
        

        if (!snapshot.hasData) {// 인증을 받지 않았으면 로그인화면
          return MaterialApp(
            
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
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
                          image: AssetImage('assets/recommend1.png')
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
                        ? const Text('자취백과사전입니다. 로그인 ㄱㄱ')
                        : const Text('자취백과사전입니다. 회원가입 ㄱㄱ'),
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
                       child: Image.asset('assets/recommend1.png'),
                     ),
                   );
                 },
                  
                  // showAuthActionSwitch: false,  
                ),
              ),
            ),
          );
        } 

        return Container(
          color: Colors.white,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text("사용 Tip", style: TextStyle( fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
              Text("자취 백과사전 환영합니다!", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal)),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: () async {
                      // await viewModel.logout();
                      // setState((){}); // 화면 갱신만 하는 것

                      // FirebaseAuth 닉네임 받아와서 user객체 만들거나/ 찾아서 객체에 넣기
                      String user_id = FirebaseAuth.instance.currentUser!.uid;

                      // 금방 로그인한 유저에 대한 정보
                      // 데이터베이스에 유저가 저장되어있는지 확인
                      await FirebaseFirestore.instance.collection('userInfo').where('uid', isEqualTo: user_id).get().then( (QuerySnapshot snap) {
                        String doc_id = '';

                        if (snap.size == 0) { // 데이터베이스에 유저가 저장되어있지 않다면 document하나 추가
                          FirebaseFirestore.instance.collection('userInfo').add({
                            'uid': user_id, 'nickName': '', 'email': FirebaseAuth.instance.currentUser!.email ?? '', 'profileImageUrl': ''
                          }).then((value) {
                            doc_id =  value.id.toString();
                            FirebaseFirestore.instance.collection('userInfo').doc(doc_id).update({
                              'docID': doc_id
                            });
                          });
                        }
//  여기 나중에 수정해봐 효림@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                        // snap.docs.forEach((doc) {
                        //   loginedUser.nickName = doc['nickName'];
                        //   loginedUser.email = doc['email'];
                        //   loginedUser.doc_id = doc.id;
                        // });
                        }
                      );

                      Navigator.pop(context);

                    }, 
                    child:  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Text('skip',  style: TextStyle(fontSize: 20, color: Colors.black),))
                    ),
                ],
              ),
            ],
          ),
        );
        
      }
      // Signin 위젯이 있다. flutterfire_ui 깔기
      );
  }
}