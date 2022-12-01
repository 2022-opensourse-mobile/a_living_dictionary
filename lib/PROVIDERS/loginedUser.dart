
import 'package:flutter/material.dart';


class Logineduser  with ChangeNotifier {
  String doc_id = '';
  String uid = '';
  String nickName ='';
  String email ='';
  String profileImageUrl = '';

  void setInfo(uid, nickName, email, profileImageUrl) {
    this.uid = uid;
    this.nickName = nickName;
    this.email = email;
    this.profileImageUrl = profileImageUrl;

    notifyListeners();
  }

  void setNickName(nickName) {
    this.nickName = nickName;

    notifyListeners();
  }

  void setProfileImageUrl(profileImageUrl) {
    this.profileImageUrl = profileImageUrl;

    notifyListeners();
  }

  void setDocID(doc_id) {
    this.doc_id = doc_id;
  }
}

    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       content: Stack(
    //         // overflow: Overflow.visible,
    //         children: <Widget>[
    //           Positioned(
    //             right: -40.0,
    //             top: -40.0,
    //             child: InkResponse(
    //               onTap: () {
    //                 Navigator.of(context).pop();
                    
    //               },
    //               child: CircleAvatar(
    //                 child: Icon(Icons.close),
    //                 backgroundColor: Colors.red,
    //               ),
    //             ),
    //           ),
    //           Form(
    //             key: _formKey,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[
    //                 Text("사용할 닉네임 입력"),
    //                 Padding(
    //                   padding: EdgeInsets.all(8.0),
    //                   child: TextFormField(),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: ElevatedButton(
    //                     child: Text("확인"),
    //                     onPressed: () {
    //                       if (_formKey.currentState!.validate()) {
    //                         _formKey.currentState!.save();
    //                       }
    //                     },
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // );