import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Data.dart';

class DictionaryItem extends Data<DictionaryItem>{
  DictionaryItem(
      this.item_id, {
        this.title = '제목없음',
        this.hashTag = "",
        this.author = "",
        this.scrapnum = 0,
        this.date = null,
        this.writeController = null
      });

  String title;
  int item_id;
  int scrapnum;
  String hashTag;
  String author;
  DateTime? date;
  TextEditingController? writeController;


  @override
  void add(E) {
    FirebaseFirestore.instance.collection('dictionaryItem').add({
      'author': E.author,
      'date': E.date,
      'hashtag': E.hashTag,
      'post_id': E.post_id,
      'scrapnum': E.scrapnum,
      'title': E.title
    });
    writeController?.text = ''; //TextField 비움
  }
  void delete(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('dictionaryItem').doc(doc.id).delete();
    var card_del_query = FirebaseFirestore.instance.collection('card').where('item_id', isEqualTo: doc['item_id']);
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
        date: date
    );
  }
  Widget buildListItem(DocumentSnapshot<Object?> doc, BuildContext context) {
    var item = DictionaryItem(-1);
    item = item.getDataFromDoc(doc);
    return ListTile(
      onTap: (){
        Navigator.pushNamed(context, '/card');
      },
      title: Text(
        item.title,
      ),
      subtitle: Text(item.date.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => delete(doc),
      ),
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
    // TODO: implement add
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
      ],
    );
  }
}