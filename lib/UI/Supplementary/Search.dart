import 'dart:ui';
import 'package:a_living_dictionary/DB/CommunityItem.dart';

import 'DictionaryCardPage.dart' as dicCard;
import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:a_living_dictionary/UI/Supplementary/CheckClick.dart';
import 'package:a_living_dictionary/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ThemeColor.dart';

import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

ThemeColor themeColor = ThemeColor();
final CheckClick clickCheck = CheckClick();

class SearchScreen extends StatefulWidget {
  final int curIndex;
  SearchScreen(this.curIndex);

  @override
  State<SearchScreen> createState() => _SearchScreenState(curIndex);
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  int curIndex;

  _SearchScreenState(this.curIndex) {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: curIndex == 2
            ? Text("커뮤니티 검색", style: TextStyle(color: themeColor.getColor()))
              : Text("백과사전 검색", style: TextStyle(color: themeColor.getColor())),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: themeColor.getColor(),
              padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      autofocus: true,
                      controller: _filter,
                      textInputAction: TextInputAction.search,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.search, color: Colors.white60, size: 20,),
                        suffixIcon: _searchText != ""
                          ? IconButton(
                              icon: Icon(Icons.cancel,size: 20,),
                              onPressed: (){
                                setState(() {
                                  _filter.clear();
                                  _searchText = "";
                                });
                              },
                            ) : SizedBox(),
                        hintText: curIndex == 2? "글 제목, 내용" : "글 제목, 해시태그",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text('취소'),
                      onPressed: (){
                        setState(() {
                          _filter.clear();
                          _searchText = "";
                          focusNode.unfocus();
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (curIndex == 2) // 커뮤니티 검색
      return _searchCommunity(context);
    else // 백과사전 검색
      return _searchDictionary(context);
  }

  // 백과사전 검색
  Widget _searchDictionary(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double portraitH = h / 3.5; // 세로모드 높이
    double landscapeH = h / 1.2; // 가로모드 높이
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('dictionaryItem').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final documents = snapshot.data!.docs;

        List<DocumentSnapshot> searchResults = [];

        for (int i=0; i<documents.length; i++) {
          // 단어가 해시태그 또는 제목에 포함되면 검색 가능
          if (documents[i]['hashtag'].toString().contains(_searchText)  || documents[i]['title'].toString().contains(_searchText))
            searchResults.add(documents[i]);
        }

        if (searchResults.length == 0) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 60, color: Colors.grey,),
                  Text("검색 결과가 없습니다", textScaleFactor: 1.2, style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 10/9,
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0),
                width: w / 2,
                height: w * (101515),
                child: InkWell(
                  onTap: () {
                    String clicked_id = searchResults[index].id;
                    DictionaryItemInfo dicItemInfo = DictionaryItemInfo();
                    dicItemInfo.setInfo(clicked_id, searchResults[index]['author'], searchResults[index]['card_num'], searchResults[index]['date'],
                        searchResults[index]['hashtag'], searchResults[index]['scrapnum'], searchResults[index]['thumbnail'], searchResults[index]['title']);
                    Provider.of<DictionaryItemInfo>(context, listen: false).setInfo(clicked_id, searchResults[index]['author'], searchResults[index]['card_num'], searchResults[index]['date'],
                        searchResults[index]['hashtag'], searchResults[index]['scrapnum'], searchResults[index]['thumbnail'], searchResults[index]['title']);

                    PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(
                        dicCard.DictionaryCardPage(w, h, portraitH, landscapeH, isPortrait).pageView(context, dicItemInfo));
                    Navigator.push(context, pageRouteWithAnimation.slideLeftToRight());
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(searchResults[index]['thumbnail']),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                child: Text(
                                  "#${searchResults[index]['hashtag']}",
                                  style: TextStyle(
                                    color: themeColor.getColor(),
                                  ),
                                  textScaleFactor: 1,
                                ),
                              ),
                              Text(
                                searchResults[index]['title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 커뮤니티 검색
  Widget _searchCommunity(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('CommunityDB').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final documents = snapshot.data!.docs;

        List<DocumentSnapshot> searchResults = [];

        for (int i=0; i<documents.length; i++) {
          // 단어가 제목 또는 본문에 포함되면 검색 가능
          if (documents[i]['title'].toString().contains(_searchText) || documents[i]['body'].toString().contains(_searchText))
            searchResults.add(documents[i]);
        }

        if (searchResults.length == 0) {
          return Expanded(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 60, color: Colors.grey,),
                    Text("검색 결과가 없습니다", textScaleFactor: 1.2, style: TextStyle(color: Colors.grey),),
                  ],
                ),
            ),
          );
        }
        return Expanded(
            child: ListView(
              children: searchResults.map((doc) {
                CommunityItem item = CommunityItem.getDataFromDoc(doc);
                return item.build(context);
              }).toList(),
            )
        );
      },
    );
  }
}