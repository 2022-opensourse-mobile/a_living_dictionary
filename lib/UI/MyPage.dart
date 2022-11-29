import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

import 'package:provider/provider.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';

// 화면전환 페이지 위젯은 전부 'my___'로 시작함

ThemeColor themeColor = ThemeColor();

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  final formKey = GlobalKey<FormState>();
  late String myNickname, myEmail, askTitle, askContent;
  TextEditingController newPassword = TextEditingController();
  TextEditingController equalPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [

          appID(),
          appCommunity(),
          appAccount(),
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
        ListTile(title: Text('작성한 게시물'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myPosting());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('작성한 댓글'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myComment());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('스크랩 목록'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myScrap());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        Divider(thickness: 0.5,),
      ],
    );
  }

  Widget appAccount() { //계정 설정
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
        ListTile(title: Text('닉네임 변경'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myNicknamed());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('프로필 이미지 변경'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myProfileImg());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
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
        ListTile(title: Text('알림 설정'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myAppPush());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
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
        ListTile(title: Text('공지 사항'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myNotice());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('앱 이용 규칙'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myAppRule());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('문의하기'), onTap: (){
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(myAsk());
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
        }),
        ListTile(title: Text('버전 정보'), trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)), //버전 설정
            onTap: (){ snackBar('현재 버전은 1.0.0 입니다'); }), //TODO:클릭 시 스낵바에 현재 버전 출력
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
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text('로그아웃하시겠습니까?'),
                actions: [
                  TextButton(child: Text('아니오',
                    style: TextStyle(color: themeColor.getMaterialColor(),
                      fontWeight: FontWeight.bold,),),
                      onPressed: () { Navigator.pop(context); }),
                  TextButton(child: Text('예',
                    style: TextStyle(color: themeColor.getMaterialColor(),
                      fontWeight: FontWeight.bold,),), onPressed: () { Navigator.pop(context); FirebaseAuth.instance.signOut(); })
                ],
              ),
            );
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
          Text('작성한 게시물 페이지', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myComment() {
    return Scaffold(
      appBar: AppBar(title: Text('작성한 댓글'), elevation: 0.0),
      body: Column(
        children: [
          Text('작성한 댓글 페이지', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myScrap () {
    return Scaffold(
      appBar: AppBar(title: Text('스크랩 목록'), elevation: 0.0),
      body: Column(
        children: [
          Text('스크랩 목록 페이지', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myPassword() {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 변경'), elevation: 0.0, actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getMaterialColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Text('완료', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(this.formKey.currentState!.validate()) {

                  //TODO: ↓ 완료버튼 누르면 실행되어야 할 부분 ↓
                  //파이어베이스에 비밀번호가 저장되어야 함....
                  //TODO: ↑ 완료버튼 누르면 실행되어야 할 부분 ↑

                  Navigator.pop(context);
                  snackBar('비밀번호 변경이 완료되었습니다');

                  //파이어베이스에 저장되고 나면 TextFormField 초기화해줘야 함
                  newPassword.text = '';
                  equalPassword.text = '';
                }
                },
            ),
          ),
        ),
      ],),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('현재 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.1),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Form(
                      key: this.formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) {
                              if(value!.isEmpty) return '현재 비밀번호를 입력하세요';
                            },
                            cursorColor: themeColor.getMaterialColor(),
                            decoration: InputDecoration(
                              hintText: '현재 비밀번호',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor()),
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: themeColor.getMaterialColor()),
                              ),),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                              child: Text('새 비밀번호', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.1)),

                          TextFormField(
                            controller: newPassword,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) {
                              if(value!.isEmpty) return '새 비밀번호를 입력하세요';
                            },
                            cursorColor: themeColor.getMaterialColor(),
                            decoration: InputDecoration(
                              hintText: '새 비밀번호',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor()),
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: themeColor.getMaterialColor()),
                              ),),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                          TextFormField(
                            controller: equalPassword,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) {
                              if(value!.isEmpty) return '새 비밀번호를 재입력하세요';
                              if(newPassword.text != equalPassword.text) return '비밀번호가 일치하지 않습니다';
                            },
                            cursorColor: themeColor.getMaterialColor(),
                            decoration: InputDecoration(
                              hintText: '새 비밀번호 확인',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor()),
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: themeColor.getMaterialColor()),
                              ),),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget myNicknamed() {
    return Scaffold(
      appBar: AppBar(title: Text('닉네임 변경'), elevation: 0.0, actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getMaterialColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Text('완료', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(this.formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  snackBar('닉네임 변경이 완료되었습니다');

                  /*  TODO: ↓ 완료버튼 누르면 실행되어야 할 부분 ↓ */
                  // TODO: 여기에 작성
                }
              },
            ),
          ),
        ),
      ],),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('닉네임', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.1),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Form(
                    key: this.formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      initialValue: "나는야곰돌이", //TODO: 현재 내 닉네임이 출력되어야 함!!!!!!!!!!!!!!!!!!
                      onSaved: (name) {myNickname = name!;},
                      validator: (value) {
                        if(value!.isEmpty) return '닉네임을 입력하세요';
                      },
                      cursorColor: themeColor.getMaterialColor(),
                      decoration: InputDecoration(
                        hintText: '닉네임',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor.getMaterialColor()),
                          //border: InputBorder.none,
                          //focusedBorder: InputBorder.none,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor.getMaterialColor()),
                        ),),
                    ),
                  ),
                ),
                Text('※ 욕설, 비하, 성적 수치심을 유발하는 닉네임은 관리자가 임의로 변경하오니 주의 바랍니다.',
                    style: TextStyle(color: Colors.grey), textScaleFactor: 0.9)
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget myProfileImg() {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 이미지 변경'), elevation: 0.0, actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getMaterialColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Text('완료', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
                snackBar('프로필 이미지 변경이 완료되었습니다');
              },
            ),
          ),
        ),
      ],),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/250?image=9'), //TODO: 프로필 이미지
                minRadius: 80,
                maxRadius: 120,
              ),
            ),),
          TextButton(
              child: Text('프로필 이미지 변경하기',
                  style: TextStyle(fontWeight: FontWeight.bold, color: themeColor.getMaterialColor()),
                  textScaleFactor: 1.2),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Wrap(
                        children: [
                          ListTile(leading: Icon(Icons.photo_library), title: Text('갤러리'),
                            onTap: () {
                              //TODO: 갤러리 누르면 실행되어야 할 부분
                            },
                          ),
                          ListTile(leading: Icon(Icons.camera_alt), title: Text('카메라'),
                            onTap: () {
                              //TODO: 카메라 누르면 실행되어야 할 부분
                            },
                          ),
                          ListTile(leading: Icon(Icons.image_not_supported), title: Text('프로필 이미지 삭제하기'),
                            onTap: () {
                              //TODO: 삭제하기 누르면 실행되어야 할 부분
                            },
                          ),
                        ],
                      );
                    }
                );
              }
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text('※ 욕설, 비하, 성적 수치심을 유발하는 이미지는 관리자가 임의로 변경하오니 주의 바랍니다.',
                     style: TextStyle(color: Colors.grey), textScaleFactor: 0.9))
        ],
      )
    );
  }

  Widget myAppPush() {
    return Scaffold(
      appBar: AppBar(title: Text('알림 설정'), elevation: 0.0),
      body: Column(
        children: [
          Text('알림 설정 페이지', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myNotice() {
    return Scaffold(
      appBar: AppBar(title: Text('공지 사항'), elevation: 0.0),
      body: Column(
        children: [
          Text('공지 사항 페이지', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myAppRule() {
    return Scaffold(
      appBar: AppBar(title: Text('앱 이용 규칙'), elevation: 0.0),
      body: Column(
        children: [
          Text('앱 이용 규칙 페이지', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.0),
        ],
      ),
    );
  }

  Widget myAsk() {
    return Scaffold(
      appBar: AppBar(title: Text('문의하기'), elevation: 0.0, actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getMaterialColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Text('완료', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(this.formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text('개인정보 수집 및 이용 동의 안내',
                              style: TextStyle(
                                  color: themeColor.getMaterialColor(),
                                  fontWeight: FontWeight.bold)),
                          content: Text('문의 처리를 위해 문의 내용에 포함된 이메일, 회원정보 등 '
                                        '개인정보가 포함된 문의 내용을 수집하며 개인정보처리방침에 따라 3년 후 파기됩니다.\n\n'
                                        '동의하시겠습니까?\n비동의 시 문의 접수가 제한됩니다.'),
                          actions: [
                            TextButton(child: Text('비동의',
                              style: TextStyle(
                                color: themeColor.getMaterialColor(),
                                fontWeight: FontWeight.bold,),),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            TextButton(
                                child: Text('동의',
                                  style: TextStyle(
                                    color: themeColor.getMaterialColor(),
                                    fontWeight: FontWeight.bold,),),
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          content: Text('문의하기가 완료되었습니다.\n'
                                                        '영업일 기준 2~7일 이내 작성하신 이메일로 답변드리겠습니다.'),
                                          actions: [
                                            TextButton(
                                                child: Text('예',
                                                  style: TextStyle(
                                                    color: themeColor
                                                        .getMaterialColor(),
                                                    fontWeight: FontWeight
                                                        .bold,),),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);


                                                  /* TODO: 문의하기 완료 버튼 누르면 수행되어야 할 부분 ↓ 밑에 작성하기 */


                                                  /* 문의하기 완료 버튼 누르면 수행되어야 할 부분 ↑ 위에 작성하기 */


                                                })
                                          ],
                                        ),
                                  );
                                })
                          ],
                        ),
                  );
                }},
            ),
          ),
        ),
      ],),

      body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: this.formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (email) {myEmail = email!;},
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => validateEmail(value),
                          cursorColor: themeColor.getMaterialColor(),
                          decoration: InputDecoration(
                            hintText: '연락받을 이메일 (abcd@naver.com)',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                        Divider(thickness: 0.5),
                        TextFormField(
                          onSaved: (title) {askTitle = title!;},
                          cursorColor: themeColor.getMaterialColor(),
                          validator: (value) {
                            if(value!.isEmpty) return '내용을 입력하세요';
                          },
                          decoration: InputDecoration(
                            hintText: '제목',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                        Divider(thickness: 0.5),
                        SizedBox(
                          width: double.infinity,
                          height: 430,
                          child: TextFormField(
                            onSaved: (content) {askContent = content!;},
                            validator: (value) {
                              if(value!.isEmpty) return '내용을 입력하세요';
                            },
                            cursorColor: themeColor.getMaterialColor(),
                            maxLines: 100,
                            decoration: InputDecoration(
                              hintText: '문의할 내용을 입력하세요',
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(10,10,10,20),
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('※ 문의 답변 시간 안내',
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              textScaleFactor: 0.9,
                            ),
                            Text('월, 화, 수, 목, 금 09:00 ~ 18:00\n'
                                '토, 일, 공휴일 휴무\n\n'
                                '(금요일 18:00 이후부터 일요일까지 접수된 문의는 월요일부터 순차적으로 답변드립니다.)',
                              style: TextStyle(color: Colors.grey),
                              textScaleFactor: 0.9,
                            ),
                          ],
                        )
                    ),),
                ],
              ),
            ),
          ]),
    );
  }
  



  /* -------------------------------------------------------------------------------- 다른 함수들 */

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return '잘못된 이메일 형식입니다';
    else
      return null;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$text'), //내용
          duration: Duration(seconds: 2), //올라와 있는 시간
        )
    );
  }


}



// class temp extends StatelessWidget {
//   const temp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Settings();
//     //   MaterialApp(
//     //   builder: (context,child) {
//     //     return MediaQuery(
//     //         data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!);
//     //   },
//     //   theme: ThemeData(
//     //     primarySwatch: themeColor.getMaterialColor(),
//     //   ),
//     //   home: Settings(),
//     // );
//   }
// }