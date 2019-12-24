import 'package:flutter/material.dart';

enum SlideDirection {
  UP,
  DOWN,
}

enum PanelState { OPEN, CLOSED }

class SlidingUpPanel extends StatefulWidget {
  final Widget panel;

  final Widget collapsed;

  final Widget body;

  final double minHeight;

  final double maxHeight;

  final Border border;

  final BorderRadiusGeometry borderRadius;

  final List<BoxShadow> boxShadow;

  final Color color;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final bool renderPanelSheet;

  final bool panelSnapping;

  final PanelController controller;

  final bool backdropEnabled;

  final Color backdropColor;

  final double backdropOpacity;

  final bool backdropTapClosesPanel;

  final void Function(double position) onPanelSlide;

  final VoidCallback onPanelOpened;

  final VoidCallback onPanelClosed;

  final bool parallaxEnabled;

  final double parallaxOffset;

  final bool isDraggable;

  final SlideDirection slideDirection;

  final PanelState defaultPanelState;

  SlidingUpPanel(
      {Key key,
      @required this.panel,
      this.body,
      this.collapsed,
      this.minHeight = 100.0,
      this.maxHeight = 500.0,
      this.border,
      this.borderRadius,
      this.boxShadow = const <BoxShadow>[
        BoxShadow(
          blurRadius: 8.0,
          color: Color.fromRGBO(0, 0, 0, 0.25),
        )
      ],
      this.color = Colors.white,
      this.padding,
      this.margin,
      this.renderPanelSheet = true,
      this.panelSnapping = true,
      this.controller,
      this.backdropEnabled = false,
      this.backdropColor = Colors.black,
      this.backdropOpacity = 0.5,
      this.backdropTapClosesPanel = true,
      this.onPanelSlide,
      this.onPanelOpened,
      this.onPanelClosed,
      this.parallaxEnabled = false,
      this.parallaxOffset = 0.1,
      this.isDraggable = true,
      this.slideDirection = SlideDirection.UP,
      this.defaultPanelState = PanelState.CLOSED})
      : assert(0 <= backdropOpacity && backdropOpacity <= 1.0),
        super(key: key);

  @override
  _SlidingUpPanelState createState() => _SlidingUpPanelState();
}

