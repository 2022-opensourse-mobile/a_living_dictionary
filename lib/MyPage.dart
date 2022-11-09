import 'package:flutter/material.dart';
import 'ThemeColor.dart';

bool isLogin = true;
ThemeColor themeColor = ThemeColor();

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor.getMaterialColor(),
      ),
      home: isLogin? Login() : Logout(),
      routes: {
        '/changePW': (context) => changePassword(context),
        '/scrapList': (context) => scrapList(context),
        '/communitySetting': (context) => communitySetting(context),
        '/nickSetting': (context) => nickSetting(context),
        '/changeImage': (context) => changeImage(context),
        '/communityRule': (context) => communityRule(context),
        '/appSetting': (context) => appSetting(context),
        '/alarmSetting': (context) => alarmSetting(context),
      },
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
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loginUser(),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Account(context),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Community(context),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: App(context),
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
                child: App(context),
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

ListView Account(BuildContext context) {
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
        onTap: () {
          Navigator.of(context).pushNamed('/changePW');
        },
      ),
      // ListTile(
      //   title: Text('이메일 변경'),
      //   onTap: () {
      //     Navigator.of(context).pushNamed('/changeEmail');
      //   },
      // ),
      ListTile(
        title: Text('스크랩 목록'),
        onTap: () {
          Navigator.of(context).pushNamed('/scrapList');
        },
      ),
      // Divider(thickness: 0.5),
    ],
  );
}

ListView Community(BuildContext context) {
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
        onTap: () {
          Navigator.of(context).pushNamed('/nickSetting');
        },
      ),
      ListTile(
        title: Text('프로필 이미지 변경'),
        onTap: () {
          Navigator.of(context).pushNamed('/changeImage');
        },
      ),
      ListTile(
        title: Text('커뮤니티 이용규칙'),
        onTap: () {
          Navigator.of(context).pushNamed('/communityRule');
        },
      ),
      // Divider(thickness: 0.5),
    ],
  );
}

ListView App(BuildContext context) {
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
        onTap: (){
          Navigator.of(context).pushNamed('/alarmSetting');
        },
      ),
      // ListTile(
      //   title: Text('암호 잠금'),
      //   onTap: () {},
      // ),
    ],
  );
}

// NamedRoute Page
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

// Widget changeEmail() {
//   return Scaffold(
//     body: ListView(
//       children: <Widget>[
//         Text("이메일 변경 페이지"),
//       ],
//     ),
//   );
// }

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