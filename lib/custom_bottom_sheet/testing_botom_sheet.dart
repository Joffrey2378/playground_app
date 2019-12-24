import 'package:flutter/material.dart';

import 'custom_bottom_sheet.dart';

class TestingBottomSheet extends StatefulWidget {
  @override
  _TestingBottomSheetState createState() => _TestingBottomSheetState();
}

class _TestingBottomSheetState extends State<TestingBottomSheet> {
  PanelController _controller = PanelController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _panelHeightOpen = MediaQuery.of(context).size.height / 3 * 2;
    double _panelHeightClosed = 0.0;
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            controller: _controller,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: false,
            backdropEnabled: true,
            body: _body(),
            panel: _panel(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {}),
          ),

          //the SlidingUpPanel Titel
        ],
      ),
    );
  }

  Widget _panel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                _controller.close();
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text(
              'Add an answer',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              width: 40.0,
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            decoration: InputDecoration(hintText: 'Type...', border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return Center(
        child: RaisedButton(
      child: Text('Click me'),
      onPressed: () {
        _controller.open();
      },
    ));
  }
}
