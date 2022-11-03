import 'package:flutter/material.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class Post {
  static int n = 0;
  int id = n;
  int like = 0;
  String body = '';
  String title = '';
  String writer = '';
  String writer_id = '';
  DateTime? time;
  int boardType = 1;
  String? hashTag;

  Post({this.title = '',
      this.writer = '',
      this.body = '',
      this.like = 0,
      this.hashTag}) {

    id = ++n;
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
  var curHotPostList = <Post>[];

  @override
  Widget build(BuildContext context) {
    if (curHotPostList.isEmpty) {
      for (int i = 0; i < 2; i++) {
        curHotPostList.add(hotPostList[0]);
        hotPostList.removeAt(0);
      }
      curPostList = genaralPostList;
    }
    var postList = curHotPostList.map((post) => _buildListItem(post)).toList() +
        curPostList.map((post) => _buildListItem(post)).toList();

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  curPostList = genaralPostList.where((p) => p.id+2 >= Post.n).toList();
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
      Expanded(child: ListView(shrinkWrap: true, children: postList)),
      Container(
        child: Row(
          children: [
            Align(
              child: TextButton(
                  onPressed: () {},
                  child: Text('이전'),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  )
              ),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                        onPressed: () {},
                        child: Text('다음'),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black)
                        )
                    )
                )
            ),
            FloatingActionButton(
              onPressed: () {},
              tooltip: 'write',
              child: Icon(Icons.add),
            ),
          ],
        ),
      )
    ]);
  }

  Widget _buildListItem(Post post) {
    String t = '${post.time!.hour.toString()}:${post.time!.minute.toString()}';
    return Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Card(
          child: ListTile(
            title: Text(post.id.toString() + post.title),
            subtitle: Text(post.body),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(style: BorderStyle.none)),
            trailing: Text(t),
            style: ListTileStyle.list,
          ),
        ));
  }
}
