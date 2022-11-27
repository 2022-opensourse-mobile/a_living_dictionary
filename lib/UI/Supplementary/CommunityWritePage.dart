import 'package:a_living_dictionary/DB/CommunityItem.dart';
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
  TextEditingController nameController = TextEditingController();


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
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xAAaaaaaa)),
                            right: BorderSide(color: Color(0xAAaaaaaa)),
                          )
                      ),
                      child: const Divider(
                        color: Color(0xAAaaaaaa),
                        thickness: 0.3,
                      ),
                    ),
                    getBodyWidget(), // 본문 위젯

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getRegWidget(context),
                        getCancelWidget(context)
                      ],
                    ) // 등록 버튼
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
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        width: (width > 750) ? (750) : (width),
        height: 40,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xAAaaaaaa)),
              left: BorderSide(color: Color(0xAAaaaaaa)),
              right: BorderSide(color: Color(0xAAaaaaaa)),
            )
        ),
        child: Row(
          children: [
            SizedBox(
              width: (width > 750) ? (500) : (width/2-1),
              child: TextField(
                controller: titleController,
                showCursor: true,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  hintText: "제목",
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
              width: (width > 750) ? (240) : (width/2-1),
              /*child: TextField(
                controller: nameController,
                showCursor: true,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    hintText: "닉네임",
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),*/
              //child: Text("닉네임"),
            ),
          ],
        )
      ),
    ]);
  }
  Widget getBodyWidget() {
    return Container(
        width: (width > 750) ? (750) : (width),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xAAaaaaaa)),
              left: BorderSide(color: Color(0xAAaaaaaa)),
              right: BorderSide(color: Color(0xAAaaaaaa)),
            )
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
  Widget getRegWidget(BuildContext context){
    return ElevatedButton(
      child: Text("등록", style: TextStyle(color: Colors.black)),
      onPressed: (){
        CommunityItem item = CommunityItem(
          title: titleController.text,
          body: bodyController.text,
          writer_id: nameController.text,
          boardType: 0,
          time: DateTime.now(),
          hashTag: "자유",
          like: 0
        );
        item.add();
        titleController.text = "";
        bodyController.text = "";
        nameController.text = "";
        Navigator.pop(context);
      },

    );
  }
  Widget getCancelWidget(BuildContext context){
    return ElevatedButton(
      child: Text("취소"),
      onPressed: (){
        Navigator.pop(context);
      },
    );
  }
}
