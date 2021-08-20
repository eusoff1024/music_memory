import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:math';
import 'newpage.dart';
import 'lastpage.dart';
import 'loginpage.dart';

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
      // home: MyHomePage(),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({Key? key}) : super(key: key);
  final String userId;
  MyHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(userId);
}

//クイズ画面
class _MyHomePageState extends State<MyHomePage> {
  //変数とか関数を定義する
  //入力したユーザーIDから値を取得する
  final String _userId;
  _MyHomePageState(this._userId);
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
  //再生した回数
  // int countTapping = 0;
  var countTapping = [0, 0, 0, 0, 0];
  //回答した日時
  DateTime todayis = DateTime.now();
  //音楽再生時間を取得
  Stopwatch timePlayMusic = Stopwatch();
  //解答時間を取得
  Stopwatch timeAns = Stopwatch();
  //問題を一回以上再生したかどうかのフラグ
  bool startAns = false;
  //ローディング中かどうか
  bool isLoading = true;
  //各playerがsetUrl完了したかどうか
  int doneSeturl = 0;
  //画面の高さを取得
  // double width = MediaQuery.of(context).size.width;

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
    }

    // loadFile();

    for (int i = 0; i < 5; i++) {
      loadFile(i);
    }

    setState(() {});
  }

  //audioplayerの準備
  Future<void> loadFile(int i) async {
    switch (i) {
      case 0:
        await player0.setUrl(downloadURLs[0]);
        doneSeturl++;
        // print("0");
        break;
      case 1:
        await player1.setUrl(downloadURLs[1]);
        doneSeturl++;
        // print("1");
        break;
      case 2:
        await player2.setUrl(downloadURLs[2]);
        doneSeturl++;
        // print("2");
        break;
      case 3:
        await player3.setUrl(downloadURLs[3]);
        doneSeturl++;
        // print("3");
        break;
      case 4:
        await player4.setUrl(downloadURLs[4]);
        doneSeturl++;
        // print("4");
        break;
    }
    // Future.wait(futures)

    if (doneSeturl == 5) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //答えの添字をランダムで取得(downloadURLsから)
  void ansindex() {
    var r = new Random();
    ans = r.nextInt(4);
    setState(() {});
  }

  //audioplayerを停止
  void stopMusic() {
    player0.stop();
    player1.stop();
    player2.stop();
    player3.stop();
    player4.stop();

    if (timePlayMusic.isRunning) {
      timePlayMusic.stop();
      print(timePlayMusic.elapsed.inSeconds);
    }
    if (!startAns) {
      setState(() {
        startAns = true;
        timeAns.start();
      });
    }
  }

  //再生中のaudioplayerと同じものをクリックすると停止のまま．そうでなければ再生する
  void playMusic(int currentPlayerNumber) {
    if (currentPlayerNumber == 0) {
      if (player0.state == PlayerState.STOPPED ||
          player0.state == PlayerState.COMPLETED) {
        player0.play(downloadURLs[0]);
        // countTapping++;
        countTapping[0]++;
        timePlayMusic.start();
      }
    } else if (currentPlayerNumber == 1) {
      if (player1.state == PlayerState.STOPPED ||
          player1.state == PlayerState.COMPLETED) {
        player1.play(downloadURLs[1]);
        // countTapping++;
        countTapping[1]++;
        timePlayMusic.start();
      }
    } else if (currentPlayerNumber == 2) {
      if (player2.state == PlayerState.STOPPED ||
          player2.state == PlayerState.COMPLETED) {
        player2.play(downloadURLs[2]);
        // countTapping++;
        countTapping[2]++;
        timePlayMusic.start();
      }
    } else if (currentPlayerNumber == 3) {
      if (player3.state == PlayerState.STOPPED ||
          player3.state == PlayerState.COMPLETED) {
        player3.play(downloadURLs[3]);
        // countTapping++;
        countTapping[3]++;
        timePlayMusic.start();
      }
    } else {
      if (player4.state == PlayerState.STOPPED ||
          player4.state == PlayerState.COMPLETED) {
        player4.play(downloadURLs[4]);
        // countTapping++;
        countTapping[4]++;
        timePlayMusic.start();
      }
    }

    setState(() {});
  }

  //playerがcompletionだったらストップウォッチを停止させる
  void playerIsComplation() {
    print(timePlayMusic.elapsed.inSeconds);
    player0.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      // print(timePlayMusic.elapsed.inSeconds);
    });
    print(timePlayMusic.elapsed.inSeconds);
    player2.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      // print(timePlayMusic.elapsed.inSeconds);
    });
    print(timePlayMusic.elapsed.inSeconds);
    player3.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      // print(timePlayMusic.elapsed.inSeconds);
    });
    print(timePlayMusic.elapsed.inSeconds);
    player4.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      // print(timePlayMusic.elapsed.inSeconds);
    });
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

  //リビルドするかどうか
  void again() {
    question++;
    if (question > 4) {
      uploadlogdata();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LastPage(countCorrect, question - 1),
          ));
    } else {
      rebuild();
    }
  }

  //画面更新時に各要素を更新
  void rebuild() {
    downloadURLs = ['null', 'null', 'null', 'null', 'null'];
    listMusicName.clear();
    isLoading = true;
    doneSeturl = 0;
    fetchMusicName();
    ansindex();
    setState(() {});
  }

  //回答をfirestore databaseに保存
  Future<void> uploadlogdata() async {
    CollectionReference usersCollectionReference =
        firestore.collection('users');

    final doc = await usersCollectionReference.doc(_userId).get();

    //新規ユーザ
    if (!doc.exists) {
      //何回目か
      int numberExperiments = 1;
      await usersCollectionReference.doc(_userId).set({
        'day': numberExperiments,
        'result$numberExperiments': {
          'name': _userId,
          'sumAns': question - 1,
          'sumCorrectAns': countCorrect,
          'countTapping': countTapping,
          'ansDay': todayis,
          'timePlayMusic': timePlayMusic.elapsed.inSeconds,
          'timeAns': timeAns.elapsed.inSeconds
        }
      });

      //既存のユーザ
    } else {
      int numberExperiments = 1;
      //現在の実験回数を取得
      await usersCollectionReference
          .doc(_userId)
          .get()
          .then((DocumentSnapshot ds) {
        numberExperiments = ds.get('day');
      });
      numberExperiments += 1;
      await usersCollectionReference.doc(_userId).update({
        'day': numberExperiments,
        'result$numberExperiments': {
          'name': _userId,
          'sumAns': question - 1,
          'sumCorrectAns': countCorrect,
          'countTapping': countTapping,
          'ansDay': todayis,
          'timePlayMusic': timePlayMusic.elapsed.inSeconds,
          'timeAns': timeAns.elapsed.inSeconds
        }
      });
    }

    print("DONE");
  }

  //問題データを表示するwidget
  Widget _questionArea(double h) {
    return Container(
      // margin: EdgeInsets.all(8.0),
      alignment: Alignment(0, 0),
      height: h,

      child: new SizedBox(
        height: h * 0.5,
        width: h * 0.5,
        child: ElevatedButton(
          child: Icon(Icons.play_arrow),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            stopMusic();
            playMusic(0);
          },
        ),
      ),
    );
  }

  //説明文を表示する
  Widget _questionTextArea() {
    return Container(
      // margin: EdgeInsets.all(8.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("同じものはどれ？"),
        ],
      ),
    );
  }

  //回答の音楽データの選択肢を表示する
  Widget _ansMusicArea(double h, double w) {
    return Container(
        color: Colors.green,
        // margin: EdgeInsets.all(8.0),
        // alignment: Alignment(0, 0),
        height: h,
        width: w,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // children: [
              SizedBox(
                height: h / 4,
                width: w / 4,
                child: ElevatedButton(
                  child: Text("A"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    stopMusic();
                    playMusic(1);
                  },
                ),
              ),
              SizedBox(
                height: h / 4,
                width: w / 4,
                child: ElevatedButton(
                  child: Text("B"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    stopMusic();
                    playMusic(2);
                  },
                ),
              ),
              SizedBox(
                height: h / 4,
                width: w / 4,
                child: ElevatedButton(
                  child: Text("C"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    stopMusic();
                    playMusic(3);
                  },
                ),
              ),
              SizedBox(
                height: h / 4,
                width: h / 4,
                child: ElevatedButton(
                  child: Text("D"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    stopMusic();
                    playMusic(4);
                  },
                ),
              ),
              // ]
              // ),
            ]));
  }

  //回答の選択ボタンを表示する
  Widget _ansSelectArea(double h, double w) {
    return Container(
      height: h,
      width: w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
              stopMusic();
              timeAns.stop();
              startAns = false;
              if (judge(0)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageCorrect(),
                    )).then((value) => again());
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageWrong(),
                    )).then((value) => again());
              }
              // again();
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
              stopMusic();
              timeAns.stop();
              startAns = false;
              if (judge(1)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageCorrect(),
                    )).then((value) => again());
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageWrong(),
                    )).then((value) => again());
              }
              // again();
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
              stopMusic();
              timeAns.stop();
              startAns = false;
              if (judge(2)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageCorrect(),
                    )).then((value) => again());
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageWrong(),
                    )).then((value) => again());
              }
              // again();
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
              stopMusic();
              timeAns.stop();
              startAns = false;
              if (judge(3)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageCorrect(),
                    )).then((value) => again());
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextPageWrong(),
                    )).then((value) => again());
              }

              // again();
            },
          ),
        ],
      ),
    );
  }

  //回答部分を表示する
  Widget _ansArea(double h, double w) {
    return Container(
      // margin: EdgeInsets.all(8.0),
      height: h,
      width: w,
      color: Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _ansMusicArea(h, w / 2),
          _ansSelectArea(h, w / 2),
        ],
      ),
    );
  }

//画面が作られた時に1度だけ呼ばれる．
  @override
  void initState() {
    super.initState();
    //ログを有効にする？
    // AudioPlayer.logEnabled = true;
    playerIsComplation();

    fetchMusicName();
    ansindex();
  }

  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - kToolbarHeight;
    final double deviceWidth = MediaQuery.of(context).size.width;
    AppBar appBar = AppBar(
        centerTitle: true,
        title: Text("第$question問"),
        automaticallyImplyLeading: false);
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              LinearProgressIndicator(),
              // Text("Hello"),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    // width: 250.0,
                    height: 30.0,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          FadeAnimatedText("Loading..."),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        // appBar: AppBar(
        //     centerTitle: true,
        //     title: Text("第$question問"),
        //     automaticallyImplyLeading: false),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: <Widget>[
              _questionArea((deviceHeight - 2 * 8.0) * 0.3),
              _questionTextArea(),
              _ansArea((deviceHeight - 2 * 8.0) * 0.5, deviceWidth - 2 * 8.0),
            ]),
          ),
        ),
      );
    }
  }
}
