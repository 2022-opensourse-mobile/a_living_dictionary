import 'dart:ui';
import 'package:a_living_dictionary/DB/CommunityItem.dart';
import 'package:a_living_dictionary/PROVIDERS/dictionaryItemInfo.dart';
import 'package:a_living_dictionary/UI/Supplementary/CheckClick.dart';
import 'package:a_living_dictionary/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ThemeColor.dart';
import 'DictionaryCardPage.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
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
                        cursorColor: themeColor.getMaterialColor(), //커서 색상
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        autofocus: true,
                        controller: _filter,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: Icon(Icons.search, color: Colors.black54, size: 20,),
                          suffixIcon: _searchText != ""
                              ? IconButton(
                            icon: Icon(Icons.cancel, color: Colors.black54, size: 20,),
                            onPressed: (){
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                              });
                            },
                          ) : SizedBox(),
                          hintText: curIndex == 2? "글 제목, 내용, 해시태그" : "글 제목, 해시태그",
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(0)),
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
              curIndex == 2? _searchCommunity(context) : _searchDictionary(context),
            ],
          ),
        ),
      ),
    );
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
          if (('#' + documents[i]['hashtag'].toString()).contains(_searchText)  || documents[i]['title'].toString().contains(_searchText))
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
          child: DictionaryCardPage(w, h, portraitH, landscapeH, isPortrait).gridViewList(context, searchResults, "search"),
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
          if (documents[i]['title'].toString().contains(_searchText) || documents[i]['body'].toString().contains(_searchText)
              || documents[i]['hashTag'].toString().contains(_searchText))
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