import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ThemeColor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'community/Post.dart';
import 'DictionaryPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'main.dart';


ThemeColor themeColor = ThemeColor();

List<String> txtValue = [
  'box1',
  '2줄로됐을때 2줄로됐을때 2줄로됐을때',
];

List<String> testImg = [
  'assets/1.png',
  'assets/2.png',
  'assets/3.png',
  'assets/4.png',
  'assets/5.png',
];

final List<String> imgList = [
  'assets/5.png',
  'assets/6.png',
  'assets/2.png',
  'assets/4.png',
  'assets/8.png',
];
// w=1951&q=80

class MainPage extends StatelessWidget {
  MainPage({Key? key, required this.tabController}) : super(key: key);
  late List<String> items;
  late TabController tabController;
  var width, height, portraitH, landscapeH;
  var isPortrait;

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
                    todayList('요리'), //오늘의 최신 TIP (임시로 한 테스트용)
                    textList('인기글'),
                    textList('최신글'),
                    Divider(thickness: 0.5,),
                  ],
                ),
              ),
            );
          },
        ));
  }


  Widget carouselSlide() {
    int _currentIndex = 0;
    return Container(
      // color: Colors.green,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('best').snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if(!snap.hasData) {
            return CircularProgressIndicator();
          }

          if (snap.hasError) {
            return Text(snap.error.toString());
          }

          final double width = MediaQuery.of(context).size.width;
          final documents = snap.data!.docs;


          // best가 한 장이라도 있을 때
          if (documents.length != 0) { 

            List slideList = snap.data?.docs.toList();
          
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
                // item['item_id']가 아이디인 dictionary item을 가져와서 img필드 -> Image에 출력
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('dictionaryItem')
                    .where('__name__', isEqualTo: item['item_id']) 
                    .snapshots(),
                  builder: (context, snapshot) {
                    
                    return Container(
                      child: Center(
                        child: Image(image: NetworkImage(snapshot.data!.docs[0]['thumbnail']))
                      )
                    );
                  }
                );
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
            items: testImg
                .map((item) => Container(
              child: Center(
                child: Image(image: AssetImage(item))
              ),
            ))
                .toList(),
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
      padding: EdgeInsets.fromLTRB(10,0,10,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$text', textScaleFactor: 1.22,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            // margin: const EdgeInsets.all(0),
            child: TextButton(
                onPressed: () {
                  tabController.animateTo((tabController.index + i)); // 게시판으로 이동
                },
                child: Text("더 보기 >", textScaleFactor: 0.9, style: TextStyle(color: themeColor.getColor(),),),
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory)),
          ),
        ],
      ),
    );
  }

  Widget todayList(String str){
    return Container(
      child: Builder(builder: (BuildContext context) {
        final double width = MediaQuery.of(context).size.width;
        double imagesize = width / 5 > 150 ? 150 : width / 5;
        return Column(
          children: [
            Divider(thickness: 0.5,),
            textPrint('오늘의 최신 TIP', 1),
            postList(context, '$str', 2),
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

  Container textList(String communityTitle) {
    Post p = Post();
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
                stream: FirebaseFirestore.instance
                    .collection('communityDB')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final documents = snapshot.data!.docs;
                  return Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: p.getWidgetList(documents)));
                }),
          ],
        ));
  }

  Widget postList(BuildContext context, String tabName, int postNum){
    return Container(
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(5,0,5,5),
        itemCount: postNum, //몇 개 출력할 건지
        itemBuilder: (context, index){
          Widget w = post(context, index, tabName, imgList, txtValue);
          return (w != null)?(w):(Text('w is null'));
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (width / 2) / (isPortrait? (height < 750? 250 : portraitH) : landscapeH), // 가로 세로 비율
        ),
      ),
    );
  }

  Widget post(BuildContext context, int index, String tabName,
      List<String> imgList, List<String> textList) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('dictionaryItem').orderBy('date', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;

          int i = (documents.length-index-1 > 0)?(documents.length-index-1):(0);
          final it = documents.elementAt(i);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            width: width / 2,
            height: (isPortrait ? (height < 750 ? 250 : portraitH) : landscapeH),
            child: InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => tempPage(context)));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => pageView(context)));
                PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, it.id, it['title']));
                Navigator.push(
                    context, pageRouteWithAnimation.slideLeftToRight());
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
                      child: Image.network(it['thumbnail']),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 0), // 게시글 제목 여백
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Text(
                              "#${it['hashtag'].toString()}",
                              style: TextStyle(
                                color: themeColor.getColor(),
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                          Text(it['title'].toString(), textScaleFactor: 1)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget pageView(BuildContext context, String dic_id, String title) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).
        collection('dictionaryCard').orderBy('card_id',descending: false).snapshots(),

      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        final doc = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, textScaleFactor: 1),
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
            itemCount: doc.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        //image: ExactAssetImage(),
                        image: Image.network(doc[index]['img']).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 23.0, sigmaY: 23.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.network(doc[index]['img']),
                  )
                ],
              );
            },
          ),
        );
      }
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