import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';
import '../DB/CommunityItem.dart';
import 'Supplementary/CommunityWritePage.dart';

ThemeColor themeColor = ThemeColor();

class CommunityPage extends StatelessWidget {
  const CommunityPage(this.context2, {Key? key}) : super(key: key);

  final BuildContext context2;

  @override
  Widget build(BuildContext context) {
    return MyCommunity(context2);
  }
}

class MyCommunity extends StatefulWidget {
  const MyCommunity(this.context, {Key? key}) : super(key: key);
  final BuildContext context;

  @override
  State<MyCommunity> createState() => _MyComminityState(context);
}

class _MyComminityState extends State<MyCommunity> with TickerProviderStateMixin{
  _MyComminityState(this.context2);
  CommunityItem p = CommunityItem();
  late TabController _tabController;
  final BuildContext context2;

  static const FREEBOARD = 0;
  static const HOTBOARD = 1;
  static const NOTICEBOARD = 2;


  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: getWriteButton(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TabBar(
              controller: _tabController,
              labelColor: themeColor.getColor(),
              indicatorColor: themeColor.getColor(),
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: "자유 게시판"),
                Tab(text: "인기 게시판"),
                Tab(text: "공지 게시판"),
              ],
            ),
            // 탭 내용
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  getCommunityList(FREEBOARD),
                  getCommunityList(HOTBOARD),
                  getCommunityList(NOTICEBOARD),
                ],
              ),
            )
          ],
        ));
  }


  Widget getWriteButton(){
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.black12, width: 1
          )
      ),
      child: FloatingActionButton(
        focusColor: Colors.white54,
        backgroundColor: Colors.white,
        elevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommunityWritePage(context, null))
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
  Widget getCommunityList(int boardType) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CommunityDB').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;


          if(boardType == FREEBOARD) {
            return ListView(
                shrinkWrap: true,
                children: documents.map((doc) {
                  CommunityItem item = CommunityItem.getDataFromDoc(doc);
                  return item.build(context);
                }).toList());
          }
          else{
            return ListView(
                shrinkWrap: true,
                children: documents.where((element) => element['boardType']==HOTBOARD).map((doc){
                  CommunityItem item = CommunityItem.getDataFromDoc(doc);
                  return item.build(context);
                }).toList()
            );
          }
        });
  }
}
