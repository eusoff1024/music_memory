import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';
import 'newpage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//クイズ画面
class _MyHomePageState extends State<MyHomePage> {
  //変数とか関数を定義する
  //URLを保存するリスト
  var downloadURLs = ['null', 'null', 'null', 'null', 'null'];
  //正解の添字
  int ans = 0;
  //ドキュメント情報を入れるリスト
  var listMusicName = [];
  //何問目か
  int question = 1;
  //現在のレベル
  int level = 1;
  // 正答数
  int countCorrect = 0;
  //firebase firestoreのインスタンス作成
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //audioplayer初期化
  AudioPlayer player0 = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player1 = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player2 = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player3 = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer player4 = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  //リビルドするかどうか
  void again() {
    question++;
    if (question > 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LastPage(countCorrect, question - 1),
          ));
    } else {
      rebuild();
    }
  }

  //ドキュメント一覧を取得
  Future<void> fetchMusicName() async {
    CollectionReference collectionReference = firestore.collection('mm_test');
    await collectionReference
        .doc('WtehTwdnUPRrWqKLvXkm')
        .get()
        .then((DocumentSnapshot ds) {
      listMusicName = ds.get('test$question');
      print(listMusicName);
    });

    listExample();
    setState(() {});
  }

  //FirebaseStorageからURLを取得
  Future<void> listExample() async {
    //問題の音源のURL取得
    String fileName = listMusicName[ans].toString().trim();
    await firebase_storage.FirebaseStorage.instance
        .ref('level1/$fileName.mp3')
        .getDownloadURL()
        .then((value) async => downloadURLs[0] = value);

    //問題の選択肢の音源のURL取得
    for (int j = 1; j < 5; j++) {
      String fileName = listMusicName[j - 1].toString().trim();
      await firebase_storage.FirebaseStorage.instance
          .ref('level$level/$fileName.mp3')
          .getDownloadURL()
          .then((value) async => downloadURLs[j] = value);

      // String fileName = listMusicName[j - 1].toString().trim();
      // await firebase_storage.FirebaseStorage.instance
      //     .ref('level$level/$fileName.mp3')
      //     .getDownloadURL()
      //     .then((value) async => downloadURLs[j - 1] = value);
    }

    loadFile();
    setState(() {});
  }

  //audioplayerの準備
  Future<void> loadFile() async {
    await player0.setUrl(downloadURLs[0]);
    await player1.setUrl(downloadURLs[1]);
    await player2.setUrl(downloadURLs[2]);
    await player3.setUrl(downloadURLs[3]);
    await player4.setUrl(downloadURLs[4]);

    setState(() {});
  }

  //画面更新時に各要素を更新
  void rebuild() {
    downloadURLs = ['null', 'null', 'null', 'null', 'null'];
    listMusicName = [];
    fetchMusicName();
    ansindex();
  }

  //解答と正解の添字を比較
  bool judge(int myans) {
    print("答え：$myans 正解：$ans");
    if (myans == ans) {
      print("◯");
      level++;
      level = min(4, level);
      countCorrect++;
      print(countCorrect);
      setState(() {});
      return true;
    } else {
      print("x");
      level--;
      level = max(1, level);
      setState(() {});
      return false;
    }
  }

  //答えの添字をランダムで取得(downloadURLsから))
  void ansindex() {
    var r = new Random();
    ans = r.nextInt(4);
    setState(() {});
  }

//画面が作られた時に1度だけ呼ばれる．
  @override
  void initState() {
    super.initState();
    fetchMusicName();
    ansindex();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Music Memory"),
        ],
      )),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("第$question問"),
              ElevatedButton(
                child: Icon(Icons.play_arrow),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  player0.stop();
                  player1.stop();
                  player2.stop();
                  player3.stop();
                  player4.stop();
                  // _playQestion();
                  player0.play(downloadURLs[0]);
                },
              ),
              Text(""),
              Text("同じメロディはどれ？"),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  child: Text("A"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    player1.play(downloadURLs[1]);
                  },
                ),
                ElevatedButton(
                  child: Text("B"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    player2.play(downloadURLs[2]);
                  },
                ),
                ElevatedButton(
                  child: Text("C"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    player3.play(downloadURLs[3]);
                  },
                ),
                ElevatedButton(
                  child: Text("D"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    player4.play(downloadURLs[4]);
                  },
                ),
              ]),
              Text(""),
              Text("答え"),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  child: Text("A"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    if (judge(0)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageCorrect(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageWrong(),
                          ));
                    }
                    again();
                  },
                ),
                ElevatedButton(
                  child: Text("B"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.lightGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    if (judge(1)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageCorrect(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageWrong(),
                          ));
                    }
                    again();
                  },
                ),
                ElevatedButton(
                  child: Text("C"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    if (judge(2)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageCorrect(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageWrong(),
                          ));
                    }
                    again();
                  },
                ),
                ElevatedButton(
                  child: Text("D"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    player0.stop();
                    player1.stop();
                    player2.stop();
                    player3.stop();
                    player4.stop();
                    if (judge(3)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageCorrect(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPageWrong(),
                          ));
                    }

                    again();
                  },
                ),
              ]),
            ]),
      ),
    );

    // body: Center(
    //   child: Text(
    //     nameString,
    //   ),
    // ));
  }
}
