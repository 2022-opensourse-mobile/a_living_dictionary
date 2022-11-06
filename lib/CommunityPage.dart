import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ThemeColor.dart';
import 'community/Post.dart';
import 'community/writePost.dart';

ThemeColor themeColor = ThemeColor();

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCommunity();
  }
}

class MyCommunity extends StatefulWidget {
  const MyCommunity({Key? key}) : super(key: key);

  @override
  State<MyCommunity> createState() => _MyComminityState();
}

class _MyComminityState extends State<MyCommunity> {
  Widget _buildListItemDB(DocumentSnapshot doc) {
    Timestamp stamp = doc['time'];
    final post = Post(
        id: doc['id'],
        title: doc['title'],
        writer_name: doc['writer_name'],
        writer_id: doc['writer_id'],
        body: doc['body'],
        like: doc['like'],
        time: stamp.toDate(),
        boardType: doc['boardType'],
        hashTag: doc['hashTag']);
    String t = '${post.time!.hour.toString()}:${post.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Card(
          child: ListTile(
            title: Text(post.id.toString() + " " + post.title),
            subtitle: Text(post.body),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(style: BorderStyle.none)),
            trailing: Text(t),
            style: ListTileStyle.list,
          ),
        )
    );
  }
  void _addPost(Post post){
    Timestamp stamp = Timestamp.fromDate(post.time!);
    FirebaseFirestore.instance.collection('communityDB').add({
      'id':post.id,
      'title':post.title,
      'writer_name':post.writer_name,
      'writer_id':post.writer_id,
      'body':post.body,
      'time': stamp,
      'boardType':post.boardType,
      'hashTag':post.hashTag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  //curPostList = genaralPostList;
                });
              },
              child: Text('전체글'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(110, 37)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              )),
          TextButton(
              onPressed: () {
                setState(() {
                  //curPostList = hotPostList;
                });
              },
              child: Text('인기글'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(110, 37)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              )),
          TextButton(
              onPressed: () {
                setState(() {
                  //curPostList = noticePostList;
                });
              },
              child: Text('공지글'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(110, 37)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              )),
        ],
      ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('communityDB').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;
          return Expanded(
              child: ListView(
                  shrinkWrap: true,
                  children: documents.map((doc)=> _buildListItemDB(doc)).toList()
              )
          );
          }),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WritePostPage()));
            },
            tooltip: 'write',
            child: Icon(Icons.add),
          ),
        ],
      )
    ]);
  }

}
