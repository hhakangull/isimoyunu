import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  int typedCharLength = 0;
  String lorem =
      "                         Deuis magna id consectetur cupidatat magna dolore laborum officia dolor Magna esse sunt cupidatat elit est voluptate quis ad est magna ex amet nulla ad"
          .toLowerCase();
  int step = 0;
//  int score = 0;
  int lastTypedAt;

  void updateLastTypedAt() {
    this.lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        print(value.length);
        typedCharLength = value.length;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      this.userName = value.substring(0, 3);
      print(this.userName);
    });
  }

  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 0;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      //Game OVER
      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) step++;
        if (step != 1) timer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0)
      shownWidget = [
        Text(
          "Oyuna Hoşgeldin",
          style: TextStyle(fontSize: 36),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextField(
            onChanged: onUserNameType,
            textCapitalization: TextCapitalization.sentences,
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Adınızı Giriniz...",
              labelStyle: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text("Koronadan Kaçmaya Hazır mısın?"),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text(
              "Başla",
              style: TextStyle(fontSize: 24),
            ),
            onPressed: userName.length < 3 ? null : onStartClick,
          ),
        )
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text(
          "Score : $typedCharLength",
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            velocity: 125.0,
            blankSpace: 20.0,
            pauseAfterRound: Duration(seconds: 0),
            startPadding: 0,
            fadingEdgeStartFraction: 0.1,
            accelerationDuration: Duration(seconds: 20),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
                child: TextField(
                  onChanged: onType,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Yaz Bakalım",
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ];
    else
      shownWidget = [
        Text("Game OVER Skor : $typedCharLength"),
        SizedBox(height: 40),
        RaisedButton(
          child: Text("Yeniden Başla !"),
          onPressed: resetGame,
        )
      ];
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
