import 'package:flutter/material.dart';

class ListTestsPage extends StatefulWidget {
  @override
  _ListTestsPageState createState() => _ListTestsPageState();
}

class _ListTestsPageState extends State<ListTestsPage> {
  List<String> list;

  @override
  void initState() {
    list = ['1', '2', '3', '4', '5', '6'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListWidget(inputList: list),
    );
  }
}

class ListWidget extends StatefulWidget {
  final inputList;

  ListWidget({this.inputList});

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget.inputList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildRow(widget.inputList[index]),
            );
          }),
    );
  }

  Widget _buildRow(String item) {
    return Dismissible(
      direction: DismissDirection.up,
      key: UniqueKey(),
      onDismissed: (_) {
        widget.inputList.remove(widget.inputList.indexOf(item));
      },
      child: Container(
        width: 70.0,
        height: 150.0,
        child: RefreshIndicator(
          onRefresh: addItemsToList,
          child: ListView.builder(
//              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 150.0,
                    color: Colors.orange,
                    child: Center(
                        child: Text(
                      item,
                      style: TextStyle(fontSize: 40.0),
                    )));
              }),
        ), //
      ),
    );
  }

  Future<void> addItemsToList() async {
    await Future.delayed(Duration(milliseconds: 700));
    setState(() {
      widget.inputList.add('7');
      widget.inputList.add('8');
      widget.inputList.add('9');
      widget.inputList.add('10');
    });
    return null;
  }
}
