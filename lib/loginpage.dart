import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_memory/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //入力したユーザーid
  String userId = "";
  //firebase firestoreのインスタンス作成
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //FirebaseStorageからusersのドキュメント一覧を取得
  Future<void> listUsers() async {
    //usersのドキュメント一覧を取得
    await firestore.collection('users').get().then((QuerySnapshot ds) {
      print(ds.docs);
    });

    // loadFile();

    // for (int i = 0; i < 5; i++) {
    //   loadFile(i);
    // }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // listUsers();
    // //ログを有効にする？
    // // AudioPlayer.logEnabled = true;
    // playerIsComplation();

    // fetchMusicName();
    // ansindex();
  }

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
