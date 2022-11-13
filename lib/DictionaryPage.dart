import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:a_living_dictionary/main.dart';
import 'ThemeColor.dart';

/* 백과사전: 청소, 빨래, 요리, 기타 */

ThemeColor themeColor = ThemeColor();

// 기존 txtValue의 2번째 내용 수정
List<String> txtValue = [
  'box1',
  '2줄로됐을때 2줄로됐을때 2줄로됐을때 2줄로됐을때',
  'box3',
  'box4',
  'box4',
  'bossssssssssssssssssssssssssssssssssss4'
];

List<String> imgValue = [
  'assets/1.png', 'assets/2.png', 'assets/3.png', 'assets/4.png', 'assets/5.png', 'assets/6.png'
];

List<String> secondimgValue = [
  'assets/7.png', 'assets/8.png', 'assets/7.png', 'assets/8.png', 'assets/7.png', 'assets/8.png'
];

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with TickerProviderStateMixin {
  late TabController _tabController;
  var width, height, portraitH, landscapeH;
  var isPortrait;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    width = deviceSize.width; // 세로모드 및 가로모드 높이
    height = deviceSize.height;
    portraitH = deviceSize.height / 3.5; // 세로모드 높이
    landscapeH = deviceSize.height / 1.2; // 가로모드 높이
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // 상단 탭
        TabBar(
          controller: _tabController,
          labelColor: themeColor.getColor(),
          indicatorColor: themeColor.getColor(),
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(text: "추천",),
            Tab(text: "청소",),
            Tab(text: "빨래",),
            Tab(text: "요리",),
            Tab(text: "기타",),
          ],
        ),
        // 탭 내용
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              recommandPage(context),
              otherPage(context, "청소"),
              otherPage(context, "빨래"),
              otherPage(context, "요리"),
              otherPage(context, "기타"),
            ],
          ),
        )
      ],
    );
  }

  // 추천 탭 화면
  Widget recommandPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          startxtIcon(context, '인기 TOP 4'),
          postList(context, "추천", 4),
          Divider(thickness: 0.5,),
          slideList(context, "오늘은 대청소하는 날!", 4, false),
          slideList(context, "빨래의 모든 것", 4, false),
          slideList(context, "뭐 먹을지 고민된다면?", 4, false),
        ],
      ),
    );
  }

  // 텍스트 + 아이콘
  Widget startxtIcon(BuildContext context, String str) {
    return Row(
      children: [
        textBox(context, '$str'),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Icon(Icons.star_rounded, color: Colors.amberAccent),
        )
      ],
    );
  }

  // 텍스트 출력
  Widget textBox(BuildContext context, String str) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 12, 0, 11),
      child: Text(str, style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.22),
    );
  }

  // 나머지 탭 화면
  Widget otherPage(BuildContext context, String tabName) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            slideList(context, '관리자가 엄선한 $tabName TIP', 6, true),
            textBox(context, '최신글'),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child:postList(context, tabName, 10),),
            Divider(thickness: 0.5,),
          ],
        )
    );
  }

  // 게시글 리스트
  Widget postList(BuildContext context, String tabName, int postNum){
    return Container(
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(5,0,5,5),
        itemCount: postNum, //몇 개 출력할 건지
        itemBuilder: (context, index){
          return post(context, index, tabName, imgValue, txtValue);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (width / 2) / (isPortrait? (height < 750? 250 : portraitH) : landscapeH), // 가로 세로 비율
        ),
      ),
    );
  }

  // 개별 게시글
  Widget post(BuildContext context, int index, String tabName, List<String> imgList, List<String> textList) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      width: width / 2,
      height: (isPortrait? (height < 750? 250 : portraitH) : landscapeH),

      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => tempPage(context)));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => pageView(context)));
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context));
          Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
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
                child: Image.asset(imgList[index % imgList.length]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8,5,8,0), // 게시글 제목 여백
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0 , 3),
                      child: Text(
                        "#$tabName",
                        style: TextStyle(
                          color: themeColor.getColor(),
                        ),
                        textScaleFactor: 1,
                      ),
                    ),
                    Text(textList[index % textList.length], textScaleFactor: 1)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 클릭 시, 스크롤 페이지로 이동
  Widget tempPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("제목", textScaleFactor: 1),
            Icon(Icons.bookmark, color: Colors.amberAccent, size: 30,),
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ListTile $index", textScaleFactor: 1),
                  Image.asset(secondimgValue[index % secondimgValue.length])
                ],
              )
          );
        },
      ),
    );
  }

  // 클릭 시, 슬라이드 페이지로 이동
  Widget pageView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("제목", textScaleFactor: 1),
            Icon(Icons.bookmark_outline_rounded, color: Colors.amberAccent, size: 30,),
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: PageView.builder(
        controller: PageController(
          initialPage: 0,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(secondimgValue[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset(secondimgValue[index % secondimgValue.length]),
              )
            ],
          );
        },
      ),
    );
  }

  // 텍스트 출력 + 가로 스크롤 리스트 출력
  Widget slideList(BuildContext context, String title, int slideNum, bool iconTF){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconTF? startxtIcon(context, title) : textBox(context, title),
        slide(context, slideNum),
        Divider(thickness: 0.5,),
      ],
    );
  }

  // 가로 스크롤 리스트
  Widget slide(BuildContext context, int i){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(5,0,5,5), //5055
      child: Row(
        children: List.generate(i, (index) => post(context, index, "TIP", secondimgValue, txtValue)),
      ),
    );
  }
}

// Route 이동할 때 애니메이션 주기
class PageRouteWithAnimation {
  final Widget page;

  PageRouteWithAnimation(this.page);

  Route slideRitghtToLeft() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  Route slideLeftToRight() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}