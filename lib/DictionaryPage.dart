import 'package:flutter/material.dart';
import 'package:a_living_dictionary/main.dart';
import 'ThemeColor.dart';

/* 백과사전: 청소, 빨래, 요리, 기타 */

ThemeColor themeColor = ThemeColor();

List<String> txtValue = [
  'box1',
  '2줄로됐을때 2줄로됐을때 2줄로됐을때 2줄로됐을때 2줄로됐을때 2줄로됐을때',
  'box3',
  'box4',
  'box4',
  'bossssssssssssssssssssssssssssssssssss4'
];
List<String> imgValue = [
  'assets/4.png', 'assets/3.png', 'assets/2.png', 'assets/1.png', 'assets/4.png', 'assets/4.png'
];

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:

      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
              length: 5,
              initialIndex: 0,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[



                  /* ---------------------------------------- 상단 탭 */

                  Container(
                    child: TabBar(
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
                  ),



                  /* ---------------------------------------- 탭 내용 */
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child:

                    TabBarView(
                      children: <Widget>[

                        // postList(context), // 추천 탭
                        recommand(context),
                        slideList(context, '청소'),


                        bestList(),


                        postList(context),
                        postList(context),
                      ],
                    ),

                  ),





                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



// TODO: 위젯 만들기

Widget bestList(){ // 인기 TOP 6
  return Container(
    child: GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: 6, //게시글 몇 개 출력할 건지
      itemBuilder: (context, index){
        return
          Card(
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
          );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1.8, // 가로 세로 비율
      ),
    ),
  );
}

// TODO: 추천 탭
Widget recommand(BuildContext context) {
  return SingleChildScrollView(
      child: Column(
        children: [
          textBox(context, "인기 Top 10"),
          // postList(context),
          // top10(context),
          // post(context, 10),
          textBox(context, "오늘은 대청소 하는 날!"),
          imageBox(context, 4),

          textBox(context, "옷에 양념이 묻었다면?"),
          imageBox(context, 4),

          textBox(context, "뭐 먹을지 고민된다면?"),
          imageBox(context, 4),
        ],
      )
  );
}

Widget top10(BuildContext context) {
  return GridView.builder(
    padding: EdgeInsets.all(5),
    itemCount: txtValue.length, //몇 개 출력할 건지
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
          //color: Colors.green,
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
    },
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2 / 1.8, // 가로 세로 비율
    ),
  );
}

Widget textBox(BuildContext context, String s) {
  return Text(
    s,
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget imageBox(BuildContext context, int i) {
  return SizedBox(
    height: 150,
    child: ListView.builder(
        itemCount: i,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          height: 100,
          width: 200,
          margin: EdgeInsets.all(8.0),
          child: Center(
            child: Image.asset(imgValue[index % imgValue.length]),
          ),
        )
    ),
  );
}
// TODO: 위젯 만들기
Widget postList(BuildContext context){
  return Container(
    child: GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: txtValue.length, //몇 개 출력할 건지
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
            //color: Colors.green,
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
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1.8, // 가로 세로 비율
      ),
    ),
  );
}

Widget Temp(BuildContext context) {
  return Scaffold(
    appBar: AppBar(

    ),
    body: Text("확인용 페이지"),
  );
}


Widget slideList(BuildContext context, String text){ // 상단 가로 스크롤
  return Column(
    children: [
      Row(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: Text("관리자가 엄선한 $text TIP", style: TextStyle(fontWeight: FontWeight.bold),),),
      ],),

      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(5),
          child: Row(
            children: List.generate(5, (index) => slideView(index)),
          ),
      ),

    ],
  );
}

Widget slideView(int index){ // 상단 가로 스크롤 게시글 출력
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