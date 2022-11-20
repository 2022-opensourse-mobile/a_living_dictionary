import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:a_living_dictionary/main.dart';
import 'ThemeColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Dictionary/DictionaryItem.dart';

/* 백과사전: 청소, 빨래, 요리, 기타 */

ThemeColor themeColor = ThemeColor();

// 기존 txtValue의 2번째 내용 수정
// List<String> txtValue = [
//   'box1',
//   '2줄로됐을때 2줄로됐을때 2줄로됐을때 2줄로됐을때',
//   'box3',
//   'box4',
//   'box4',
//   'bossssssssssssssssssssssssssssssssssss4'
// ];

// List<String> imgValue = [
//   'assets/1.png', 'assets/2.png', 'assets/3.png', 'assets/4.png', 'assets/5.png', 'assets/6.png'
// ];

// List<String> secondimgValue = [
//   'assets/7.png', 'assets/8.png', 'assets/7.png', 'assets/8.png', 'assets/7.png', 'assets/8.png'
// ];

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

int itemnum = 1;

class _DictionaryPageState extends State<DictionaryPage> with TickerProviderStateMixin {
  late TabController _tabController;
  var width, height, portraitH, landscapeH;
  var isPortrait;

  
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
              recommandPage(context),
              otherPage(context, "청소"),
              otherPage(context, "빨래"),
              otherPage(context, "요리"),
              otherPage(context, "기타"),
            ],
          ),
        )
      ],
    );
  }


//화이팅
  // 추천 탭 화면
  Widget recommandPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Row 나중에 삭제 검색어: @@삭제
          Row(
            children: [
              makeButton("청소"),
              makeButton("빨래"),
              makeButton("요리"),
              makeButton("기타"),
            ],
          ),
          startxtIcon(context, '인기 TOP 4'),
          postList(context, "추천", 4),
          Divider(thickness: 0.5,),
          slideList(context,"청소", "오늘은 대청소하는 날!", false),
          slideList(context,"빨래", "빨래의 모든 것", false),
          slideList(context,"요리", "뭐 먹을지 고민된다면?", false),
        ],
      ),
    );
  }

