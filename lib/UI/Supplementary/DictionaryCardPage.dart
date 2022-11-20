import 'dart:ui';

import 'package:a_living_dictionary/DB/DictionaryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../DictionaryPage.dart';
import 'PageRouteWithAnimation.dart';

class DictionaryCardPage {
  DictionaryCardPage(this.width, this.height, this.portraitH, this.landscapeH, this.isPortrait);

  var width, height, portraitH, landscapeH;
  var isPortrait;

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
          childAspectRatio: (width / 2) / (isPortrait?(height < 750 ? 250 : portraitH):landscapeH), // 가로 세로 비율
          //childAspectRatio: 15/12, // 가로 세로 비율
        ),
      ),
    );
  }
  Widget recommendPostList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('best').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;

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
                  height: (isPortrait?(height < 750 ? 250:portraitH):landscapeH),
                  child: InkWell(
                    onTap: () {
                      String clicked_id = documents[index]['item_id'];
                      PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, clicked_id));
                      Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('dictionaryItem')
                                .where('__name__', isEqualTo: documents[index]['item_id']).snapshots(),
                            builder: (context, snapshot) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(snapshot.data!.docs[0]
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
                                        Text(snapshot.data!.docs[0]['title'])
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
                childAspectRatio: (width / 2) /
                    (isPortrait
                        ? (height < 750 ? 250 : portraitH)
                        : landscapeH), // 가로 세로 비율
              ),
            ),
          );
        });
  }



  Widget otherPostList(BuildContext context, String tabName) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dictionaryItem')
            .where("hashtag", isEqualTo: tabName)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;

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
                  height: (isPortrait
                      ? (height < 750 ? 250 : portraitH)
                      : landscapeH),
                  child: InkWell(
                    onTap: () {
                      // @@@@@@@@@@@@@@@@@@
                      String clicked_id =
                          documents[index].id; // 지금 클릭한 dictionaryItem의 item_id
                      PageRouteWithAnimation pageRouteWithAnimation =
                          PageRouteWithAnimation(pageView(context, clicked_id));
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
                            child: Image.network(snapshot.data!.docs[index]
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
                                    // snapshot.data!.docs[0]['title']
                                    documents[index]['title'])
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
                childAspectRatio: (width / 2) /
                    (isPortrait
                        ? (height < 750 ? 250 : portraitH)
                        : landscapeH), // 가로 세로 비율
              ),
            ),
          );
        });
  }

  Widget post(BuildContext context, int index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').orderBy('date', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;

          int i = (documents.length - index - 1 > 0)?(documents.length - index - 1):(0);
          final it = documents.elementAt(i);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            width: width / 2,
            height:
                (isPortrait ? (height < 750 ? 250 : portraitH) : landscapeH),
            child: InkWell(
              onTap: () {
                PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, it.id));
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
  Widget pageView(BuildContext context, String dic_id) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Text(snap.data!['title']);
                }),
            Icon(
              Icons.bookmark_outline_rounded,
              color: Colors.amberAccent,
              size: 30,
            ),
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).collection('dictionaryCard').orderBy("card_id", descending: false).snapshots(),
          builder: (context, AsyncSnapshot snap) {
            List cardDocList;
            if (snap.hasError) {
              return Text(snap.error.toString());
            }

            if (!snap.hasData || snap.data.size == 0) {
              return nonExistentCard(dic_id);
            }
            else{
              cardDocList = snap.data?.docs.toList();
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
                          // @@삭제 카드 
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).snapshots(),
                            builder: (context, snap) {
                              return IconButton(onPressed: (){
                                
                                // 카드id를 할당하기 위한 코드들 FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).snapshots(),
                                int card_num = snap.data!['card_num'] - 1;    // dictionaryItem의 card_num값을 1 감소시킨다

                                // dictionaryItem의 card_num값을 갱신
                                FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).update({"card_num": card_num});

                                // 데이터베이스에서 삭제
                                FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).collection('dictionaryCard')
                                .doc(cardDocList[index].id).delete();

                              }, icon: Icon(Icons.delete));
                            }
                          )
                        ],
                      ),
                      // @@삭제 추가하는 코드
                      Row(
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).snapshots(),
                            builder: (context, snap) {
                              return IconButton(
                                onPressed: (){
                                  // 카드id를 할당하기 위한 코드들 
                                  int card_num = snap.data!['card_num'] + 1;    // dictionaryItem의 card_num값을 1 증가시킨다.
                                  var cardCollection = FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).collection('dictionaryCard').get();

                                  // dictionaryItem의 card_num값을 갱신
                                  FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).update({"card_num": card_num});

                                  // 추가할 MyCard객체
                                  var cardtemp = MyCard(dic_id, card_num, "https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/recommend1.png?alt=media&token=8ea9b90f-321f-4a9e-800c-36fc3181073d", "asdf");
                                  
                                  // 데이터베이스에 추가
                                  cardtemp.add(cardtemp);
                                },
                                icon: Icon(Icons.add)
                              );
                            }
                          ),
                          TextButton(
                            onPressed: (){
                              //.add({'author': item.author, 'date': item.date, 'hashtag': item.hashTag, 'item_id': item.item_id, 'scrapnum': item.scrapnum, 'title': item.title, 'thumbnail': item.thumbnail,'recommend': item.recommend});

                              FirebaseFirestore.instance.collection('best')
                                .add({'item_id': dic_id});
                            },
                            child: Text("best로 설정")
                          ),
                          TextButton(
                            onPressed: (){
                              FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).update({"recommend": true});

                            },
                            child: Text("관리자 추천 설정")
                          ),
                          TextButton(
                            onPressed: (){
                              FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).update({"recommend": false});
                            },
                            child: Text("관리자 추천x")
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            }
          }),
    );
  }

  Widget nonExistentCard(String dic_id) {
    return PageView.builder(
      controller: PageController(
        initialPage: 0,
      ),
      itemCount: 1,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/recommend1.png?alt=media&token=8ea9b90f-321f-4a9e-800c-36fc3181073d'),
                  // 임의 사진
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            
          ],
        );
      },
    );
  }
}
