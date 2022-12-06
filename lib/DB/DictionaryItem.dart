import 'package:cloud_firestore/cloud_firestore.dart';
import 'Data.dart';


class DictionaryItem extends Data<DictionaryItem>{
  String title;
  int item_id;
  int scrapnum;
  String hashTag;
  String author;
  DateTime? date;
  String thumbnail;

  DictionaryItem(
      this.item_id, {
        this.title = '제목없음',
        this.hashTag = "",
        this.author = "",
        this.scrapnum = 0,
        this.date = null,
        this.thumbnail = "",
      });

  @override
  void add(E) {
    FirebaseFirestore.instance.collection('dictionaryItem').add({
      'author': E.author,
      'date': E.date,
      'hashtag': E.hashTag,
      'scrapnum': E.scrapnum,
      'title': E.title,
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