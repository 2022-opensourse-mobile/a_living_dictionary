import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ThemeColor.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'community/Post.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'main.dart';

final List<String> imgList = [
  'assets/3.png',
  'assets/4.png',
  'assets/5.png',
  'assets/6.png',
  'assets/4.png',
];
// w=1951&q=80

class MainPage extends StatelessWidget {
  MainPage({Key? key, required this.tabController}) : super(key: key);
  late List<String> items;
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    items = List<String>.generate(5, (i) => 'Item $i');

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
                    recommendedItems(),
                    textList('인기글'),
                    textList('최신글')
                  ],
                ),
              ),
            );
          },
        ));
  }

  Container recommendedItems() {
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromARGB(66, 74, 74, 74),
            width: 1,
          ),
        ),
        // height: 210,

        child: Builder(builder: (context) {
          final double width = MediaQuery.of(context).size.width;
          double imagesize = width / 5 > 150 ? 150 : width / 5;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "추천 꿀TIP", textScaleFactor: 1.1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextButton(
                              onPressed: () {
                                tabController.animateTo(
                                    (tabController.index + 2)); // 게시판으로 이동
                              },
                              child: Text("더 보기 >", textScaleFactor: 0.9),
                              style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory))
                        ],
                      ),
                      visualDensity: VisualDensity(vertical: -4),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tipBlock(imagesize, '꿀잠 자는법', 'assets/recommend1.png'),
                        tipBlock(imagesize, '다래끼 났을 때', 'assets/recommend2.png'),
                        tipBlock(imagesize, '꿀잠 자는법', 'assets/recommend1.png'),
                        tipBlock(imagesize, '다래끼 났을 때', 'assets/recommend2.png'),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Column tipBlock(double imagesize, String text, String imageName) {
    return Column(
      children: [
        InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child:
                  Image.asset(imageName, width: imagesize, height: imagesize),
            )),
        Text(text, textScaleFactor: 1)
      ],
    );
  }

  Widget carouselSlide() {
    int _currentIndex = 0;
    return Container(
      color: Colors.white,
      child: Builder(
        builder: (context) {
          final double width = MediaQuery.of(context).size.width;
          return CarouselSlider(
            options: CarouselOptions(
              height: width / 2 > 350 ? 350 : width / 2,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlayAnimationDuration: Duration(milliseconds: 400),
              autoPlay: true,
            ),
            items: imgList
                .map((item) => Container(
                      child: Center(child: Image(image: AssetImage(item))),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  Container textList(String communityTitle) {
    Post p = Post();
    return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromARGB(66, 74, 74, 74),
            width: 1,
          ),
        ),
        height: 210,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          communityTitle, textScaleFactor: 1.1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextButton(
                            onPressed: () {
                              tabController.animateTo(
                                  (tabController.index + 2)); // 게시판으로 이동
                            },
                            child:
                                Text("더 보기 >", textScaleFactor: 0.9),
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory))
                      ],
                    ),
                    visualDensity: VisualDensity(vertical: -4),
                  ),
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
            textScaleFactor: 1,
            style: TextStyle(height: 2.5),
          ),
        ],
      ),
    );
  }
}
