import 'package:flutter/material.dart';
import '../../main.dart';
import 'Search.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class CommunityPostPage extends StatelessWidget {
  CommunityPostPage(this.tabName, {super.key});

  final tabName;
  late var width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: themeColor.getWhiteMaterialColor(),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(tabName, style: TextStyle(color: Colors.black)),
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: new Icon(Icons.search),
                onPressed: () => {
                  //showSearch(context: context, delegate:Search(null))
                },
              )
            ],
          ),
          //Body : 싱글 스크롤
          body: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Container(
                  width: (width > 750) ? (750) : (width),
                  color: Colors.white,
                  child: Column(
                    //전체 Column
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getTitleWidget(), //제목 위젯
                      getBodyWidget(), // 본문 위젯
                      getCommentWriteWidget(), // 댓글 작성 위젯
                      getCommentWidget(), // 댓글 위젯
                      getCommentWidget(), // 댓글 위젯
                      getCommentWidget(), // 댓글 위젯
                      getCommentWidget(), // 댓글 위젯
                    ],
                  ),
                ), //expanded
            ),
          ),
        ));
  }

  Widget getTitleWidget() {
    return Column(children: [
      Container(
        width: (width > 750) ? (750) : (width),
        height: 40,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xAAdadada), width: 1.5),
              bottom: const BorderSide(color: Color(0xAAdadada), width: 1.3),
            ),
            color: const Color(0xAAefefef)),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
          child: Text("title1", style: TextStyle(fontSize: 25)),
        ),
      ),
      Container(
        width: width,
        height: 30,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xAAdadada), width: 1.3))),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
          child: Text("writer1", style: TextStyle(fontSize: 15)),
        ),
      ),
    ]);
  }

  Widget getBodyWidget() {
    return Container(
      width: (width > 750) ? (750) : (width),
      height: 300,
      decoration: const BoxDecoration(
          border: Border(
            bottom: const BorderSide(color: Color(0xAAdadada), width: 1.3),
          ),
      ),
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Divider(),
          Text("body1", style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget getCommentWriteWidget(){
    return Container(
      width: (width > 750) ? (750) : (width),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xAAdadada), width: 1.0)
      ),
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Row(
        children: [
          SizedBox(
            width: (width > 650) ? (650) : (width),
            height: 120,
            child: const TextField(
              decoration: InputDecoration(
                hintText: "댓글 입력"
              ),
              maxLines: null,
              maxLength: 100,
              cursorColor: Colors.black,
            ),
          ),
          TextButton(
              onPressed: (){},
              child: Text("등록", style: TextStyle(color: Colors.black))
          )
        ],
      ),
    );
  }

  Widget getCommentWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ListTile(
          title: Text("com_writer1",
              style: TextStyle(fontSize: 14, color: Colors.black)),
          leading: Icon(Icons.account_box),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text("com_body1"),
        ),
        Divider(thickness: 1.0,)
      ],
    );
  }
}