// 나중에 삭제 검색어: @@삭제
  TextButton makeButton(String fieldName) {
    return TextButton(
      onPressed: (){     
        DictionaryItem item = DictionaryItem(
          itemnum++, 
          title: '게시글' + itemnum.toString(), 
          hashTag: fieldName, 
          date: Timestamp.now().toDate(),
          recommend: false,
          thumbnail: "https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/3.png?alt=media&token=d0fdb9da-b484-48e8-924b-5727e9c749f2"
        );
        FirebaseFirestore.instance.collection('dictionaryItem').add({'author': item.author, 'date': item.date, 'hashtag': item.hashTag, 'item_id': item.item_id, 'scrapnum': item.scrapnum, 'title': item.title, 'thumbnail': item.thumbnail,'recommend': item.recommend});
        },
      style: TextButton.styleFrom(
        foregroundColor: Colors.pink,
      ),
      child: Text(fieldName),
      
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

  // 나머지 탭 화면
  Widget otherPage(BuildContext context, String tabName) {  // tabName: 청소, 빨래, 요리, 기타
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            slideList(context, tabName, '관리자가 엄선한 $tabName TIP', true),
            textBox(context, '최신글'),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child:postList(context, tabName, 10),),
            Divider(thickness: 0.5,),
          ],
        )
    );
  }

  // 게시글 리스트
  Widget postList(BuildContext context, String tabName, int postNum){      // tabName: 청소, 빨래, 요리, 기타

     Stream? postDoc = FirebaseFirestore.instance.collection('dictionaryItem').snapshots()
      .map((list) => list.docs.map((doc) => doc.data()));


    if (tabName == '추천') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('best').snapshots(), 
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;

          return Container(
          child: GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(5,0,5,5),
            itemCount: documents.length, //몇 개 출력할 건지
            itemBuilder: (context, index){

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                width: width / 2,
                height: (isPortrait? (height < 750? 250 : portraitH) : landscapeH),

                child: InkWell(
                  onTap: () {
                    // recommend 삭제하는 거 (원본은 남아있음)
                    // print("@@F@@: " + documents[index].id.toString());
                    //  FirebaseFirestore.instance.collection('best').doc(documents[index].id).delete();
                    
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => tempPage(context)));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => pageView(context)));
                   
                    String clicked_id = documents[index]['item_id'];
                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, clicked_id));
                    Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    // child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       child: Image.asset('assets/4.png'), // TODO 임시 사진, 썸네일로 바꿔야함
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.fromLTRB(8,5,8,0), // 게시글 제목 여백
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Padding(padding: EdgeInsets.fromLTRB(0, 0, 0 , 3),
                    //             child: Text(
                    //               "#$tabName",
                    //               style: TextStyle(
                    //                 color: themeColor.getColor(),
                    //               ),
                    //               textScaleFactor: 1,
                    //             ),
                    //           ),
                    //           StreamBuilder<QuerySnapshot>(
                    //             stream: FirebaseFirestore.instance.collection('dictionaryItem')
                    //                 .where('item_id', isEqualTo: documents[index]['item_id']).snapshots(),
                                    
                    //             builder: (context, snapshot) {
                    //               return Text(
                    //                 snapshot.data!.docs[0]['title']
                    //               );
                    //             }
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('dictionaryItem')
                          .where('__name__', isEqualTo: documents[index]['item_id'])    
                          .snapshots(),
                      builder: (context, snapshot) {

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(snapshot.data!.docs[0]['thumbnail']), // TODO 임시 사진, 썸네일로 바꿔야함
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
                                      "#$tabName",
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
        }
      );
    } else {    // 해시태그가 tabName인 Dictionaryitem db불러와서 화면 띄워주기 
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: tabName).snapshots(), 
       
        builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;

          return Container(
          child: GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(5,0,5,5),
            itemCount: documents.length, //몇 개 출력할 건지
            itemBuilder: (context, index){

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                width: width / 2,
                height: (isPortrait? (height < 750? 250 : portraitH) : landscapeH),

                child: InkWell(
                  onTap: () { // @@@@@@@@@@@@@@@@@@
                    // 삭제하는 코드임 나중에 삭제
                    // print("@@F@@: " + documents[index].id.toString());
                    // FirebaseFirestore.instance.collection('dictionaryItem').doc(documents[index].id).delete();


                    // Navigator.push(context, MaterialPageRoute(builder: (context) => tempPage(context)));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => pageView(context)));
                    
                    
                    String clicked_id = documents[index].id;  // 지금 클릭한 dictionaryItem의 item_id

                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, clicked_id));
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
                          child: Image.network(snapshot.data!.docs[index]['thumbnail']), // TODO 임시 사진, 썸네일로 바꿔야함
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
                             
                              Text(
                                // snapshot.data!.docs[0]['title']
                                documents[index]['title']
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
              childAspectRatio: (width / 2) / (isPortrait? (height < 750? 250 : portraitH) : landscapeH), // 가로 세로 비율
            ),
          ),
          );
        }
      );
    }

    
  }

  // 개별 게시글
  Widget post(BuildContext context, int index, String tabName, List<String> imgList, List<String> textList) {
// children: List.generate(i, (index) => post(context, index, "TIP", secondimgValue, txtValue)),

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      width: width / 2,
      height: (isPortrait? (height < 750? 250 : portraitH) : landscapeH),

      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => tempPage(context)));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => pageView(context)));

          // pageView(BuildContext context, String dic_id, String title)

          // PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context));
          // Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TODO
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
                child: Image.asset(imgList[index % imgList.length]),
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
                    Text(textList[index % textList.length], textScaleFactor: 1)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 클릭 시, 스크롤 페이지로 이동
  Widget tempPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("제목", textScaleFactor: 1),
            Icon(Icons.bookmark, color: Colors.amberAccent, size: 30,),
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ListTile $index", textScaleFactor: 1),
                  Image.network('https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/recommend1.png?alt=media&token=8ea9b90f-321f-4a9e-800c-36fc3181073d'),  // 임의 사진
                ],
              )
          );
        },
      ),
    );
  }

  // 클릭 시, 슬라이드 페이지(카드 페이지)로 이동
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
                  return new CircularProgressIndicator();
                }
                return Text(snap.data!['title'] );          
              }
            ),

            Icon(Icons.bookmark_outline_rounded, color: Colors.amberAccent, size: 30,),
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).collection('dictionaryCard').orderBy("card_id", descending: false).snapshots(),
        builder: (context, AsyncSnapshot snap) {// TODO 고치기

          if (snap.hasError) {
            return Text(snap.error.toString());
          }

          List cardDocList;

          // dictionary item에 카드가 1장이라도 있을 때
          if (snap.hasData && snap.data.size != 0) {      
         
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
                          image: NetworkImage(cardDocList[0]['img']),  // 카드 맨 첫 번째 사진으로 배경 설정
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.network(cardDocList[index]['img']),  // 카드 해당 이미지 출력
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            
                            child: Text(
                              (cardDocList[index]['content']).toString().replaceAll(RegExp(r'\\n'), '\n'),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ), 
                    Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).collection('dictionaryCard')
                              .add({'card_id': cardnum++, 'content': "asdf", 'img': "https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/6.png?alt=media&token=e193e837-f3d5-4023-b540-4bb6052ca337"});
                          }, 
                          icon: Icon(Icons.add)
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

          } else {    // 카드가 하나도 없을 때 화면
            
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
                          image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/recommend1.png?alt=media&token=8ea9b90f-321f-4a9e-800c-36fc3181073d'),  // 임의 사진
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      FirebaseFirestore.instance.collection('dictionaryItem').doc(dic_id).collection('dictionaryCard')
                        .add({'card_id': cardnum++, 'content': "asdf", 'img': "https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/6.png?alt=media&token=e193e837-f3d5-4023-b540-4bb6052ca337"});

                    }, icon: Icon(Icons.add))
                  ],
                );
              },
            );
          }
        }
      ),
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


// slideList(context,"청소", "오늘은 대청소하는 날!", 4, false),
//           slideList(context,"빨래", "빨래의 모든 것", 4, false),
//           slideList(context,"요리", "뭐 먹을지 고민된다면?", 4, false),


  // 가로 스크롤 리스트
  Widget slide(BuildContext context, String tabName){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(5,0,5,5), //5055
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: tabName)
                  .where('recommend', isEqualTo: true)
                  .snapshots(),
        builder: (context, snap) {

          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return Row(


            //   Widget post(BuildContext context, int index, String tabName, List<String> imgList, List<String> textList) {
            children: List.generate(snap.data!.size, (index){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                width: width / 2,
                height: (isPortrait? (height < 750? 250 : portraitH) : landscapeH),
      
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => tempPage(context)));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => pageView(context)));
      
                    // pageView(BuildContext context, String dic_id, String title)
      
                    // PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context));
                    // Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@TODO

                    String clicked_id = snap.data!.docs[index].id;  // 지금 클릭한 dictionaryItem의 item_id

                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(pageView(context, clicked_id));
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
                          child: Image.network(snap.data!.docs[index]['thumbnail']),      // 확인필요TODO
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
                              Text(snap.data!.docs[index]['title'], textScaleFactor: 1)
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


int cardnum = 1;