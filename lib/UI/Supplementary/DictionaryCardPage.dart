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

  var width, height, portraitH, landscapeH;
  var isPortrait;
  final CheckClick clickCheck = CheckClick();

  //메인화면 post
  Widget mainPostList(BuildContext context, int postNum) {
    return Container(
      child: GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
        itemCount: postNum,
        //몇 개 출력할 건지
        itemBuilder: (context, index) {
          Widget w = post(context, index);
          return (w != null) ? (w) : (Text('w is null'));
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 10/9, // 가로 세로 비율
          //childAspectRatio: (width / 2) / (isPortrait?(height < 750 ? 250 : portraitH):landscapeH), // 가로 세로 비율
        ),
      ),
    );
  }

  Widget recommendPostList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('best').snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snap.data!.docs;

          return Container(
            child: GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              itemCount: 4,
              //몇 개 출력할 건지
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  width: width / 2,
                  height: width*(9/20),
                  child: InkWell(
                    onTap: () {
                      String clicked_id = documents[index]['item_id'];
                      DictionaryItemInfo dicItemInfo = DictionaryItemInfo();
                      dicItemInfo.setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);
                      Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);
                    

                      PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, dicItemInfo));
                      Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('dictionaryItem').where('__name__', isEqualTo: documents[index]['item_id']).snapshots(),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return CircularProgressIndicator();
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(documents[0]
                                        ['thumbnail']), // TODO 임시 사진, 썸네일로 바꿔야함
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8, 5, 8, 0), // 게시글 제목 여백
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 3),
                                          child: Text(
                                            "#추천",
                                            style: TextStyle(
                                              color: themeColor.getColor(),
                                            ),
                                            textScaleFactor: 1, 
                                          ),
                                        ), 
                                        Text(documents[0]['title'])
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 10/9
              ),
            ),
          );
        });
  }



  Widget otherPostList(BuildContext context, String tabName) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: tabName).snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snap.data!.docs;

          return Container(
            child: GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              itemCount: documents.length,
              //몇 개 출력할 건지
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  width: width / 2,
                  height: width*(101515),
                  child: InkWell(
                    onTap: () {
                      // @@@@@@@@@@@@@@@@@@
                      String clicked_id = documents[index].id; // 지금 클릭한 dictionaryItem의 item_id
                      DictionaryItemInfo dicItemInfo = DictionaryItemInfo();
                      dicItemInfo.setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);
                      Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(clicked_id, documents[index]['author'], documents[index]['card_num'], documents[index]['date'], documents[index]['hashtag'], documents[index]['scrapnum'], documents[index]['thumbnail'], documents[index]['title']);

                      PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, dicItemInfo));
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
                            child: Image.network(documents[index]
                                ['thumbnail']), // TODO 임시 사진, 썸네일로 바꿔야함
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                            // 게시글 제목 여백
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                  child: Text(
                                    "#$tabName",
                                    style: TextStyle(
                                      color: themeColor.getColor(),
                                    ),
                                    textScaleFactor: 1,
                                  ),
                                ),
                                Text(
                                  documents[index]['title'],
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 10/9 // 가로 세로 비율
              ),
            ),
          );
        });
  }

  Widget post(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').orderBy('date', descending: false).snapshots(),
        builder: (contextR, snap) {
          if (!snap.hasData) {
            return const CircularProgressIndicator();
          }
          final documents = snap.data!.docs;

          int i = (documents.length - index - 1 > 0)?(documents.length - index - 1):(0);
          final it = documents.elementAt(i);
          
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            child: InkWell(
              onTap: () {
                DictionaryItemInfo dicItemInfo = DictionaryItemInfo();
                dicItemInfo.setInfo(it.id, it['author'], it['card_num'], it['date'], it['hashtag'], it['scrapnum'], it['thumbnail'], it['title']);
                Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(it.id, it['author'], it['card_num'], it['date'], it['hashtag'], it['scrapnum'], it['thumbnail'], it['title']);
                    
                PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, dicItemInfo));
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
  Widget pageView(BuildContext context, DictionaryItemInfo? dicItemInfo) {

    return Scaffold(
      appBar: AppBar(
        title: Consumer2<DictionaryItemInfo, Logineduser>(
          builder: (context, dicProvider, userProvider, child) {

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dicProvider.title, style: TextStyle(fontSize: 17)),
                Expanded(child: SizedBox()),
                Text(dicProvider.scrapnum.toString(), style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").where("docID", isEqualTo: dicProvider.doc_id)
                            .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return CircularProgressIndicator();
                    }
                    
                    if (snap.data!.size != 0) {   // user가 해당 게시글을 스크랩한 기록이 없는 경우
                      return IconButton(
                        icon: const Icon(
                          // if (context.watch<DictionaryItemInfo>)
                          Icons.bookmark_outlined,
                          color: Colors.amberAccent,
                          size: 30,   
                        ),
                        onPressed: (){
                          if(clickCheck.isRedundentClick(DateTime.now())) return;
                          FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").where("docID", isEqualTo: dicProvider.doc_id).get().then((value) {
                            value.docs.forEach((element) {
                              FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList")
                                .doc(element.id)
                                .delete();
                            });
                          });
                          dicProvider.subScrapNum(dicProvider.doc_id);
                        }
                      );
                    } else {                          // user가 해당 게시글을 스크랩한 기록이 있는 경우
                      return IconButton(
                        icon: const Icon(
                        // if (context.watch<DictionaryItemInfo>)
                          Icons.bookmark_outline_rounded,
                          color: Colors.amberAccent,
                          size: 30,   
                        ),
                        onPressed: (){
                          if(clickCheck.isRedundentClick(DateTime.now())) return;
                          FirebaseFirestore.instance.collection('userInfo').doc(userProvider.doc_id).collection("ScrapList").add({'docID' : dicProvider.doc_id});
                          
                          dicProvider.addScrapNum(dicProvider.doc_id);
                        });
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dicItemInfo!.doc_id).collection('dictionaryCard').orderBy("card_id", descending: false).snapshots(),
          builder: (context, AsyncSnapshot snap) {
            List cardDocList;
            if (snap.hasError) {
              return Text(snap.error.toString()); 
            }
            
            final documents = snap.data!.docs;

            if (!snap.hasData || snap.data.size == 0) {
              return nonExistentCard();
            }
            else{
              cardDocList = documents.toList();
              if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return PageView.builder(
                controller: PageController(
                  initialPage: 0,
                ),
                itemCount: cardDocList.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(cardDocList[0]['img']),
                            // 카드 맨 첫 번째 사진으로 배경 설정
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.network(
                                cardDocList[index]['img']), // 카드 해당 이미지 출력
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                cardDocList[index]['content'].toString().replaceAll(RegExp(r'\\n'), '\n'),  // 게시글 줄바꿈 구현
                                style: TextStyle(color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
          }),
    );
  }

  Widget nonExistentCard() {
    return PageView.builder(
      controller: PageController(
        initialPage: 0,
      ),
      itemCount: 1,
      itemBuilder: (context, index) {
        return Text("카드 없음");
        // return Stack(
        //   children: [
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage(
            //           'https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/recommend1.png?alt=media&token=8ea9b90f-321f-4a9e-800c-36fc3181073d'),
            //       // 임의 사진
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            //   child: ClipRect(
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
            //       child: Container(
            //         decoration:
            //             BoxDecoration(color: Colors.black.withOpacity(0.5)),
            //       ),
            //     ),
            //   ),
            // ),
            
        //   ],
        // );
      },
    );
  }
}
