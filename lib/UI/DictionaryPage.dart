import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:a_living_dictionary/UI/Supplementary/DictionaryCardPage.dart';
import 'Supplementary//ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';


ThemeColor themeColor = ThemeColor();

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late double width, height, portraitH, landscapeH;
  late bool isPortrait;
  late DictionaryCardPage card;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    width = deviceSize.width;     // 세로모드 및 가로모드 높이
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
              dictionaryTabPage(context, card, "청소"),
              dictionaryTabPage(context, card, "빨래"),
              dictionaryTabPage(context, card, "요리"),
              dictionaryTabPage(context, card, "기타"),
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

          doc = snap.data!.docs as List<QuerySnapshot<Object?>>;
          return Container();
    });
    return doc;
  }


  // 추천탭이 아닌 탭(청소, 빨래 등)
  Widget dictionaryTabPage(BuildContext context, DictionaryCardPage card, String tabName) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carouselList(context, tabName, '관리자가 엄선한 $tabName TIP', true),
            textBox(context, '최신글'),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: card.otherPostList(context, tabName)
            ),

          ],
        )
    );
  }

  // 텍스트 + 아이콘
  Widget startxtIcon(BuildContext context, String str) {
    return Row(
      children: [
        textBox(context, '$str'),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Icon(Icons.star_rounded, color: Colors.amberAccent),
        )
      ],
    );
  }
  
  // 텍스트 출력
  Widget textBox(BuildContext context, String str) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 12, 0, 11),
      child: Text(str, style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.3),
    );
  }

  // 텍스트 출력 + 가로 스크롤 리스트 출력
  Widget carouselList(BuildContext context, String tabName, String title, bool iconTF){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconTF? startxtIcon(context, title) : textBox(context, title),
        carouselSlide(context, tabName),
        const Divider(thickness: 0.5,),
      ],
    );
  }

  // 가로 스크롤 리스트
  Widget carouselSlide(BuildContext context, String tabName){
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: tabName).where('recommend', isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot snap) {
          
          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
              return const CircularProgressIndicator();
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

                return Container(
                  child: Center(
                    child: GestureDetector(
                      child: Image(image: NetworkImage(item['thumbnail']), fit: BoxFit.contain),

                      onTap: (() {
                        Provider.of<DictionaryItemInfo>(context, listen:false).setInfo(item.id, item['author'], item['card_num'], item['date'], item['hashtag'], item['scrapnum'], item['thumbnail'], item['title']);
                        
                        PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(card.pageView(context));
                        Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                  })))
                );
              }).toList(),
            );
              
          }

          // best가 한 장도 없을 때
          return const Text("내용이 없습니다");
        },
      ),
    );
  }
 
}
