
import 'package:flutter/material.dart';
import 'package:a_living_dictionary/main.dart';
import 'ThemeColor.dart';

/* 백과사전: 청소, 빨래, 요리, 기타 */

ThemeColor themeColor = ThemeColor();

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
                length: 5,
                initialIndex: 0,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // 상단 탭
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
                    // 탭 내용
                    Container(
                      height: 400,
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            child: Center(
                               child: Text('추천 탭'),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text('청소 탭'),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text('빨래 탭'),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text('요리 탭'),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text('기타 탭'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
      )
    );
  }
}

