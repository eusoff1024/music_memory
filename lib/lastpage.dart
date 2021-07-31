import 'package:flutter/material.dart';

//終了のページ
class LastPage extends StatelessWidget {
  final int countCorrect;
  final int question;
  LastPage(this.countCorrect, this.question);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("おしまい"),
      ),
      body: Center(
        child: Text("$question問中$countCorrect問正解！"),
      ),
    );
  }
}
