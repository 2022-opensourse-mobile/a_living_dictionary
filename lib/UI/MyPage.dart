import 'dart:ui';

import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

import 'package:provider/provider.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';

// 화면전환 페이지 위젯은 전부 'my___'로 시작함


ThemeColor themeColor = ThemeColor();

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Settings();
    //   MaterialApp(
    //   builder: (context,child) {
    //     return MediaQuery(
    //         data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!);
    //   },
    //   theme: ThemeData(
    //     primarySwatch: themeColor.getMaterialColor(),
    //   ),
    //   home: Settings(),
    // );
  }
}


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [

          appID(),
          appCommunity(),
          appAccount(context),
          appPush(),
          appGuide(),
          appEtc(),

        ],
      ),
    );
  }


  Widget appID() { //프로필 사진 + 닉네임
    return Consumer<Logineduser>(
      builder: (context, userProvider, child) {
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userProvider.profileImageUrl), //프로필 사진
              ),
              title: Text(userProvider.nickName, style: TextStyle(fontWeight: FontWeight.bold),), //닉네임 출력
            ),
            Divider(thickness: 0.5,),
          ],
        );
      }
    );
  }

  Widget appCommunity() { //커뮤니티 설정
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(title: Text('커뮤니티',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeColor.getColor(),
              leadingDistribution: TextLeadingDistribution.even,
            ),
            textScaleFactor: 0.9), visualDensity: VisualDensity(horizontal: 0, vertical: -3)),
        ListTile(title: Text('작성한 게시물'), onTap: (){}),
        ListTile(title: Text('작성한 댓글'), onTap: (){}),
        ListTile(title: Text('스크랩 목록'), onTap: (){
          
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myScrap());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        Divider(thickness: 0.5,),
      ],
    );
  }

  Widget appAccount(BuildContext context) { //계정 설정
    return Consumer<Logineduser>(   // 로그인된 사용자 받아오기위한 provider consumer
      builder: (context, userProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(title: Text('계정 설정',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeColor.getColor(),
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                textScaleFactor: 0.9), visualDensity: VisualDensity(horizontal: 0, vertical: -3)),
            ListTile(
              title: Text('비밀번호 변경'), 
              onTap: (){
                if (userProvider.uid.substring(0,5) == 'kakao' || userProvider.uid.substring(0,5) == 'naver') { // 소셜 로그인 유저
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("소셜 로그인 유저는 비밀번호를 변경할 수 없습니다"),));
                } else {    // 이메일 로그인 유저
                  PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myPassword());
                  Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
                }
              }
            ),
            ListTile(
              title: Text('닉네임 변경'), 
              onTap: (){
                //  
              }
            ),
            ListTile(title: Text('프로필 이미지 변경'), onTap: (){
              PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myProfileImg());
              Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
            }),
            Divider(thickness: 0.5,),
          ],
        );
      }
    );
  }

  Widget appPush() { //알림 설정
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(title: Text('앱 푸시 알림',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeColor.getColor(),
              leadingDistribution: TextLeadingDistribution.even,
            ),
            textScaleFactor: 0.9), visualDensity: VisualDensity(horizontal: 0, vertical: -3)),
        ListTile(title: Text('알림 설정'), onTap: (){}),
        Divider(thickness: 0.5,),
      ],
    );
  }

  Widget appGuide() { //이용 안내
    return Column(
      children: [
        ListTile(title: Text('이용 안내',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeColor.getColor(),
              leadingDistribution: TextLeadingDistribution.even,
            ),
            textScaleFactor: 0.9), visualDensity: VisualDensity(horizontal: 0, vertical: -3)),
        ListTile(title: Text('공지 사항'), onTap: (){}),
        ListTile(title: Text('앱 이용규칙'), onTap: (){}),
        ListTile(title: Text('문의하기'), onTap: (){}),
        ListTile(title: Text('버전 정보'), onTap: (){}),
        Divider(thickness: 0.5,)
      ],
    );
  }

  Widget appEtc() { //로그아웃
    return Column(
      children: [
        ListTile(
          title: Text('로그아웃',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeColor.getColor(),
            ),),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }

  /* -------------------------------------------------------------------------------- 화면전환 페이지 */

  Widget myPosting() {
    return Scaffold(
      appBar: AppBar(title: Text('작성한 게시물'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          
        ],
      ),
    );
  }

  Widget myComment() {
    return Scaffold(
      appBar: AppBar(title: Text('작성한 댓글'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget pageView(BuildContext context, DictionaryItemInfo? dicItemInfo) {

    return Scaffold(
      appBar: AppBar(
        title: Consumer2<DictionaryItemInfo, Logineduser>(
          builder: (context, dicProvider, userProvider, child) {

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dicProvider.title, style: TextStyle(fontSize: 17)),
                Expanded(child: SizedBox()),
                Text(dicProvider.scrapnum.toString(), style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").where("docID", isEqualTo: dicProvider.doc_id)
                            .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return CircularProgressIndicator();
                    }
                    
                    if (snap.data!.size != 0) {   // user가 해당 게시글을 스크랩한 기록이 없는 경우
                      return IconButton(
                        icon: const Icon(
                          // if (context.watch<DictionaryItemInfo>)
                          Icons.bookmark_outlined,
                          color: Colors.amberAccent,
                          size: 30,   
                        ),
                        onPressed: (){
                          FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").where("docID", isEqualTo: dicProvider.doc_id).get().then((value) {
                            value.docs.forEach((element) {
                              FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList")
                                .doc(element.id)
                                .delete();
                            });
                          });
                          dicProvider.subScrapNum(dicProvider.doc_id);
                        }
                      );
                    } else {                          // user가 해당 게시글을 스크랩한 기록이 있는 경우
                      return IconButton(
                        icon: const Icon(
                        // if (context.watch<DictionaryItemInfo>)
                          Icons.bookmark_outline_rounded,
                          color: Colors.amberAccent,
                          size: 30,   
                        ),
                        onPressed: (){
                          FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").add({'docID' : dicProvider.doc_id});
                          
                          dicProvider.addScrapNum(dicProvider.doc_id);
                        });
                    }   
                  },
                  )
                  ],
                );
          }
        ),
         
        titleSpacing: 0,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dicItemInfo!.doc_id).collection('dictionaryCard').orderBy("card_id", descending: false).snapshots(),
          builder: (context, AsyncSnapshot snap) {
            List cardDocList;
            if (snap.hasError) {
              return Text(snap.error.toString()); 
            }
            
            final documents = snap.data!.docs;

            if (!snap.hasData || snap.data.size == 0) {
              // return nonExistentCard();
              return Text("error");
            }
            else{
              cardDocList = documents.toList();
              if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return PageView.builder(
                controller: PageController(
                  initialPage: 0,
                ),
                itemCount: cardDocList.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(cardDocList[0]['img']),
                            // 카드 맨 첫 번째 사진으로 배경 설정
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.network(
                                cardDocList[index]['img']), // 카드 해당 이미지 출력
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                cardDocList[index]['content'].toString().replaceAll(RegExp(r'\\n'), '\n'),  // 게시글 줄바꿈 구현
                                style: TextStyle(color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
          }),
    );
  }

  Widget myScrap () {
    final deviceSize = MediaQuery.of(context).size;
    var width = deviceSize.width; // 세로모드 및 가로모드 높이
    var height = deviceSize.height;
    var portraitH = deviceSize.height / 3.5; // 세로모드 높이
    var landscapeH = deviceSize.height / 1.2; // 가로모드 높이
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // return Container();

    return Material(
      child: Consumer<Logineduser>(
        builder: (context, userProvider, child) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").snapshots(),
            builder: (context, AsyncSnapshot snap) {
              if (!snap.hasData) {
                return CircularProgressIndicator();
              }
              final userDocuments = snap.data!.docs;
  
              return Container(
                child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                itemCount: userDocuments.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('dictionaryItem').where('__name__', isEqualTo: userDocuments[index]['docID']).snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return CircularProgressIndicator();
                      }
                      final itemDocuments = snap.data!.docs;

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        width: width / 2,
                        height: width*(101515),
                        child: InkWell(
                          onTap: () {
                            String clicked_id = itemDocuments[0].id; // 지금 클릭한 dictionaryItem의 item_id
                            DictionaryItemInfo dicItemInfo = DictionaryItemInfo();
                            dicItemInfo.setInfo(clicked_id, itemDocuments[0]['author'], itemDocuments[0]['card_num'], itemDocuments[0]['date'], itemDocuments[0]['hashtag'], itemDocuments[0]['scrapnum'], itemDocuments[0]['thumbnail'], itemDocuments[0]['title']);
                            Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(clicked_id, itemDocuments[0]['author'], itemDocuments[0]['card_num'], itemDocuments[0]['date'], itemDocuments[0]['hashtag'], itemDocuments[0]['scrapnum'], itemDocuments[0]['thumbnail'], itemDocuments[0]['title']);
                            PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, dicItemInfo));
                            Navigator.push(
                                context, pageRouteWithAnimation.slideLeftToRight());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0), 
                                  child: Image.network(itemDocuments[0]['thumbnail']), // TODO 임시 사진, 썸네일로 바꿔야함
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                                  // 게시글 제목 여백
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                        child: Text(
                                          "#"+itemDocuments[0]['hashtag'],
                                          style: TextStyle(
                                            color: themeColor.getColor(),
                                          ),
                                          textScaleFactor: 1,
                                        ),
                                      ),
                                      Text(
                                          // snapshot.data!.docs[0]['title']
                                          itemDocuments[0]['title'])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 10/9 // 가로 세로 비율
                ),
                )
              );
  
            });
        }
      ),
    );
  }

  Widget myPassword() {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 변경'), elevation: 0.0),
      body: Column(
        children: [
          
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          TextButton(onPressed: (){}, child: Text("변경"))
        ],
      ),
    );
  }

  Widget myNicknamed() {
    return Scaffold(
      appBar: AppBar(title: Text('닉네임 변경'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myProfileImg() {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 이미지 변경'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myAppPush() {
    return Scaffold(
      appBar: AppBar(title: Text('알림 설정'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myNotice() {
    return Scaffold(
      appBar: AppBar(title: Text('공지 사항'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myAppRule() {
    return Scaffold(
      appBar: AppBar(title: Text('앱 이용규칙'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myAsk() {
    return Scaffold(
      appBar: AppBar(title: Text('문의하기'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myAppVersion() {
    return Scaffold(
      appBar: AppBar(title: Text('버전 정보'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }



  /* -------------------------------------------------------------------------------- 다른 위젯들 */

  Widget dd(String text) { //비번 변경 TextFormField
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
      child: TextFormField(
        onTap: () {},
        decoration: InputDecoration(
          suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.search), color: Color(0xff81858d),),
          hintText: '$text',
          hintStyle: TextStyle(
            fontSize: (16/360),
            color: Color(0xff81858d),
          ),
          border: InputBorder.none,
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(20)),
          // ),
          filled: true,
          fillColor: Color(0xfff2f3f6),
        ),
      ),
    );
  }
}