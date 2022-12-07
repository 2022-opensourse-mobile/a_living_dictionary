
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/OnBordingScreenPage.dart';
import 'package:a_living_dictionary/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';


// 이메일 로그인
class EmailLoginPage extends StatelessWidget {
   EmailLoginPage({super.key});

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
                    EmailProviderConfiguration(),  // 이메일 인증
                  ],
                              
                subtitleBuilder: (context, action) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: action == AuthAction.signIn
                        ? const Text('로그인을 진행하세요.\n회원가입을 원하시는 분은 Register를 눌러주세요.')
                        : const Text('회원가입을 진행하세요.'),
                  );
                },
                        
                 sideBuilder: (context, shrinkOffset) {   // 화면 늘렸을 때 나오는 사진
                   return Padding(
                     padding: const EdgeInsets.all(20),
                     child: AspectRatio(
                       aspectRatio: 1,
                       child: Image.asset('assets/app_icon.png'),
                     ),
                   );
                 },
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

            return onboardingScreenPage('email'); // 첫 설명 화면으로
          }
        );
      }
    );
  }

  void nickNameAlert(BuildContext context) {  // 닉네임 첫 설정 화면
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
                  TextFormField(
                    controller: _nickNameController,
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

