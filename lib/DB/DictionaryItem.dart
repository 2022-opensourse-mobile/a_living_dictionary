import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'Data.dart';

int cardNum = 1;
int itemId = 6;


class DictionaryItem extends Data<DictionaryItem>{
  DictionaryItem(
      this.item_id, {
        this.title = '제목없음',
        this.hashTag = "",
        this.author = "",
        this.scrapnum = 0,
        this.date = null,
        this.thumbnail = "",
        this.recommend = false      // 탭 상단 추천으로 뜰지말지
      });

  String title;
  int item_id;
  int scrapnum;
  String hashTag;
  String author;
  DateTime? date;
  String thumbnail;
  bool recommend;


  @override
  void add(E) {
    FirebaseFirestore.instance.collection('dictionaryItem').add({
      'author': E.author,
      'date': E.date,
      'hashtag': E.hashTag,
      'post_id': E.post_id,
      'scrapnum': E.scrapnum,
      'title': E.title,
      'recommend': E.recommend,
      'thumbnail': E.thumbnail
    });
  }

  void delete(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('dictionaryItem').doc(doc.id).delete();
    var card_del_query = FirebaseFirestore.instance.collection('dictionaryCard').where('item_id', isEqualTo: doc['item_id']);
    card_del_query.get().then((querySnapshot){
      querySnapshot.docs.forEach((snp) {
        snp.reference.delete();
      });
    });
  }


  @override
  DictionaryItem getDataFromDoc(DocumentSnapshot<Object?> doc) {
    Timestamp stamp = Timestamp.now();
    DateTime date = stamp.toDate();
    return DictionaryItem(
        doc['post_id'],
        title: doc['title'],
        hashTag: doc['hashtag'],
        author: doc['author'],
        scrapnum: doc['scrapnum'],
        date: date,
        recommend: doc['recommend'],
        thumbnail: doc['thumbnail']
    );
  }
}

class MyCard extends Data<MyCard>{
  MyCard(this.card_id, this.item_id, this.img, this.content);
  int card_id;
  int item_id;
  String img;
  String content;



  @override
  MyCard getDataFromDoc(DocumentSnapshot<Object?> doc) {
    return MyCard(doc['card_id'], doc['item_id'], doc['img'], doc['content']);
  }
  @override
  void add(E) {
    FirebaseFirestore.instance.collection('dictionaryCard').add(
        {'card_id': E.card_id, 'content': E.content, 'img': E.img, 'item_id': E.post_id}
    );
  }

  Widget buildCardPage(Map data, int index){
    return Column(
      children: [
        Expanded(
          child: Container(
            height: 200,
            margin: EdgeInsets.only(top: 10, bottom: 30, right: 10, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(data['img']),
                )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              data['content'],
              style: TextStyle(fontSize:15)
          ),
        ),
        SizedBox(
          height: 20,
        ),
        //카드추가용코드
        IconButton(
            onPressed: (){
              //add(MyCard(cardNum++, itemId, "",""));
            },
            icon: Icon(Icons.add)
        )
      ],
    );
  }
}



// class FireConnect {
//   FirebaseStorage storage = FirebaseStorage.instance;
//   FirebaseFirestore db = FirebaseFirestore.instance;

//   dynamic getCollection(String collectionName) {
//     return db.collection(collectionName);
//   }

//   void addItem(String collectionName, dynamic item) {
//     if (collectionName == 'dictionaryItem') {

//       db.collection('dictionaryItem')
//           .add({'author': item.author, 'date': item.date, 'hashtag': item.hashTag, 'item_id': item.post_id, 'scrapnum': item.scrapnum, 'title': item.title});


//       // TODO@@ info에 item_num을 갱신하는 코드작성(읽어와서 값을 +1 시키는거)
//       // db.collection('info')

//     }
//     if (collectionName == 'card') {


//     }
//   }

//   void deleteItem (String collectionName, String docId) {
//     db.collection(collectionName).doc(docId).delete();
//   }

//   // 변수 타입을 몰라서 일단 dynamic , 나중에 고치기
//   dynamic getDBSnapShot(String collectionName) {
//     print("@@F@@: "+ db.collection(collectionName).snapshots().runtimeType.toString());

//     return db.collection(collectionName).snapshots();
//   }
// }