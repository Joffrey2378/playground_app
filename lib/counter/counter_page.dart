import 'dart:math';

import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with TickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _offsetSlide;

  AnimationController _fadeController;
  Animation _animationFade;

  int count = 0;

  @override
  void initState() {
    super.initState();
    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _offsetSlide = Tween(begin: Offset.zero, end: Offset(0.0, -0.5))
        .animate(CurvedAnimation(parent: _slideController, curve: SineCurve()));

    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animationFade = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCirc));

    _slideController.addListener(() {});
    _fadeController.addListener(() {});
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
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
                    opacity: _animationFade,
                    child: SlideTransition(
                      position: _offsetSlide,
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
                  _fadeController.forward().then((f) {
                    setState(() {
                      count++;
                    });
                    _fadeController.reverse();
                  });
                  _slideController.forward().then((f) {
                    _slideController.reset();
                  });
                })
          ],
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  final double count;

  SineCurve({this.count = 1});

  @override
  double transformInternal(double t) {
    return sin((pi * t) * 2);
  }
}
