import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          restaurantSearch(),
          tempMap(),
          recommendList(),
        ],
      ),
      floatingActionButton: editButton(),
    );
  }
}




/* -------------------------------- 검색 위젯: 일단 3개 작성 (삭제 금지) */
Widget restaurantSearch(){
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10,0,10,10),
          child: TextButton(
            onPressed: () {}, //버튼 눌렀을 때 주소 검색지로 이동해야 함
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xfff2f3f6))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('위치 검색', style: TextStyle(color: Color(0xff81858d)), textScaleFactor: 1.1),
                Icon(Icons.search_rounded, color: Color(0xff81858d)),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget searchDesign() {
  return Row(
    children: [
      Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 4),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Color(0xfff2f3f6),
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.search_rounded, color: Color(0xff81858d)),
              ),
              Text("검색", style: TextStyle(color: Color(0xff81858d)),),
            ],
          ),
        ),
      )
    ],
  );
}

Widget textfieldSearch() {
  return Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
    child: TextFormField(
      onTap: () {},
      decoration: InputDecoration(
        suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.search), color: Color(0xff81858d),),
        hintText: '위치 검색',
        hintStyle: TextStyle(
          fontSize: (16/360),
          color: Color(0xff81858d),
        ),
        border: InputBorder.none,
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(20)),
        // ),
        filled: true,
        fillColor: Color(0xfff2f3f6),
      ),
    ),
  );
}

/* -------------------------------- Map 불러올 임시 공간 */
Widget tempMap() {
  return Container(
    width: double.infinity,
    height: 400,
    color: Colors.grey,
    child: Center(child: Text('Map', style: TextStyle(color: Colors.white))),
  );
}

/* -------------------------------- 추천 리스트 (수정 중) */
Widget recommendList(){
  return Container(
    child: Column(
      children: [

        Padding(
          padding: EdgeInsets.fromLTRB(10,20,10,10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('맛집 목록 (수정 중)', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.25),
                  Icon(Icons.star_rounded, color: Colors.amberAccent),
                ],
              ),
              postList(),
            ],
          ),
        ),



      ],
    )
  );
}

/* -------------------------------- 게시글 출력 (수정 중) */
Widget postList() {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Column(
      children: [
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),
        Text('금오공대점'),


      ],
    )
  );
}

/* -------------------------------- 글 쓰기 버튼 (수정 중) */
Widget editButton() {
  return Stack(
      children: [
        Align(
          alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - 0.21),
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.arrow_upward_rounded),
            backgroundColor: themeColor.getColor(),
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.edit),
            backgroundColor: themeColor.getColor(),
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
          ),
        ),
      ],
  );
}