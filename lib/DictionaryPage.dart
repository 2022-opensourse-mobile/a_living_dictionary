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
  'bossssssssssssssssssssssssssssssssssssx4'
];
List<String> imgValue = ['assets/4.png', 'assets/3.png', 'assets/2.png', 'assets/1.png', 'assets/4.png', 'assets/4.png'];

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
                    height: 645,
                    child:

                    TabBarView(
                      children: <Widget>[

                        postList(context), // 추천 탭

                        slideList(context), // 청소 탭


                        Container(
                          child: Center(
                            child: Text('빨래 탭 미리보기'),
                          ),
                        ),
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

Widget postList(BuildContext context){
  return Container(
    child: GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: txtValue.length, //몇 개 출력할 건지
      itemBuilder: (context, index){
        return

          Card(
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
          );


      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1.8, // 가로 세로 비율
      ),
    ),
  );
}


/* 가로 스크롤 */
Widget slideList(BuildContext context){
  return Column(
    children: [
      Row(children: [Text("관리자 PICK!", style: TextStyle(fontWeight: FontWeight.bold),)],),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: 250,
                height: 100,
                margin: EdgeInsets.all(5),
                color: Colors.red,
              ),
              Container(
                width: 250,
                height: 100,
                margin: EdgeInsets.all(5),
                color: Colors.red,
              ),
              Container(
                width: 250,
                height: 100,
                margin: EdgeInsets.all(5),
                color: Colors.red,
              ),
            ],
          )
      ),
    ],
  );
}