import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_bottom_sheet/custom_bottom_sheet.dart';

class AnimatedListSample extends StatefulWidget {
  @override
  _AnimatedListSampleState createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<int> _list;
  int _selectedItem;
  int _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2, 3, 4, 5, 6, 7],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      key: UniqueKey(),
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onDismiss: () {
        setState(() {
          _list.removeAt(index);
        });
      },
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
          _remove();
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains  visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      key: UniqueKey(),
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    final int index = _selectedItem == null ? _list.length : _list.indexOf(_selectedItem);
    _list.insert(index, _nextItem++);
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            //            physics: ScrollPhysics(parent: PageScrollPhysics()),
            scrollDirection: Axis.horizontal,
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ),
      ),
    );
  }
}

/// Keeps a Dart List in sync with an AnimatedList.
///
/// The [insert] and [removeAt] methods apply to both the internal list and the
/// animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that mutate the
/// list must make the same changes to the animated list in terms of
/// [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value. The text is displayed in bright green if selected is true.
/// This widget's height is based on the animation parameter, it varies
/// from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatefulWidget {
  const CardItem(
      {Key key,
      @required this.animation,
      this.onTap,
      this.onDismiss,
      @required this.item,
      this.selected: false})
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final int item;
  final bool selected;

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  PanelController _controller = PanelController();

  Widget _panel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 5.0,
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
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              width: 150.0,
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
    return Align(
        alignment: Alignment(0.0, 0.6),
        child: RaisedButton(
          child: Text('Click me'),
          onPressed: () {
            _controller.open();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    double _panelHeightOpen = MediaQuery.of(context).size.height / 3 * 2;
    double _panelHeightClosed = 0.0;
    return GestureDetector(
      onVerticalDragStart: (direction) {
        print('<<<SWIPE UP>>>');
        widget.onDismiss();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SlideTransition(
          position: widget.animation
              .drive(Tween(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))),
//          child: SizeTransition(
//            sizeFactor: animation,
//            axis: Axis.horizontal,
          child: SizedBox(
            width: 270.0,
            height: 500.0,
            child: Card(
              color: Colors.primaries[widget.item % Colors.primaries.length],
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(),
                          IconButton(
                            onPressed: widget.onTap,
                            icon: Icon(Icons.clear),
                          )
                        ],
                      ),
                      Text('Item ${widget.item}', style: textStyle),
                      SizedBox(),
                      SlidingUpPanel(
                        minHeight: 0.0,
                        maxHeight: 400.0,
                        parallaxEnabled: true,
                        body: _body(),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0)),
                      ),
                    ],
                  ),
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
                ],
              ),
            ),
          ),
//          ),
        ),
      ),
    );
  }
}
