import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation colorAnimation;
  Animation sizeAnimation;
  Animation<double> slideAnimation;

  int count = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // Defining both color and size animations
    colorAnimation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(controller);
    sizeAnimation = Tween<double>(begin: 50.0, end: 90.0).animate(controller);
    slideAnimation = kAlwaysCompleteAnimation;

    // Rebuilding the screen when animation goes ahead
    controller.addListener(() {
      setState(() {});
    });

    // Repeat the animation after finish
//    controller.repeat();

    //For single time
    //controller.forward()

    //Reverses the animation instead of starting it again and repeats
//    controller.repeat(reverse: true);
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
                  child: RotationTransition(
                    alignment: Alignment.center,
                    turns: controller,
//                    position: slideAnimation
//                        .drive(Tween(begin: Offset(0.0, -5.0), end: Offset(0.0, 0.0))),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 50.0,
//                        color: colorAnimation.value,
                      ),
                    ),
                  ),
                )),
            RaisedButton(
                child: Text('increment'),
                onPressed: () {
                  setState(() {
                    controller.forward().then((_) => count++);
                  });
                })
          ],
        ),
      ),
    );
  }
}
