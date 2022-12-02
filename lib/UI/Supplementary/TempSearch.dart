import 'package:a_living_dictionary/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class Search2 extends StatefulWidget {
  const Search2({Key? key}) : super(key: key);
  @override
  _Search2State createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  String searchType = '전체';
  Icon customIcon = const Icon(Icons.cancel_outlined);
  TextEditingController _searchController = TextEditingController();
  List<String> recentList = []; // 로컬에 저장

  // @override
  // void initState() {
  //   super.initState();
  //   _searchController = new TextEditingController(text: 'Initial value');
  // }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: TextField(
            autofocus: true,
            controller: _searchController,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
            },
            icon: const Icon(Icons.cancel_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
              String query = _searchController.text;

              PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(SearchResult(searchType, query));
              Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());


            }
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              height: 80.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  searchTypeButton('전체'),
                  searchTypeButton('청소'),
                  searchTypeButton('빨래'),
                  searchTypeButton('요리'),
                  searchTypeButton('기타'),
                  searchTypeButton('커뮤니티'),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Row(children: [
      //       TextButton(onPressed: (){}, child: Text('청소')),
      //       TextButton(onPressed: (){}, child: Text('빨래')),
      //       TextButton(onPressed: (){}, child: Text('요리')),
      //       TextButton(onPressed: (){}, child: Text('기타')),
      //       TextButton(onPressed: (){}, child: Text('커뮤니티')),
      //     ]),
      //     const Center(
      //       child: Text('게시판 검색'),
      //     ),
      //   ],
      // ),
    );
  }

  TextButton searchTypeButton(String type) {
    searchType = type;

    return TextButton(
      onPressed: () {},
      child: Text(
        '#' + type,
        style: TextStyle(
          color: Colors.black,
        ),
      )
    );
  }
}


class SearchResult extends StatefulWidget {
  SearchResult(this.searchType, this.query, {super.key});
  String searchType;
  String query;

  @override
  State<SearchResult> createState() => _SearchResultState(searchType, query);
}

class _SearchResultState extends State<SearchResult> {

  _SearchResultState(this.searchType, this.query);
  String searchType;
  String query = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: TextField(
            decoration: InputDecoration(
              hintText: query,
              hintStyle: const TextStyle(
                color: Color.fromARGB(144, 0, 0, 0),
                fontSize: 18,
                
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
              Navigator.pop(context);
            }
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dictionaryItem').where("hashtag", isEqualTo: searchType).where("title", isGreaterThanOrEqualTo: query).snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }


          var documents = snapshot.data!.docs;

          return Center(
            child: ListView(
              children: <Widget>[
                ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        documents[index]['title'],
                      ),
                      leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
                      onTap: () {
    
                      },
                    );
                  },
                )
              ],
            ),
          );
        }
      ),
      
    );
  
  

  }

  
}