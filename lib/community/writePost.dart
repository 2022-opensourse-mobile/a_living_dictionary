import 'package:flutter/material.dart';

class WritePostPage extends StatelessWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: <Widget>[
                TextField(decoration: InputDecoration(labelText: '제목'),),
                TextField(decoration: InputDecoration(labelText: '내용'),),
                ElevatedButton(
                  child: Text('확인'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        )
    );
  }
}
