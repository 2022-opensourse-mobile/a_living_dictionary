import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Supplementary//ThemeColor.dart';
import '../DB/CommunityItem.dart';
import 'Supplementary/CommunityWritePage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

class CommunityPage extends StatelessWidget {
  const CommunityPage(this.context2, {Key? key}) : super(key: key);

  final BuildContext context2;

  @override
  Widget build(BuildContext context) {
    return Community(context2);
  }
  Widget build2(BuildContext context) {
    return Community(context2);
  }
}

class Community extends StatefulWidget {
  const Community(this.context, {Key? key}) : super(key: key);
  final BuildContext context;

  @override
  State<Community> createState() => _ComminityState(context);
}
class _ComminityState extends State<Community> with TickerProviderStateMixin{
  _ComminityState(this.context2);
  CommunityItem p = CommunityItem();
  late TabController _tabController;
  final BuildContext context2;

  static const FREEBOARD = 0;
  static const HOTBOARD = 1;
  static const NOTICEBOARD = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                Tab(text: "최신글"),
                Tab(text: "인기글"),
                Tab(text: "공지글"),
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
          border: Border.all(color: Colors.black12, width: 1)),
      child: FloatingActionButton(
        focusColor: Colors.white54,
        backgroundColor: Colors.white,
        elevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        onPressed: () {
          PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(CommunityWritePage(context, null));
          Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
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
        stream: FirebaseFirestore.instance.collection('CommunityDB').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final documents = snapshot.data!.docs;


          if(boardType == FREEBOARD) {
            return ListView(
                shrinkWrap: true,
                children: documents.where((element) => element['boardType']== FREEBOARD || element['boardType'] == HOTBOARD).map((doc) {
                  CommunityItem item = CommunityItem.getDataFromDoc(doc);
                  return item.build(context);
                }).toList());
          }
          else if(boardType == NOTICEBOARD){
            return ListView(
                shrinkWrap: true,
                children: documents.where((element) => element['boardType']==NOTICEBOARD).map((doc){
                  CommunityItem item = CommunityItem.getDataFromDoc(doc);
                  return item.build(context);
                }).toList()
            );
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

