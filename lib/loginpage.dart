import 'package:flutter/material.dart';
import 'package:music_memory/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("ログイン"),
        // ),
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //ユーザーの入力フォーム
        Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
            child: TextFormField(
              decoration: InputDecoration(labelText: "ユーザー名"),
              onChanged: (String value) {
                userId = value;
              },
            )),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
          child: Text("ログイン"),
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
                  builder: (context) => MyHomePage(userId: userId.toString()),
                ));
          },
        ),
      ],
    )));
  }
}
