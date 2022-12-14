import 'dart:ui';

import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:a_living_dictionary/UI/Supplementary/CheckClick.dart';

import '../DictionaryPage.dart';
import 'PageRouteWithAnimation.dart';

class DictionaryCardPage {
  DictionaryCardPage(this.width, this.height, this.portraitH, this.landscapeH, this.isPortrait);

  double width, height, portraitH, landscapeH;
  bool isPortrait;
  final CheckClick clickCheck = CheckClick();

  //메인화면 post
  Widget mainPostList(BuildContext context, int postNum) {
    return Container(
      child: GridView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
        itemCount: postNum,
        //몇 개 출력할 건지
        itemBuilder: (context, index) {
          Widget w = post(context, index);
          return (w != null) ? (w) : (Text('w is null'));
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 10/9, // 가로 세로 비율
        ),
      ),
    );
  }

  Widget recommendPostList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('best').snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData)
            return Center(child: CircularProgressIndicator());

          if (snap.hasError)
            return Center(child: CircularProgressIndicator());

          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final documents = snap.data!.docs;

          return Container(
            child: gridViewList(context, documents, "추천"),
          );
        });
  }

  Widget otherPostList(BuildContext context, String tabName) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: tabName).snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData)
            return Center(child: CircularProgressIndicator());

          if (snap.hasError)
            return Center(child: CircularProgressIndicator());

          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final documents = snap.data!.docs;

          return Container(
            child: gridViewList(context, documents, tabName),
          );
        }
    );
  }

  // 공통되는 gridView 분리
  Widget gridViewList(BuildContext context, List<DocumentSnapshot> documents, String tabName) {
    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      itemCount: documents.length,
      //몇 개 출력할 건지
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          width: width / 2,
          height: width*(101515),
          child: InkWell(
            onTap: () {
              String clicked_id = documents[index].id; // 지금 클릭한 dictionaryItem의 item_id
              Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);

              PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context));
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
                    child: Image.network(documents[index]['thumbnail']),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),// 게시글 제목 여백
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: Text(
                            tabName == "search"? "#${documents[index]['hashtag']}" : "#$tabName",
                            style: TextStyle(
                              color: themeColor.getColor(),
                            ),
                            textScaleFactor: 0.9,
                          ),
                        ),
                        Text(
                          documents[index]['title'],
                          textScaleFactor: 1.07,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 10/9 // 가로 세로 비율
      ),
    );
  }

  Widget post(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').orderBy('date', descending: false).snapshots(),
        builder: (contextR, snap) {
          if (!snap.hasData) {
            return const CircularProgressIndicator();
          }

          if (snap.hasError)
            return Center(child: CircularProgressIndicator());

          if (snap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final documents = snap.data!.docs;

          int i = (documents.length - index - 1 > 0)?(documents.length - index - 1):(0);
          final it = documents.elementAt(i);
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: InkWell(
              onTap: () {
                Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(it.id, it['author'], it['card_num'], it['date'], it['hashtag'], it['scrapnum'], it['thumbnail'], it['title']);
                    
                PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context));
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
                      child: Image.network(it['thumbnail']),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 0), // 게시글 제목 여백
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
                              textScaleFactor: 0.9,
                            ),
                          ),
                          Text(it['title'].toString(), textScaleFactor: 1.07, overflow: TextOverflow.ellipsis,)
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
  
  Widget pageView(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Consumer2<DictionaryItemInfo, Logineduser>(
            builder: (context, dicProvider, userProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dicProvider.title, style: const TextStyle(fontSize: 17)),
                    const Expanded(child: SizedBox()),
                    
                    
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").where("docID", isEqualTo: dicProvider.doc_id)
                                .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData)
                          return Center(child: CircularProgressIndicator());

                        if (snap.hasError)
                          return Center(child: CircularProgressIndicator());

                        if (snap.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        
                        if (snap.data!.size != 0) {   // user가 해당 게시글을 스크랩한 기록이 없는 경우
                          return Row(
                            children: [
                              Text(dicProvider.scrapnum.toString(), style: const TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                              IconButton(
                                icon: const Icon(
                                  Icons.bookmark_outlined,
                                  color: Colors.amberAccent,
                                  size: 30,   
                                ),
                                onPressed: (){
                                  if(clickCheck.isRedundentClick(DateTime.now())) return;

                                  dicProvider.subScrapNum(dicProvider.doc_id);
                                  
                                  FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").where("docID", isEqualTo: dicProvider.doc_id).get().then((value) {
                                    value.docs.forEach((element) {
                                      FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList")
                                        .doc(element.id)
                                        .delete();
                                    });
                                  });
                                  
                                }
                              ),
                            ],
                          );
                        } else {                          // user가 해당 게시글을 스크랩한 기록이 있는 경우
                          return Row(
                            children: [
                              Text(dicProvider.scrapnum.toString(), style: const TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                              IconButton(
                                icon: const Icon(
                                  Icons.bookmark_outline_rounded,
                                  color: Colors.amberAccent,
                                  size: 30,   
                                ),
                                onPressed: (){
                                  if(clickCheck.isRedundentClick(DateTime.now())) return;

                                  dicProvider.addScrapNum(dicProvider.doc_id);
                                  FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").add({'docID' : dicProvider.doc_id});
                                }),
                            ],
                          );
                        }   
                      },
                    )
                  
                  ],
                );
              }
            ),
            titleSpacing: 0,
            elevation: 0,
          ),
          body: Consumer<DictionaryItemInfo>(
            builder: (context, dicProvider, child) {

              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dicProvider.doc_id).collection('dictionaryCard').orderBy("card_id", descending: false).snapshots(),
                builder: (context, AsyncSnapshot snap) {
                  List cardDocList;

                  if (snap.hasError) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  
                  if (!snap.hasData || snap.data == null || snap.data!.size == 0) {
                    return nonExistentCard();
                  }
                  else {
                    final documents = snap.data!.docs;
                    cardDocList = documents.toList();

                    return PageView.builder(
                      controller: PageController(
                        initialPage: 0,
                      ),
                      itemCount: cardDocList.length +1,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(cardDocList[0]['img']),    // 카드 맨 첫 번째 사진으로 배경 설정
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ),

                            if (index != 0) // 제목 아닌 컨텐츠 페이지
                              Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(cardDocList[index-1]['img']),    // 카드 해당 이미지 출력
                                      SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            cardDocList[index-1]['content'].toString().replaceAll(RegExp(r'\\n'), '\n'),  // 게시글 줄바꿈 구현
                                            style: const TextStyle(color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (index == 0) // 제목 페이지
                              Consumer<DictionaryItemInfo>(
                                  builder: (context, dicProvider, child) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(child: SizedBox(),),
                                              Icon(Icons.star, color: Colors.amber[600],),
                                              Text(
                                                "스크랩하기↗",
                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                              ),
                                              SizedBox(width:30)
                                            ],
                                          ),
                                          SizedBox(height: height * 0.25,),
                                          Image.network(dicProvider.thumbnail),
                                          SizedBox(height: 10),
                                          Center(
                                            child: Text(
                                              dicProvider.title,
                                              style: const TextStyle(color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.2,),
                                        ],
                                      ),
                                    );

                                  }
                              ),
                          ],
                        );
                      },
                    );
                  }
                });
            }
          ),
        );
      }
  

  Widget nonExistentCard() {
    return PageView.builder(
      controller: PageController(
        initialPage: 0,
      ),
      itemCount: 1,
      itemBuilder: (context, index) {
        return const Text("카드 없음");
      },
    );
  }
}
