import 'package:flutter/material.dart';
import 'ThemeColor.dart';

void main() {
  runApp(const MyPage());
}

bool isLogin = true;
ThemeColor themeColor = ThemeColor();

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '내 정보',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor.getMaterialColor(),
      ),
      home: isLogin? Login() : Logout(),
    );
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loginUser(),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Account(),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Community(),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: App(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: logoutUser(),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: App(),
              ),
            ),
          ],
        )
    );
  }
}

ListView logoutUser() {
  return ListView(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.question_mark),
        title: Text('로그인이 필요합니다.'),
      ),
    ],
  );
}

ListView loginUser() {
  return ListView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.person_outline),
        title: Text('아이디'),
      ),
      // Divider(thickness: 0.5),
    ],
  );
}

ListView Account() {
  return ListView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: <Widget>[
      ListTile(
        title: Text('계정', style: TextStyle(fontWeight: FontWeight.bold),),
        // leading: Icon(Icons.person),
        // title: Text('계정'),
      ),
      ListTile(
        title: Text('비밀번호 변경'),
        onTap: () {},
      ),
      ListTile(
        title: Text('이메일 변경'),
        onTap: () {},
      ),
      ListTile(
        title: Text('스크랩 목록'),
        onTap: () {},
      ),
      // Divider(thickness: 0.5),
    ],
  );
}

ListView Community() {
  return ListView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: <Widget>[
      ListTile(
        title: Text('커뮤니티 설정', style: TextStyle(fontWeight: FontWeight.bold),),
        // leading: Icon(Icons.keyboard),
        // title: Text('커뮤니티 설정'),
      ),
      ListTile(
        title: Text('닉네임 설정'),
        onTap: () {},
      ),
      ListTile(
        title: Text('프로필 이미지 변경'),
        onTap: () {},
      ),
      ListTile(
        title: Text('커뮤니티 이용규칙'),
        onTap: () {},
      ),
      // Divider(thickness: 0.5),
    ],
  );
}

ListView App() {
  return ListView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: <Widget>[
      ListTile(
        title: Text('앱 설정', style: TextStyle(fontWeight: FontWeight.bold),),
        // leading: Icon(Icons.settings),
        // title: Text('앱 설정'),
      ),
      ListTile(
        title: Text('알림 설정'),
        onTap: (){},
      ),
      ListTile(
        title: Text('암호 잠금'),
        onTap: () {},
      ),
    ],
  );
}