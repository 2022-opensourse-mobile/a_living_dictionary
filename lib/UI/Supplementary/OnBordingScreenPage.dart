
import 'package:a_living_dictionary/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


//TODO: 이미지 가로버전에서 오버플로우 되는 거 고치기
class onboardingScreenPage extends StatefulWidget {
  onboardingScreenPage(this.loginType, {Key? key}) : super(key: key);
  String loginType;

  @override
  State<onboardingScreenPage> createState() => _onboardingScreenPageState(loginType);
}

class _onboardingScreenPageState extends State<onboardingScreenPage> {
  _onboardingScreenPageState(this.loginType);
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
    return SingleChildScrollView( 
      child: Container(
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
      )
    );
  }
}


