import 'dart:ui';
import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../DB/CommunityItem.dart';
import 'Supplementary/DictionaryCardPage.dart';
import 'Supplementary/ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();


List<String> subImg = [
  'assets/1.png',
  'assets/2.png',
  'assets/3.png',
  'assets/4.png',
  'assets/5.png',
];

// w=1951&q=80

class MainPage extends StatelessWidget {
  MainPage({Key? key, required this.tabController}) : super(key: key);
  late List<String> items;
  late TabController tabController;
  var width, height, portraitH, landscapeH;
  var isPortrait;            

  static const FREEBOARD = 0;
  static const HOTBOARD = 1;

  @override
  Widget build(BuildContext context) {
    items = List<String>.generate(5, (i) => 'Item $i');

    final deviceSize = MediaQuery.of(context).size;
    width = deviceSize.width; // 세로모드 및 가로모드 높이
    height = deviceSize.height;
    portraitH = deviceSize.height / 3.5; // 세로모드 높이
    landscapeH = deviceSize.height / 1.2; // 가로모드 높이
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2!,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    carouselSlide(),
                    weatherText(),
                    todayList(), //오늘의 최신 TIP (임시로 한 테스트용)
                    textList('인기글', HOTBOARD),
                    textList('최신글', FREEBOARD),
                    const Divider(thickness: 0.5),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget carouselSlide() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('best').snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snap.hasError) {
            return Text(snap.error.toString());
          }

          final double width = MediaQuery.of(context).size.width;
          final documents = snap.data!.docs;

          // best가 한 장이라도 있을 때
          if (documents.length != 0) {
            List slideList = documents.toList();
            if (snap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return CarouselSlider(
              options: CarouselOptions(
                height: width / 2 > 350 ? 350 : width / 2,
                viewportFraction: 1.3,
                enlargeCenterPage: false,
                autoPlayAnimationDuration: Duration(milliseconds: 400),
                autoPlay: true,
              ),
              items: slideList.map((item) {
                // item['item_id']가 id인 dictionary item을 가져와서 img필드 -> Image에 출력


                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('dictionaryItem').where('__name__', isEqualTo: item['item_id']).snapshots(),
                  // stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(item['item_id']).snapshots(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final documents = snap.data!.docs;
                    
                    DictionaryCardPage card = DictionaryCardPage(width, height, portraitH, landscapeH, isPortrait);
                    return Container(
                      child: Center(
                        child: GestureDetector(
                          child: Image(image: NetworkImage(documents[0]['thumbnail'])),
                          onTap: (() {
                            String clicked_id = documents[0].id; // 지금 클릭한 dictionaryItem의 도큐먼트 id
                            DictionaryItemInfo dicItemInfo;

                            var doc = FirebaseFirestore.instance.collection('dictionaryItem').doc(documents[0].id).get().then((doc) {
                              
                              dicItemInfo = DictionaryItemInfo();
                              dicItemInfo.setInfo(documents[0].id, documents[0]['author'], documents[0]['card_num'], documents[0]['date'], documents[0]['hashtag'], documents[0]['scrapnum'], documents[0]['thumbnail'], documents[0]['title']);
                              // Provider.of<DictionaryItemInfo>(context, listen:false).setInfo(documents[0].id, documents[0]['author'], documents[0]['card_num'], documents[0]['date'], documents[0]['hashtag'], documents[0]['scrapnum'], documents[0]['thumbnail'], documents[0]['title']);
                              
                              PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(card.pageView(context, dicItemInfo));
                              Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                            });
                                  
                      })))
                    );
                  });
              }).toList(),
            );
          }

          // best가 한 장도 없을 때
          return CarouselSlider(
            options: CarouselOptions(
              height: width / 2 > 350 ? 350 : width / 2,
              viewportFraction: 1.3,
              enlargeCenterPage: false,
              autoPlayAnimationDuration: Duration(milliseconds: 400),
              autoPlay: true,
            ),
            items: subImg.map((item) => Container(child: Center(child: Image(image: AssetImage(item))))).toList(),
          );
        },
      ),
    );
  }
  Container weatherText() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.sunny,
            color: Colors.orange,
            size: 20,
          ),
          Text(
            " 오늘은 날씨 맑음! 빨래하기 좋은 날~",
            style: TextStyle(height: 2.5),
          ),
        ],
      ),
    );
  }
  Widget textPrint(String text, int i) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text',
            textScaleFactor: 1.22,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            // margin: const EdgeInsets.all(0),
            child: TextButton(
                onPressed: () {
                  tabController
                      .animateTo((tabController.index + i)); // 게시판으로 이동
                },
                child: Text(
                  "더 보기 >",
                  textScaleFactor: 0.9,
                  style: TextStyle(
                    color: themeColor.getColor(),
                  ),
                ),
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory)),
          ),
        ],
      ),
    );
  }
  Widget todayList() {
    return Container(
      child: Builder(
        builder: (BuildContext context) {
          final double width = MediaQuery.of(context).size.width;
          //double imagesize = width / 5 > 150 ? 150 : width / 5;
          DictionaryCardPage card = DictionaryCardPage(width, height, portraitH, landscapeH, isPortrait);
          return Column(
            children: [
              Divider(
                thickness: 0.5,
              ),
              textPrint('오늘의 최신 TIP', 1),
              card.mainPostList(context, 2),
              // textPrint('인기글'),
              // Divider(thickness: 0.5,),
              // textPrint('최신글'),
              // Divider(thickness: 0.5,),
            ],
          );
        },
      ),
    );
  }
  Container textList(String communityTitle, int boardType) {
    CommunityItem p = CommunityItem();
    return Container(
        height: 200, //210
        child: Column(
          children: <Widget>[
            Divider(thickness: 0.5,),
            Padding(
              padding: EdgeInsets.all(0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  textPrint('$communityTitle', 2),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('CommunityDB').orderBy('time', descending: true).snapshots(),
                builder: (context, snap) {
                  // if (!snap.hasData) {
                  //   return CircularProgressIndicator();
                  // }

                  if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final documents = snap.data!.docs;
                  return Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: p.getWidgetList(context, documents, boardType))
                  );
                }),
          ],
        ));
  }
}
