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

                        postList(context), // 추천 탭

                        slideList(context, '청소'),


                        bestList(),


                        Container(
                          child: Center(
                            child: Text('요리 탭 미리보기'),
                          ),
                        ),
                        Container(
                          child: Text('기타 탭 미리보기'),
                        ),
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



Widget postList(BuildContext context){ // 게시글 출력
  return Container(
    child: GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: txtValue.length, //게시글 몇 개 출력할 건지
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