import 'dart:async';

import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with SingleTickerProviderStateMixin {
  AnimationController controller;

  int count = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    controller.addListener(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 50.0,
                child: Center(
                  child: FadeTransition(
                    opacity: controller.drive(Tween(begin: 1.0, end: 0.0)),
                    child: SlideTransition(
                      position: controller
                          .drive(Tween(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.1))),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                  ),
                )),
            RaisedButton(
                child: Text('increment'),
                onPressed: () {
                  controller.forward().then((f) {
                    controller.reverse();
                  });
                  Timer(Duration(milliseconds: 300), () {
                    setState(() {
                      count++;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
