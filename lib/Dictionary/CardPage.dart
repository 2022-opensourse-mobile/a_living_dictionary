import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DictionaryItem.dart';


int itemNum = 9;
int cardNum = 1;
int itemId = 1;


class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}


class _CardPageState extends State<CardPage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Stream? slides;
  double pageOffset = 0;
  final PageController controller = PageController(
      viewportFraction: 0.8,
      initialPage: 0
  );

  @override
  void initState() {
    _queryDb();
    controller
      ..addListener(() {
        setState(() {
          pageOffset = controller.page!;
        });
      });
    super.initState();
  }

  Stream? _queryDb() {
    slides = FirebaseFirestore.instance
        .collection('card').where("item_id", isEqualTo: itemId).orderBy("card_id", descending: false)
        .snapshots()
        .map((list) => list.docs.map((doc) => doc.data()));

    return slides;
  }


  @override
  Widget build(BuildContext context) {
    final c = MyCard(-1,-1,"-1","-1");
    return Scaffold(
        body: StreamBuilder(
          stream: slides,
          builder: (context, AsyncSnapshot snap){

            if (snap.hasError) {
              return Text(snap.error.toString());
            }

            List slideList;

            if (snap.data.length != 0) {  // card가 한 장 이상 있는 경우 페이지
              slideList = snap.data?.toList();

              if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return PageView.builder(
                controller: controller,
                itemCount: slideList.length,
                itemBuilder: (context, int index) {
                  return c.buildCardPage(slideList[index], index);
                },
              );
            }
            else {    // card가 한 장도 없는 경우 가는 페이지(임의로 아무거나 넣었습니다.)
              slideList = [];

              if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return PageView(
                children: [
                  SizedBox.expand(
                    child: Container(
                        color: Colors.red,
                        child: Center(
                            child:  IconButton(
                                onPressed: (){
                                  c.add(MyCard(cardNum,itemNum, "", ""));
                                },
                                icon: Icon(Icons.mail)
                            )
                        )
                    ),
                  ),
                ],
              );
            }
          },
        )
    );
  }
}