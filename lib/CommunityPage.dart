import 'package:flutter/material.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class Post{
  static int n = 0;
  int? number;
  int like = 0;
  String body = '';
  String title = '';
  String writer = '';
  String writer_id = '';
  DateTime? time;
  int boardType = 1;
  String? hashTag;


  Post({this.title = '', this.writer = '', this.body = '', this.like=0, this.hashTag}){
    number = ++n;
    time = DateTime.now();
  }
}


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
  var genaralPostList = <Post>[
    Post(title: 'title1', writer: 'writer1', body: 'body1'),
    Post(title: 'title2', writer: 'writer2', body: 'body2'),
    Post(title: 'title3', writer: 'writer3', body: 'body3'),
    Post(title: 'title4', writer: 'writer1', body: 'body4'),
    Post(title: 'title5', writer: 'writer2', body: 'body5'),
    Post(title: 'title6', writer: 'writer3', body: 'body6'),
  ];
  var hotPostList = <Post>[
    Post(title: 'hot post1', writer: 'writer1', body: 'hot', like: 15),
    Post(title: 'hot post2', writer: 'writer2', body: 'hot2', like: 23),
    Post(title: 'hot post3', writer: 'writer3', body: 'hot3', like: 10),
  ];
  var noticePostList = <Post>[
    Post(title: 'notice1', writer: 'manager', body: 'rule1'),
  ];
  var curPostList = <Post>[];
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  curPostList = genaralPostList;
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
                  curPostList = hotPostList;
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
                  curPostList = noticePostList;
                });
              },
              child: Text('공지글'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(110, 37)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              )),
        ],
      ),
      Expanded(
          child: ListView(
              children: curPostList.map((post) => _buildListItem(post)).toList()
          )
      ),
    ]);
  }

  Widget _buildListItem(Post post) {
    String t = '${post.time!.hour.toString()}:${post.time!.minute.toString()}';
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.body),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1.0, color: Colors.grey)),
        trailing: Text(t),
      ),
    );
  }
}
