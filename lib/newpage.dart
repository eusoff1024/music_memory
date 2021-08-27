import 'package:flutter/material.dart';

//正解のページ
class NextPageCorrect extends StatelessWidget {
  Widget _imageAnsArea(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      child: Image.asset(
        'images/correct.png',
        height: h * 0.8,
        width: w * 0.8,
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
        body: Column(
          children: <Widget>[
            SizedBox(
              height: deviceHeight * 0.7,
              width: deviceWidth,
              child: _imageAnsArea(deviceHeight * 0.7, deviceWidth),
            ),
            Row(
              children: [
                SizedBox(
                  height: deviceHeight * 0.2,
                  width: deviceWidth / 2,
                  child: ElevatedButton(
                    child: Text('もう一度聞く'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.2,
                  width: deviceWidth / 2,
                  child: ElevatedButton(
                    child: Text("次へ"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                )
              ],
            )
          ],
        ));
  }
}

//間違いのページ
class NextPageWrong extends StatelessWidget {
  Widget _imageAnsArea(double h, double w) {
    return Container(
      alignment: Alignment(0, 0),
      child: Image.asset(
        'images/incorrect.png',
        height: h * 0.8,
        width: w * 0.8,
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
        body: Column(
          children: <Widget>[
            SizedBox(
              height: deviceHeight * 0.7,
              width: deviceWidth,
              child: _imageAnsArea(deviceHeight * 0.7, deviceWidth),
            ),
            Row(
              children: [
                SizedBox(
                  height: deviceHeight * 0.2,
                  width: deviceWidth / 2,
                  child: ElevatedButton(
                    child: Text('もう一度聞く'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.2,
                  width: deviceWidth / 2,
                  child: ElevatedButton(
                    child: Text("次へ"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                )
              ],
            )
          ],
        ));
  }
}
