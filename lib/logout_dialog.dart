import 'package:flutter/material.dart';

class LogoutOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends State<LogoutOverlay> with SingleTickerProviderStateMixin {
//  AnimationController animationController;
  bool _menuShown = false;

  @override
  void initState() {
//    animationController =
//        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    Animation opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
//    if (_menuShown)
//      animationController.forward();
//    else
//      animationController.reverse();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      _menuShown = !_menuShown;
                    });
                  }),
              _menuShown
                  ? Positioned(
//                child: FadeTransition(opacity: opacityAnimation,
                      child: _ShapedWidget(
                        onlyTop: true,
                      ),
//                ),
                      right: 4.0,
                      top: 48.0,
                    )
                  : SizedBox(),
            ],
          )
        ],
      ),
      body: Stack(
        //PopUp itself
        overflow: Overflow.visible,
        children: <Widget>[
          _menuShown
              ? Positioned(
//            child: FadeTransition(opacity: opacityAnimation,
                  child: _ShapedWidget(),
//            ),
                  right: 4.0,
                  top: -4.0,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class _ShapedWidget extends StatelessWidget {
  _ShapedWidget({this.onlyTop = false});
  final double padding = 4.0;
  final bool onlyTop;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          color: Colors.orange,
          clipBehavior: Clip.antiAlias,
          shape: _ShapedWidgetBorder(
              borderRadius: BorderRadius.all(Radius.circular(padding)), padding: padding),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(padding).copyWith(bottom: padding * 2),
            child: onlyTop
                ? SizedBox(
                    width: 100.0,
                    height: 20.0,
                  )
                : SizedBox(
                    width: 100.0,
                    height: 20.0,
                    child: Center(
                      child: Text('Exit'),
                    ),
                  ),
          )),
    );
  }
}

class _ShapedWidgetBorder extends RoundedRectangleBorder {
  _ShapedWidgetBorder({
    @required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
//      ..moveTo(rect.width - 8.0, rect.top)
//      ..lineTo(rect.width - 20.0, rect.top - 16.0)
//      ..lineTo(rect.width - 32.0, rect.top)
      ..addRRect(borderRadius.resolve(textDirection).toRRect(
          Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
  }
}

//  @override
//  Widget build(BuildContext context) {
////    Animation opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
////    if (_menuShown)
////      animationController.forward();
////    else
////      animationController.reverse();
//    return Scaffold(
//      appBar: AppBar(
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.menu),
//              onPressed: () {
//                setState(() {
//                  _menuShown = !_menuShown;
//                });
//              })
//        ],
//      ),
//      body: Stack(
//        overflow: Overflow.visible,
//        children: <Widget>[
//          _menuShown
//              ? Positioned(
////            child: FadeTransition(opacity: opacityAnimation,
//                  child: _ShapedWidget(),
////            ),
//                  right: 4.0,
//                  top: 16.0,
//                )
//              : SizedBox(),
//        ],
//      ),
//    );
//  }
//}
//
//class _ShapedWidget extends StatelessWidget {
//  _ShapedWidget();
//  final double padding = 4.0;
//
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: Material(
//          color: Colors.orange,
//          clipBehavior: Clip.antiAlias,
//          shape: _ShapedWidgetBorder(
//              borderRadius: BorderRadius.all(Radius.circular(padding)), padding: padding),
//          elevation: 4.0,
//          child: Container(
//            padding: EdgeInsets.all(padding).copyWith(bottom: padding * 2),
//            child: SizedBox(
//              width: 150.0,
//              height: 250.0,
//              child: Center(
//                child: Text('ShapedWidget'),
//              ),
//            ),
//          )),
//    );
//  }
//}
//
//class _ShapedWidgetBorder extends RoundedRectangleBorder {
//  _ShapedWidgetBorder({
//    @required this.padding,
//    side = BorderSide.none,
//    borderRadius = BorderRadius.zero,
//  }) : super(side: side, borderRadius: borderRadius);
//  final double padding;
//
//  @override
//  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
//    return Path()
//      ..moveTo(rect.width - 8.0, rect.top)
//      ..lineTo(rect.width - 20.0, rect.top - 16.0)
//      ..lineTo(rect.width - 32.0, rect.top)
//      ..addRRect(borderRadius.resolve(textDirection).toRRect(
//          Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - padding)));
//  }
//}
