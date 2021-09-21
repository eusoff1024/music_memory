import 'package:flutter/material.dart';
import 'package:music_memory/mode/training.dart';
import 'package:music_memory/mode/senior_thesis.dart';
import 'package:music_memory/mode/assessment.dart';

class MenuPage extends StatefulWidget {
  final String userId;
  MenuPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState(userId);
}

class _MenuPageState extends State<MenuPage> {
  //変数とか関数を定義する
  //入力したユーザーIDから値を取得する
  final String _userId;
  _MenuPageState(this._userId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              child: Text("はじめる"),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => MyHomePage(userId: userId.toString()),
                      // builder: (context) =>
                      //     TrainingPage(userId: userId.toString()),
                      builder: (context) =>
                          SeniorThesisPage(userId: _userId.toString()),
                    ));
              },
            ),
            ElevatedButton(
              child: Text("トレーニング"),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => MyHomePage(userId: userId.toString()),
                      // builder: (context) =>
                      //     TrainingPage(userId: userId.toString()),
                      builder: (context) =>
                          TrainingPage(userId: _userId.toString()),
                    ));
              },
            ),
            ElevatedButton(
              child: Text("評価"),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => MyHomePage(userId: userId.toString()),
                      // builder: (context) =>
                      //     TrainingPage(userId: userId.toString()),
                      builder: (context) =>
                          AssessmentPage(userId: _userId.toString()),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
