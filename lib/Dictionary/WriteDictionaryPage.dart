import 'package:flutter/cupertino.dart';

class WriteDictionaryPage extends StatefulWidget {
  const WriteDictionaryPage({Key? key}) : super(key: key);

  @override
  State<WriteDictionaryPage> createState() => _WriteDictionaryPageState();
}

class _WriteDictionaryPageState extends State<WriteDictionaryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('백과사전 글 쓰기'),);
  }
}