class _SlidingUpPanelState extends State<SlidingUpPanel>
    with SingleTickerProviderStateMixin {
  AnimationController _ac;

  bool _isPanelVisible = true;

  @override
  void initState() {
    super.initState();

    _ac = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: widget.defaultPanelState == PanelState.CLOSED
            ? 0.0
            : 1.0 //set the default panel state (i.e. set initial value of _ac)
        )
      ..addListener(() {
        setState(() {});

        if (widget.onPanelSlide != null) widget.onPanelSlide(_ac.value);

        if (widget.onPanelOpened != null && _ac.value == 1.0) widget.onPanelOpened();

        if (widget.onPanelClosed != null && _ac.value == 0.0) widget.onPanelClosed();
      });

    widget.controller?._addListeners(
      _close,
      _open,
      _hide,
      _show,
      _setPanelPosition,
      _animatePanelToPosition,
      _getPanelPosition,
      _isPanelAnimating,
      _isPanelOpen,
      _isPanelClosed,
      _isPanelShown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.slideDirection == SlideDirection.UP
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      children: <Widget>[
        //make the back widget take up the entire back side
        widget.body != null
            ? Positioned(
                top: widget.parallaxEnabled ? _getParallax() : 0.0,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: widget.body,
                ),
              )
            : Container(),

        //the backdrop to overlay on the body
        !widget.backdropEnabled
            ? Container()
            : GestureDetector(
                onTap: widget.backdropTapClosesPanel ? _close : null,
                child: Opacity(
                  opacity: _ac.value * widget.backdropOpacity,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,

                    //set color to null so that touch events pass through
                    //to the body when the panel is closed, otherwise,
                    //if a color exists, then touch events won't go through
                    color: _ac.value == 0.0 ? null : widget.backdropColor,
                  ),
                ),
              ),

        //the actual sliding part
        !_isPanelVisible
            ? Container()
            : GestureDetector(
                onVerticalDragUpdate: widget.isDraggable ? _onDrag : null,
                onVerticalDragEnd: widget.isDraggable ? _onDragEnd : null,
                child: Container(
                  height: _ac.value * (widget.maxHeight - widget.minHeight) +
                      widget.minHeight,
                  margin: widget.margin,
                  padding: widget.padding,
                  decoration: widget.renderPanelSheet
                      ? BoxDecoration(
                          border: widget.border,
                          borderRadius: widget.borderRadius,
                          boxShadow: widget.boxShadow,
                          color: widget.color,
                        )
                      : null,
                  child: Stack(
                    children: <Widget>[
                      //open panel
                      Positioned(
                          top: widget.slideDirection == SlideDirection.UP ? 0.0 : null,
                          bottom:
                              widget.slideDirection == SlideDirection.DOWN ? 0.0 : null,
                          width: MediaQuery.of(context).size.width -
                              (widget.margin != null ? widget.margin.horizontal : 0) -
                              (widget.padding != null ? widget.padding.horizontal : 0),
                          child: Container(
                            height: widget.maxHeight,
                            child: widget.panel,
                          )),

                      // collapsed panel
                      Positioned(
                        top: widget.slideDirection == SlideDirection.UP ? 0.0 : null,
                        bottom: widget.slideDirection == SlideDirection.DOWN ? 0.0 : null,
                        width: MediaQuery.of(context).size.width -
                            (widget.margin != null ? widget.margin.horizontal : 0) -
                            (widget.padding != null ? widget.padding.horizontal : 0),
                        child: Container(
                          height: widget.minHeight,
                          child: Opacity(
                            opacity: 1.0 - _ac.value,

                            // if the panel is open ignore pointers (touch events) on the collapsed
                            // child so that way touch events go through to whatever is underneath
                            child: IgnorePointer(
                              ignoring: _isPanelOpen(),
                              child: widget.collapsed ?? Container(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  double _getParallax() {
    if (widget.slideDirection == SlideDirection.UP)
      return -_ac.value * (widget.maxHeight - widget.minHeight) * widget.parallaxOffset;
    else
      return _ac.value * (widget.maxHeight - widget.minHeight) * widget.parallaxOffset;
  }

  void _onDrag(DragUpdateDetails details) {
    if (widget.slideDirection == SlideDirection.UP)
      _ac.value -= details.primaryDelta / (widget.maxHeight - widget.minHeight);
    else
      _ac.value += details.primaryDelta / (widget.maxHeight - widget.minHeight);
  }

  void _onDragEnd(DragEndDetails details) {
    double minFlingVelocity = 365.0;

    //let the current animation finish before starting a new one
    if (_ac.isAnimating) return;

    //check if the velocity is sufficient to constitute fling
    if (details.velocity.pixelsPerSecond.dy.abs() >= minFlingVelocity) {
      double visualVelocity =
          -details.velocity.pixelsPerSecond.dy / (widget.maxHeight - widget.minHeight);

      if (widget.slideDirection == SlideDirection.DOWN) visualVelocity = -visualVelocity;

      if (widget.panelSnapping) {
        _ac.fling(velocity: visualVelocity);
      } else {
        // actual scroll physics will be implemented in a future release
        _ac.animateTo(
          _ac.value + visualVelocity * 0.16,
          duration: Duration(milliseconds: 410),
          curve: Curves.decelerate,
        );
      }

      return;
    }

    // check if the controller is already halfway there
    if (widget.panelSnapping) {
      if (_ac.value > 0.5)
        _open();
      else
        _close();
    }
  }

  //---------------------------------
  //PanelController related functions
  //---------------------------------

  //close the panel
  void _close() {
    _ac.fling(velocity: -1.0);
  }

  //open the panel
  void _open() {
    _ac.fling(velocity: 1.0);
  }

  //hide the panel (completely offscreen)
  void _hide() {
    _ac.fling(velocity: -1.0).then((x) {
      setState(() {
        _isPanelVisible = false;
      });
    });
  }

  //show the panel (in collapsed mode)
  void _show() {
    _ac.fling(velocity: -1.0).then((x) {
      setState(() {
        _isPanelVisible = true;
      });
    });
  }

  //set the panel position to value - must
  //be between 0.0 and 1.0
  void _setPanelPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _ac.value = value;
  }

  //set the panel position to value - must
  //be between 0.0 and 1.0
  void _animatePanelToPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _ac.animateTo(value);
  }

  //get the current panel position
  //returns the % offset from collapsed state
  //as a decimal between 0.0 and 1.0
  double _getPanelPosition() {
    return _ac.value;
  }

  //returns whether or not
  //the panel is still animating
  bool _isPanelAnimating() {
    return _ac.isAnimating;
  }

  //returns whether or not the
  //panel is open
  bool _isPanelOpen() {
    return _ac.value == 1.0;
  }

  //returns whether or not the
  //panel is closed
  bool _isPanelClosed() {
    return _ac.value == 0.0;
  }

  //returns whether or not the
  //panel is shown/hidden
  bool _isPanelShown() {
    return _isPanelVisible;
  }
}

class PanelController {
  VoidCallback _closeListener;
  VoidCallback _openListener;
  VoidCallback _hideListener;
  VoidCallback _showListener;
  Function(double value) _setPanelPositionListener;
  Function(double value) _setAnimatePanelToPositionListener;
  double Function() _getPanelPositionListener;
  bool Function() _isPanelAnimatingListener;
  bool Function() _isPanelOpenListener;
  bool Function() _isPanelClosedListener;
  bool Function() _isPanelShownListener;

  void _addListeners(
    VoidCallback closeListener,
    VoidCallback openListener,
    VoidCallback hideListener,
    VoidCallback showListener,
    Function(double value) setPanelPositionListener,
    Function(double value) setAnimatePanelToPositionListener,
    double Function() getPanelPositionListener,
    bool Function() isPanelAnimatingListener,
    bool Function() isPanelOpenListener,
    bool Function() isPanelClosedListener,
    bool Function() isPanelShownListener,
  ) {
    this._closeListener = closeListener;
    this._openListener = openListener;
    this._hideListener = hideListener;
    this._showListener = showListener;
    this._setPanelPositionListener = setPanelPositionListener;
    this._setAnimatePanelToPositionListener = setAnimatePanelToPositionListener;
    this._getPanelPositionListener = getPanelPositionListener;
    this._isPanelAnimatingListener = isPanelAnimatingListener;
    this._isPanelOpenListener = isPanelOpenListener;
    this._isPanelClosedListener = isPanelClosedListener;
    this._isPanelShownListener = isPanelShownListener;
  }

  /// Closes the sliding panel to its collapsed state (i.e. to the  minHeight)
  void close() {
    _closeListener();
  }

  /// Opens the sliding panel fully
  /// (i.e. to the maxHeight)
  void open() {
    _openListener();
  }

  /// Hides the sliding panel (i.e. is invisible)
  void hide() {
    _hideListener();
  }

  /// Shows the sliding panel in its collapsed state
  /// (i.e. "un-hide" the sliding panel)
  void show() {
    _showListener();
  }

  /// Sets the panel position (without animation).
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open.
  void setPanelPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _setPanelPositionListener(value);
  }

  /// Animates the panel position to the value.
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open
  void animatePanelToPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _setAnimatePanelToPositionListener(value);
  }

  /// Gets the current panel position.
  /// Returns the % offset from collapsed state
  /// to the open state
  /// as a decimal between 0.0 and 1.0
  /// where 0.0 is fully collapsed and
  /// 1.0 is full open.
  double getPanelPosition() {
    return _getPanelPositionListener();
  }

  /// Returns whether or not the panel is
  /// currently animating.
  bool isPanelAnimating() {
    return _isPanelAnimatingListener();
  }

  /// Returns whether or not the
  /// panel is open.
  bool isPanelOpen() {
    return _isPanelOpenListener();
  }

  /// Returns whether or not the
  /// panel is closed.
  bool isPanelClosed() {
    return _isPanelClosedListener();
  }

  /// Returns whether or not the
  /// panel is shown/hidden.
  bool isPanelShown() {
    return _isPanelShownListener();
  }
}
