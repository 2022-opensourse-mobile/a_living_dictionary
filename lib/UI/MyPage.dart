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
        ListTile(title: Text('스크랩 목록'), onTap: (){}),
        Divider(thickness: 0.5,),
      ],
    );
  }

  Widget appAccount(BuildContext context) { //계정 설정
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
        ListTile(title: Text('비밀번호 변경'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myPassword());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('닉네임 변경'), onTap: (){}),
        ListTile(title: Text('프로필 이미지 변경'), onTap: (){}),
        Divider(thickness: 0.5,),
      ],
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

  Widget myScrap () {
    return Scaffold(
      appBar: AppBar(title: Text('스크랩 목록'), elevation: 0.0),
      body: Column(
        children: [
          Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
          Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
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