import 'dart:io';
import 'dart:ui';
import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:a_living_dictionary/UI/Supplementary/DictionaryCardPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Supplementary//ThemeColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../DB/DictionaryItem.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();


class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with TickerProviderStateMixin {
  late TabController _tabController;
  var width, height, portraitH, landscapeH;
  var isPortrait;
  late DictionaryCardPage card;
  late DictionaryCardPage slideCard;

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
    card = DictionaryCardPage(width, height, portraitH, landscapeH, isPortrait);

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
              recommandPage(context, card),
              otherPage(context, card, "청소"),
              otherPage(context, card, "빨래"),
              otherPage(context, card, "요리"),
              otherPage(context, card, "기타"),
            ],
          ),
        )
      ],
    );
  }

  List<QuerySnapshot<Object?>> getDocByFirst(String s){
    late List<QuerySnapshot<Object?>> doc;
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(s).snapshots(),
        builder: (context, snap) {
          
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // if(!snap.hasData){
          //   sleep(Duration(seconds: 1));
          // }
          
          doc = snap.data!.docs as List<QuerySnapshot<Object?>>;
          return Container();
    });
    return doc;
  }


  // 추천 탭 페이지
  Widget recommandPage(BuildContext context, DictionaryCardPage card) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // //추가할 때 필요한 코드 @@삭제
          // Row(
          //   children: [
          //     makeButton("청소"),
          //     makeButton("빨래"),
          //     makeButton("요리"),
          //     makeButton("기타"),
          //   ],
          // ),
          startxtIcon(context, '인기 TOP 4'),
          card.recommendPostList(context),
          Divider(thickness: 0.5,),
          slideList(context,"청소", "오늘은 대청소하는 날!", false),
          slideList(context,"빨래", "빨래의 모든 것", false),
          slideList(context,"요리", "뭐 먹을지 고민된다면?", false),
        ],
      ),
    );
  }

  // 추천탭이 아닌 탭(청소, 빨래 등)
  Widget otherPage(BuildContext context, DictionaryCardPage card, String tabName) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            slideList(context, tabName, '관리자가 엄선한 $tabName TIP', true),
            textBox(context, '최신글'),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: card.otherPostList(context, tabName)
            ),
            Divider(thickness: 0.5,),
          ],
        )
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

  // 텍스트 출력 + 가로 스크롤 리스트 출력
  Widget slideList(BuildContext context, String tabName, String title, bool iconTF){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconTF? startxtIcon(context, title) : textBox(context, title),
        slide(context, tabName),
        Divider(thickness: 0.5,),
      ],
    );
  }

  // 가로 스크롤 리스트
  Widget slide(BuildContext context, String tabName){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(5,0,5,5), //5055
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: tabName).where('recommend', isEqualTo: true).snapshots(),
        builder: (context, snap) {

          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final documents = snap.data!.docs;

          return Row(
            children: List.generate(snap.data!.size, (index){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                width: width / 2,
                height: width*(9/20),
      
                child: InkWell(
                  onTap: () {
                    String clicked_id = documents[index].id;  // 지금 클릭한 dictionaryItem의 도큐먼트 아이디
                    DictionaryItemInfo dicItemInfo = DictionaryItemInfo();
                    dicItemInfo.setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);
                    Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);

                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(card.pageView(context, dicItemInfo));
                   
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
                          child: Image.network(documents[index]['thumbnail']),      // 확인필요TODO
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
                              Text(documents[index]['title'], textScaleFactor: 1)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } ), //TODO@@@@@@@@@@@@@@@@
          );
        }
      )
    );
  }
}
