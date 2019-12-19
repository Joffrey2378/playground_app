import 'package:flutter/material.dart';

class AnimatedCountValue extends StatefulWidget {
  /// List of [String] that would be displayed subsequently in the animation.
  final int count;

  /// Gives [TextStyle] to the text strings.
  final TextStyle textStyle;

  /// Override the [Duration] of the animation by setting the duration parameter.
  final Duration duration;

  /// Override the transition height by setting the value of parameter transitionHeight.
  ///
  /// By default it is set to [TextStyle.fontSize] * 10 / 3.
  final double transitionHeight;

  /// Adds [AlignmentGeometry] property to the text in the widget.
  ///
  /// By default it is set to [AlignmentDirectional.topStart]
  final AlignmentGeometry alignment;

  /// Adds [TextAlign] property to the text in the widget.
  ///
  /// By default it is set to [TextAlign.start]
  final TextAlign textAlign;

  /// Set if the animation should not repeat by changing the value of it to false.
  ///
  /// By default it is set to true.
  final bool isRepeatingAnimation;

  AnimatedCountValue(
      {@required this.count,
      this.textStyle,
      this.duration,
      this.transitionHeight,
      this.alignment,
      this.textAlign,
      this.isRepeatingAnimation});

  @override
  _AnimatedCountValueState createState() => _AnimatedCountValueState();
}

class _AnimatedCountValueState extends State<AnimatedCountValue>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double _transitionHeight;

  Duration _duration;

  List<Animation<double>> _fadeIn = [];
  List<Animation<double>> _fadeOut = [];
  List<Animation<Alignment>> _slideIn = [];
  List<Animation<Alignment>> _slideOut = [];

  List<Widget> textWidgetList = [];

  @override
  void initState() {
    super.initState();

    if (widget.duration == null) {
      _duration = Duration(milliseconds: 2000);
    } else {
      _duration = widget.duration;
    }

    _controller = new AnimationController(
      duration: _duration,
      vsync: this,
    );

    _controller.forward();

//    int lengthList = widget.count.length;

    if (widget.transitionHeight == null) {
      _transitionHeight = widget.textStyle.fontSize * 10 / 3;
    } else {
      _transitionHeight = widget.transitionHeight;
    }

    double percentTime = 1.0;
    double fadeTime = 1.0;
    double slideTime = 1.0;

    for (int i = 0; i < widget.count; i++) {
      if (i == 0) {
        _slideIn.add(AlignmentTween(
          begin: Alignment(-1.0, -1.0),
          end: new Alignment(-1.0, 0.0),
        ).animate(CurvedAnimation(
            parent: _controller, curve: Interval(0.0, slideTime, curve: Curves.linear))));
        _fadeIn.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _controller, curve: Interval(0.0, fadeTime, curve: Curves.easeOut))));
      } else {
        _slideIn.add(AlignmentTween(
          begin: Alignment(-1.0, -1.0),
          end: new Alignment(-1.0, 0.0),
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval((i * percentTime) - slideTime, (i) * percentTime,
                curve: Curves.linear))));
        _fadeIn.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _controller,
            curve: Interval(
                (i * percentTime) - slideTime, (i * percentTime) - slideTime + fadeTime,
                curve: Curves.easeOut))));
      }

      _slideOut.add(AlignmentTween(
        begin: Alignment(-1.0, 0.0),
        end: new Alignment(-1.0, 1.0),
      ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(((i + 1) * percentTime) - slideTime, (i + 1) * percentTime,
              curve: Curves.linear))));
      _fadeOut.add(Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(((i + 1) * percentTime) - slideTime,
              ((i + 1) * percentTime) - slideTime + fadeTime,
              curve: Curves.easeIn))));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.count; i++) {
      if (i != widget.count - 1) {
        textWidgetList.add(AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return AlignTransition(
              alignment: !(_slideIn[i].value.y == 0.0) ? _slideIn[i] : _slideOut[i],
              child: Opacity(
                opacity:
                    !(_fadeIn[i].value == 1.0) ? _fadeIn[i].value : _fadeOut[i].value,
                child: Text(
                  widget.count.toString(),
                  style: widget.textStyle,
                  textAlign: widget.textAlign,
                ),
              ),
            );
          },
        ));
      } else {
        if (widget.isRepeatingAnimation) {
          textWidgetList.add(AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return AlignTransition(
                alignment: !(_slideIn[i].value.y == 0.0) ? _slideIn[i] : _slideOut[i],
                child: Opacity(
                  opacity:
                      !(_fadeIn[i].value == 1.0) ? _fadeIn[i].value : _fadeOut[i].value,
                  child: Text(
                    widget.count.toString(),
                    style: widget.textStyle,
                    textAlign: widget.textAlign,
                  ),
                ),
              );
            },
          ));
        } else {
          textWidgetList.add(AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return AlignTransition(
                alignment: _slideIn[i],
                child: Opacity(
                  opacity: _fadeIn[i].value,
                  child: Text(
                    widget.count.toString(),
                    style: widget.textStyle,
                    textAlign: widget.textAlign,
                  ),
                ),
              );
            },
          ));
        }
      }
    }
  }
}
