import 'package:flutter/material.dart';
import 'package:a_living_dictionary/main.dart';
import 'ThemeColor.dart';

/* 백과사전: 청소, 빨래, 요리, 기타 */

ThemeColor themeColor = ThemeColor();


// 기존 txtValue의 2번째 내용 수정
List<String> txtValue = [
  'box1',
  '2줄로됐을때 2줄로됐을때 2줄로됐을때',
  'box3',
  'box4',
  'box4',
  'bossssssssssssssssssssssssssssssssssss4'
];

List<String> imgValue = [
  'assets/4.png', 'assets/3.png', 'assets/2.png', 'assets/1.png', 'assets/4.png', 'assets/4.png'
];

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
              postList(context, 10),
              // otherPage(context, "기타"),
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
          textBox(context, "인기 Top 10"),
          postList(context, 10),
          Divider(thickness: 0.5,),
          slideList(context, "오늘은 대청소 하는 날!", 4),
          slideList(context, "옷에 양념이 묻었다면?", 4),
          slideList(context, "뭐 먹을지 고민된다면?", 4),
        ],
      ),
    );
  }

// 나머지 탭 화면
  Widget otherPage(BuildContext context, String tab) {
    return SingleChildScrollView(
      child: Column(
        children: [
          slideList(context, "관리자가 엄선한 $tab TIP", 6),
          postList(context, 10),
        ],
      )
    );
  }

  // 글 리스트
  Widget postList(BuildContext context, int i){
    return Container(
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        itemCount: i, //몇 개 출력할 건지
        itemBuilder: (context, index){
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Temp(context)));
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
                    child: Image.asset(imgValue[index % imgValue.length]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(txtValue[index % txtValue.length]),
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1, // 가로 세로 비율
        ),
      ),
    );
  }

  // 클릭 시, 다른 페이지 이동
  Widget Temp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("확인용 페이지"),
    );
  }

  // 텍스트 출력 + 가로 스크롤 리스트 출력
  Widget slideList(BuildContext context, String text, int i){ // 상단 가로 스크롤
    return Column(
      children: [
        textBox(context, text),
        slide(context, i),
        Divider(thickness: 0.5,),
      ],
    );
  }

  // 텍스트 출력
  Widget textBox(BuildContext context, String str) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10,5,10,5),
            child: Text(str, style: TextStyle(fontWeight: FontWeight.bold))
        ),],
    );
  }

  // 가로 스크롤 리스트
  Widget slide(BuildContext context, int i){ // 상단 가로 스크롤
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(5),
      child: Row(
        children: List.generate(i, (index) => slideView(index)),
      ),
    );
  }

  // 가로 스크롤 개별 게시글
  Widget slideView(int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 220,
      height: 198,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(imgValue[index]),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(txtValue[index]),
            ),
          ],
        ),
      ),
    );
  }
}