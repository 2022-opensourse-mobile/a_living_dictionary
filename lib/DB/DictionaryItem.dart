import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'Data.dart';


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

  @override
  DictionaryItem getDataFromDoc(DocumentSnapshot<Object?> doc) {
    DateTime date = Timestamp.now().toDate();
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
  MyCard(this.doc_id, this.card_id, this.img, this.content);
  String doc_id;    // card가 포함된 dictionaryItem document의 id
  int card_id;
  String img;
  String content;


  @override
  MyCard getDataFromDoc(DocumentSnapshot<Object?> doc) {
    return MyCard('', doc['card_id'], doc['img'], doc['content']);
  }

  @override
  void add(E) {
    FirebaseFirestore.instance.collection('dictionaryItem').doc(E.doc_id).collection('dictionaryCard')
          .add({'card_id': E.card_id, 'content': E.content, 'img': E.img}
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