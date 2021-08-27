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
import 'package:avatar_glow/avatar_glow.dart';

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
  //自分の回答の添字
  int myAns = 0;
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
  //現在playerを再生中かどうか
  List<bool> isPlaying = [false, false, false, false, false];
  //回答を確認するかどうか
  bool confirmAns = false;

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

  //FirebaseStorageから音楽データのURLを取得
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

    setState(() {
      for (var i = 0; i < isPlaying.length; i++) {
        isPlaying[i] = false;
      }
    });

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
        countTapping[0]++;
        timePlayMusic.start();
        setState(() {
          isPlaying[0] = true;
        });
      }
    } else if (currentPlayerNumber == 1) {
      if (player1.state == PlayerState.STOPPED ||
          player1.state == PlayerState.COMPLETED) {
        player1.play(downloadURLs[1]);
        countTapping[1]++;
        timePlayMusic.start();
        setState(() {
          isPlaying[1] = true;
        });
      }
    } else if (currentPlayerNumber == 2) {
      if (player2.state == PlayerState.STOPPED ||
          player2.state == PlayerState.COMPLETED) {
        player2.play(downloadURLs[2]);
        // countTapping++;
        countTapping[2]++;
        timePlayMusic.start();
        setState(() {
          isPlaying[2] = true;
        });
      }
    } else if (currentPlayerNumber == 3) {
      if (player3.state == PlayerState.STOPPED ||
          player3.state == PlayerState.COMPLETED) {
        player3.play(downloadURLs[3]);
        // countTapping++;
        countTapping[3]++;
        timePlayMusic.start();
        setState(() {
          isPlaying[3] = true;
        });
      }
    } else {
      if (player4.state == PlayerState.STOPPED ||
          player4.state == PlayerState.COMPLETED) {
        player4.play(downloadURLs[4]);
        // countTapping++;
        countTapping[4]++;
        timePlayMusic.start();
        setState(() {
          isPlaying[4] = true;
        });
      }
    }

    setState(() {});
  }

  //playerがcompletionだったらストップウォッチを停止させる
  void playerIsComplation() {
    player0.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      setState(() {
        isPlaying[0] = false;
      });
    });
    player1.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      setState(() {
        isPlaying[1] = false;
      });
    });
    player2.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      setState(() {
        isPlaying[2] = false;
      });
    });

    player3.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      setState(() {
        isPlaying[3] = false;
      });
    });
    player4.onPlayerCompletion.listen((event) {
      timePlayMusic.stop();
      setState(() {
        isPlaying[4] = false;
      });
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
    confirmAns = false;
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
  Widget _questionArea(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      // color: Colors.white,
      child: isPlaying[0]
          //音楽再生時(avatar_glow表示)
          ? AvatarGlow(
              endRadius: h / 3,
              glowColor: Colors.blue,
              duration: Duration(milliseconds: 1500),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 0),
              child: ElevatedButton(
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'images/image1.png',
                      height: h / 5,
                    ),
                    radius: h / 5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: const CircleBorder()),
                onPressed: () {
                  stopMusic();
                  playMusic(0);
                },
              ),
            )

          //音楽非再生時(avatar_glow非表示)
          : ElevatedButton(
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'images/image1.png',
                    height: h / 5,
                  ),
                  radius: h / 5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: CircleBorder()),
              onPressed: () {
                stopMusic();
                playMusic(0);
              },
            ),
    );
  }

  // //説明文を表示する
  // Widget _questionTextArea() {
  //   return Container(
  //     alignment: Alignment.center,
  //     color: Colors.amber,
  //     child: Text("同じものはどれ？"),
  //   );
  // }

  //回答の音楽データの選択肢を表示する
  Widget _ansMusicArea(double h, double w) {
    return Container(
        // color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          // SizedBox(
          //   height: h / 5,
          //   width: w,
          //   child: true
          Container(
            height: h / 4,
            width: w,
            // color: Colors.white,
            child: isPlaying[1]
                ? AvatarGlow(
                    endRadius: h / 7,
                    glowColor: Colors.red,
                    duration: Duration(milliseconds: 1500),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 0),
                    child: ElevatedButton(
                      child: Material(
                        // elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/image2.png',
                            height: h / 8,
                          ),
                          radius: h / 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          // onPrimary: Colors.black,
                          shape: CircleBorder()),
                      onPressed: () {
                        stopMusic();
                        playMusic(1);
                      },
                    ),
                  )
                : ElevatedButton(
                    child: Material(
                      // elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'images/image2.png',
                          height: h / 8,
                        ),
                        radius: h / 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      // onPrimary: Colors.black,
                      shape: CircleBorder(),
                    ),
                    onPressed: () {
                      stopMusic();
                      playMusic(1);
                    },
                  ),
          ),
          Container(
            height: h / 4,
            width: w,
            child: isPlaying[2]
                ? AvatarGlow(
                    endRadius: h / 7,
                    glowColor: Colors.yellow,
                    duration: Duration(milliseconds: 1500),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 0),
                    child: ElevatedButton(
                      child: Material(
                        // elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/image3.png',
                            height: h / 8,
                          ),
                          radius: h / 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          // onPrimary: Colors.black,
                          shape: CircleBorder()),
                      onPressed: () {
                        stopMusic();
                        playMusic(2);
                      },
                    ),
                  )
                : ElevatedButton(
                    child: Material(
                      // elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'images/image3.png',
                          height: h / 8,
                        ),
                        radius: h / 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        // onPrimary: Colors.black,
                        shape: CircleBorder()),
                    onPressed: () {
                      stopMusic();
                      playMusic(2);
                    },
                  ),
          ),

          Container(
            height: h / 4,
            width: w,
            child: isPlaying[3]
                ? AvatarGlow(
                    endRadius: h / 7,
                    glowColor: Colors.green,
                    duration: Duration(milliseconds: 1500),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 0),
                    child: ElevatedButton(
                      child: Material(
                        // elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/image4.png',
                            height: h / 8,
                          ),
                          radius: h / 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          // onPrimary: Colors.black,
                          shape: CircleBorder()),
                      onPressed: () {
                        stopMusic();
                        playMusic(3);
                      },
                    ),
                  )
                : ElevatedButton(
                    child: Material(
                      // elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'images/image4.png',
                          height: h / 8,
                        ),
                        radius: h / 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        // onPrimary: Colors.black,
                        shape: const CircleBorder()),
                    onPressed: () {
                      stopMusic();
                      playMusic(3);
                    },
                  ),
          ),
          Container(
            height: h / 4,
            width: w,
            child: isPlaying[4]
                ? AvatarGlow(
                    endRadius: h / 7,
                    glowColor: Colors.cyan,
                    duration: Duration(milliseconds: 1500),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 0),
                    child: ElevatedButton(
                      child: Material(
                        // elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/image5.png',
                            height: h / 8,
                          ),
                          radius: h / 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          // onPrimary: Colors.black,
                          shape: CircleBorder()),
                      onPressed: () {
                        stopMusic();
                        playMusic(4);
                      },
                    ),
                  )
                : ElevatedButton(
                    child: Material(
                      // elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'images/image5.png',
                          height: h / 8,
                        ),
                        radius: h / 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        // onPrimary: Colors.black,
                        shape: const CircleBorder()),
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
      // color: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: confirmAns
            //答え合わせの時に表示
            ? <Widget>[
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: judge(0)
                      ? Icon(
                          Icons.circle_outlined,
                          color: Colors.red,
                          size: h / 6,
                        )
                      : myAns == 0
                          ? Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: h / 6,
                            )
                          : null,
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: judge(1)
                      ? Icon(
                          Icons.circle_outlined,
                          color: Colors.red,
                          size: h / 6,
                        )
                      : myAns == 1
                          ? Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: h / 6,
                            )
                          : null,
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: judge(2)
                      ? Icon(
                          Icons.circle_outlined,
                          color: Colors.red,
                          size: h / 6,
                        )
                      : myAns == 2
                          ? Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: h / 6,
                            )
                          : null,
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: judge(3)
                      ? Icon(
                          Icons.circle_outlined,
                          color: Colors.red,
                          size: h / 6,
                        )
                      : myAns == 3
                          ? Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: h / 6,
                            )
                          : null,
                )
              ]

            //回答時の選択肢として表示
            : <Widget>[
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: ElevatedButton(
                    child: Text("選択する"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        myAns = 0;
                      });
                      stopMusic();
                      timeAns.stop();
                      startAns = false;
                      if (judge(0)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageCorrect(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageWrong(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      }
                    },
                  ),
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: ElevatedButton(
                    child: Text("選択する"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        myAns = 1;
                      });
                      stopMusic();
                      timeAns.stop();
                      startAns = false;
                      if (judge(1)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageCorrect(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageWrong(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      }
                      // again();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: ElevatedButton(
                    child: Text("選択する"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        myAns = 2;
                      });
                      stopMusic();
                      timeAns.stop();
                      startAns = false;
                      if (judge(2)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageCorrect(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageWrong(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      }
                    },
                  ),
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: h / 4,
                  width: w,
                  child: ElevatedButton(
                    child: Text("選択する"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        myAns = 3;
                      });
                      stopMusic();
                      timeAns.stop();
                      startAns = false;
                      if (judge(3)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageCorrect(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextPageWrong(),
                            )).then((value) {
                          setState(() {
                            confirmAns = value;
                          });
                          if (!value) {
                            again();
                          }
                        });
                      }

                      // again();
                    },
                  ),
                ),
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
      //ローディング画面
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              LinearProgressIndicator(),
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
      //問題画面
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar,
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //問題音源を表示するwidget
              SizedBox(
                height: deviceHeight * 0.2,
                width: deviceWidth,
                child: _questionArea((deviceHeight) * 0.3, deviceWidth),
              ),

              //回答部分を表示させるwidget
              Row(
                children: [
                  //音源部分
                  SizedBox(
                      height: deviceHeight * 0.6,
                      width: deviceWidth / 2,
                      // child: _ansArea((deviceHeight - 2 * 8.0) * 0.5, deviceWidth - 2 * 8.0)
                      child:
                          _ansMusicArea(deviceHeight * 0.5, deviceWidth / 2)),

                  //回答選択部分
                  SizedBox(
                      height: deviceHeight * 0.6,
                      width: deviceWidth / 2,
                      child:
                          _ansSelectArea(deviceHeight * 0.5, deviceWidth / 2)),
                  // )
                ],
              ),
            ]),
        floatingActionButton: confirmAns
            ? FloatingActionButton.extended(
                onPressed: () => {
                  again(),
                },
                icon: new Icon(Icons.play_arrow_sharp),
                label: Text("NEXT"),
              )
            : null,
      );
    }
  }
}
