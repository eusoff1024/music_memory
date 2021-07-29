import 'package:flutter/material.dart';

//正解のページ
class NextPageCorrect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("正解!"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Icon(Icons.check_rounded),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

//間違いのページ
class NextPageWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("不正解!"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Icon(Icons.clear_rounded),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

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
