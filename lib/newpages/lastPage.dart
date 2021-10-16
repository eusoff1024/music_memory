import 'package:flutter/material.dart';
import 'package:music_memory/login/loginPage.dart';
import 'package:url_launcher/url_launcher.dart';

//終了のページ
class LastPage extends StatelessWidget {
  final int countCorrect;
  final int question;
  LastPage(this.countCorrect, this.question);

  Future _launchUrl() async {
    var url =
        "https://docs.google.com/forms/d/e/1FAIpQLSd85Bl-QO5SV8_d5LRLO3KKWjb0P2TM2Uaj3SFdiJCPl__Uhg/viewform?usp=sf_link";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to launch url $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("おしまい"),
        //   automaticallyImplyLeading: false,
        // ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$question問中$countCorrect問正解です！"),
            Text("実験協力ありがとうございました！"),
            Text("以下のボタンからアンケートの回答をお願いします！")
          ],
        )

            // Text("$question問中$countCorrect問正解！"),

            ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {_launchUrl()},
          icon: new Icon(Icons.play_arrow_sharp),
          label: Text("アンケートに回答する"),
        )
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           // builder: (context) => LastPage(countCorrect, question - 1),
        //           builder: (context) => LoginPage(),
        //         ))
        //   },
        //   icon: new Icon(Icons.play_arrow_sharp),
        //   label: Text("戻る"),
        // )
        );
  }
}
// import 'package:flutter/material.dart';

// //終了のページ
// class LastPage extends StatelessWidget {
//   final int countCorrect;
//   final int question;
//   // final String userId;
//   // _LastPageState(this.userId);
//   // LastPage(this.countCorrect, this.question, this.userId);
//   LastPage(this.countCorrect, this.question);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("おしまい"),
//       //   automaticallyImplyLeading: false,
//       // ),
//       body: Center(
//         // child: Text("$question問中$countCorrect問正解！"),
//         child: Text("終了！"),
//       ),
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: () => {
//       //     Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //           // builder: (context) => LastPage(countCorrect, question - 1),
//       //           builder: (context) => MenuPage(userId),
//       //         ))
//       //   },
//       //   icon: new Icon(Icons.play_arrow_sharp),
//       //   label: Text("NEXT"),
//       // )
//     );
//   }
// }
