import 'package:flutter/material.dart';
import 'ThemeColor.dart';

import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

// 복붙한거니까 수정필요


class Search extends SearchDelegate {
  String selectedResult = "";
  final List<String> listExample;
  Search(this.listExample);
  List<String> recentList = ["Text 4", "Text 3"];     // 로컬에 저장?


  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];

    query.isEmpty
        ? suggestionList = recentList //In the true case

        : suggestionList.addAll(listExample.where(
            // In the false case

            (element) => element.contains(query),
          ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            selectedResult = suggestionList[index];

            showResults(context);
          },
        );
      },
    );
  }
}
