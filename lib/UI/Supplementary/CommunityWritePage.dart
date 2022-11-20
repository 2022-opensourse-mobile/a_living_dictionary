import 'package:flutter/material.dart';

class CommunityWritePage extends StatelessWidget {
  const CommunityWritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Row(
              children: <Widget>[
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
