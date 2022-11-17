import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context,child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!);
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor.getMaterialColor(),
      ),
      home: Settings(),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 아이디 정보
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('아이디'),
                    ),
                  ],
                ),
              ),
            ),

            // 계정 설정
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '계정', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    ListTile(
                      title: Text('비밀번호 변경'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => changePassword(context)));
                      },
                    ),
                    // ),
                    ListTile(
                      title: Text('스크랩 목록'),
                      onTap: () {
                        // Navigator.of(context).pushNamed('/scrapList');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => scrapList(context)));
                      },
                    ),
                    // Divider(thickness: 0.5),
                  ],
                ),
              ),
            ),

            // 커뮤니티 설정
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      title: Text('커뮤니티 설정',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    ListTile(
                      title: Text('닉네임 설정'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => nickSetting(context)));
                      },
                    ),
                    ListTile(
                      title: Text('프로필 이미지 변경'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => changeImage(context)));
                      },
                    ),
                    ListTile(
                      title: Text('커뮤니티 이용규칙'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => communityRule(context)));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 앱 설정
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '앱 설정', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    ListTile(
                      title: Text('알림 설정'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => alarmSetting(context)));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 비밀번호 변경 페이지
  Widget changePassword(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("비밀번호 변경 페이지")
        ],
      ),
    );
  }

  // 스크랩 목록 페이지
  Widget scrapList(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("스크랩 목록 페이지"),
        ],
      ),
    );
  }

  // 커뮤니티 설정 페이지
  Widget communitySetting(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("커뮤니티 설정 페이지"),
        ],
      ),
    );
  }

  // 닉네임 설정 페이지
  Widget nickSetting(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("닉네임 설정 페이지"),
        ],
      ),
    );
  }

  // 이미지 변경 페이지
  Widget changeImage(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("프로필 이미지 변경 페이지"),
        ],
      ),
    );
  }

  // 커뮤니티 규칙 페이지
  Widget communityRule(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("커뮤니티 규칙 페이지"),
        ],
      ),
    );
  }

  // 앱 설정 페이지
  Widget appSetting(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("앱 설정 페이지"),
        ],
      ),
    );
  }

  // 알림 설정 페이지
  Widget alarmSetting(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          closeIcon(context),
          Text("알림 설정 페이지"),
        ],
      ),
    );
  }

  // 창 닫기 아이콘
  IconButton closeIcon(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.close),
      color: themeColor.getColor(),
      alignment: Alignment.topRight,
      iconSize: 30,
    );
  }
}