import 'package:flutter/material.dart';
import '../../main.dart';
import 'Search.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class CommunityWritePage extends StatelessWidget {
  CommunityWritePage({super.key});

  late var width;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();


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
            title: Text("글 쓰기", style: TextStyle(color: Colors.black)),
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
                    TextButton(onPressed: (){}, child: Text("등록", style: TextStyle(color: Colors.black),))
                  ],
                ),
              ), //expanded
            ),
          ),
        ));
  }

  Widget getTitleWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //const Text("제목"),
      Container(
        width: (width > 750) ? (750) : (width),
        height: 40,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border: Border(
              //bottom: const BorderSide(color: Color(0xAAdadada), width: 1.3)
            )
        ),
        child: TextField(
          controller: titleController,
          showCursor: true,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.7, color: Color(0xAAbababa))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.7, color: Color(0xAA333333))),
            hintText: "제목"
          ),
        )
      ),
    ]);
  }
  Widget getBodyWidget() {
    return Container(
        width: (width > 750) ? (750) : (width),
        height: 300,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all()
        ),
        child: TextField(
          showCursor: true,
          maxLines: null,
          cursorColor: Colors.black,
          controller: bodyController,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              hintText: "본문"
          ),
        )
    );
  }
}
