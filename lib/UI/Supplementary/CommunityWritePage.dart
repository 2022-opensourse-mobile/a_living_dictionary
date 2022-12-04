import 'package:a_living_dictionary/DB/CommunityItem.dart';
import 'package:a_living_dictionary/PROVIDERS/loginedUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ThemeColor.dart';


String basicProfileImage = "https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/%EA%B8%B0%EB%B3%B8%20%ED%94%84%EC%82%AC%20%EC%9E%84%EC%8B%9C.png?alt=media&token=1178da64-9c77-4f8b-bee7-e2782fa41db5";
ThemeColor themeColor = ThemeColor();

class CommunityWritePage extends StatelessWidget {
  final BuildContext context2;
  late CommunityItem? item;
  late CommunityItem communityItem;
  var width;
  late final isNull;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  late final Logineduser user = Provider.of<Logineduser>(context2, listen: false);

  CommunityWritePage(this.context2, this.item, {super.key}){
    communityItem = (item != null)?(item!):(CommunityItem());
    isNull = (item != null)?(false):(true);
    titleController.text = communityItem.title;
    bodyController.text = communityItem.body;
  }



  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: themeColor.getWhiteMaterialColor(),
          scaffoldBackgroundColor: Colors.white,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: themeColor.getMaterialColor(), //커서 색상
              selectionColor: Color(0xffEAEAEA), //드래그 색상
              selectionHandleColor: themeColor.getMaterialColor() //water drop 색상
          ),
        ),
        home: writePost()
    );
  }

  Widget writePost() {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('글 쓰기'), elevation: 0.0, actions: [
            getFinishButton(context)
          ]),
          body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      getHashTag(communityItem: communityItem),
                      const Divider(thickness: 0.5),
                      getTitleWidget(),
                      const Divider(thickness: 0.5),
                      getBodyWidget(),
                      getCautionWidget()
                    ],
                  ),
                ),
              ]),
        );
      }
    );
  }
  Widget getFinishButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: 50,
        height: 10,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: themeColor.getMaterialColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
          ),
          child: const Text('완료', style: TextStyle(color: Colors.white)),
          onPressed: () {
            String titleTemp = titleController.text.replaceAll(' ', '');
            String bodyTemp = bodyController.text.replaceAll(' ', '');
            if(titleTemp.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("제목을 입력해주세요.")));
              return;
            }
            if(bodyTemp.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("내용을 입력해주세요.")));
              return;
            }
            if(communityItem.hashTag == '#공지' && user.admin == false){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("일반 사용자는 공지 탭 게시물을 작성할 수 없습니다!")));
              communityItem.hashTag == '#잡담';
              return;
            }
            final profileIMG = (user.profileImageUrl != '')?(user.profileImageUrl):(basicProfileImage);
            final nickName = (user.nickName != '') ? (user.nickName) : ("익명");

            communityItem.profileImage = profileIMG;
            communityItem.writerNickname = nickName;
            communityItem.body = bodyController.text;
            communityItem.title = titleController.text;

            if(isNull){
              communityItem.writerID = user.uid;
              communityItem.boardType = 0;
              communityItem.time = DateTime.now();
              communityItem.like = 0;
              communityItem.add();
            }else{
              FirebaseFirestore.instance.collection('CommunityDB').doc(item!.doc_id).update({
                'title': communityItem.title,
                'body': communityItem.body,
                'time': communityItem.time,
                'hashTag' : communityItem.hashTag
              });
            }
            Navigator.pop(context2);
          },
        ),
      ),
    );
  }
  Widget getTitleWidget(){
    return TextFormField(
      controller: titleController,
      cursorColor: themeColor.getMaterialColor(),
      decoration: const InputDecoration(
        hintText: '제목',
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
  Widget getBodyWidget(){
    return SizedBox(
      width: width,
      height: 430,
      child: TextFormField(
        cursorColor: themeColor.getMaterialColor(),
        maxLines: 100,
        controller: bodyController,
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
  Widget getCautionWidget(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,10,10,0),
      child: Container(
        child: const Text(
          '자취 백과사전은 깨끗한 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. '
              '위반 시 게시물이 삭제되고 서비스 이용이 제한되오니 반드시 숙지하시길 바랍니다.\n\n'
              '※ 욕설, 비하, 차별, 혐오, 폭력이 관련된 글 금지\n'
              '※ 음란물, 성적 수치심을 유발하는 글 금지\n'
              '※ 공포 사진, 고어 사진, 더러운 사진 등 눈살 찌푸려지는 글 금지\n'
              '※ 영화, 드라마, 도서 등 일부러 내용을 스포일러 하는 글 금지\n'
              '※ 정치, 사회 관련 글 금지\n'
              '※ 홍보, 판매 관련 글 금지\n'
              '※ 불법 촬영물 유통 금지\n',
          style: TextStyle(color: Colors.grey),
          textScaleFactor: 0.9,
        ),
      ));
  }
}

class getHashTag extends StatefulWidget {
  const getHashTag({Key? key, required this.communityItem}) : super(key: key);
  final CommunityItem communityItem;

  @override
  State<getHashTag> createState() => _getHashTagState(communityItem);
}

class _getHashTagState extends State<getHashTag> {
  _getHashTagState(this.communityItem){
    selectTag = (communityItem.hashTag != '')?(communityItem.hashTag):("#잡담");
    communityItem.hashTag = selectTag;
  }

  final CommunityItem communityItem;
  final hashTag = ['#잡담', '#일상', '#꿀팁', '#힐링', '#공지'];
  var selectTag;
  String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0), child:
    DropdownButtonHideUnderline(child: DropdownButton<String>(
      value: selectTag, //기본적으로 선택되어 있는 해시태그
      isExpanded: true,
      items: hashTag.map(buildMenuItem).toList(),
      onChanged: (value) => setState(() {
        selectTag = value!;
        communityItem.hashTag = value;
      }),
    )
    ),);
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(value: item, child:
  Text(item, style: TextStyle(color: themeColor.getColor()), textScaleFactor: 0.9,)
  );

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$text'), //내용
          duration: Duration(seconds: 2), //올라와 있는 시간
        )
    );
  }
}
