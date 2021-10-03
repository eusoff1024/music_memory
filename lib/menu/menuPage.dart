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

  Widget _iconArea(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      child: Image.asset(
        'assets/menu.png',
        height: h,
        width: w,
      ),
    );
  }

// 卒論用ボタン
  Widget _seniorThesisButton(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          child: Text("はじめる"),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(w, h),
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
      ),
    );
  }

// トレーニング用ボタン
  Widget _trainingButton(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          child: Text("トレーニング"),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(w, h),
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
      ),
    );
  }

// 評価用ボタン
  Widget _assessmentButton(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          child: Text("テスト"),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(w, h),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - kToolbarHeight;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // icon画像
            SizedBox(
              height: deviceHeight * 0.4,
              width: deviceWidth,
              child: _iconArea(deviceHeight * 0.2, deviceWidth),
            ),
            ////////////////////////////////
            // 卒論用
            ////////////////////////////////
            SizedBox(
              height: deviceHeight * 0.1,
              width: deviceWidth,
              child: _seniorThesisButton(deviceHeight * 0.1, deviceWidth * 0.7),
            ),
            ////////////////////////////////
            // トレーニング用
            ////////////////////////////////
            // SizedBox(
            //     height: deviceHeight * 0.1,
            //     width: deviceWidth,
            //     child: _trainingButton(deviceHeight, deviceWidth * 0.7)),
            // SizedBox(
            //     height: deviceHeight * 0.1,
            //     width: deviceWidth,
            //     child: _assessmentButton(deviceHeight, deviceWidth * 0.7)),
          ],
        ),
      ),
    );
  }
}
