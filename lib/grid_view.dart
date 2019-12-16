import 'package:flutter/material.dart';

import 'components/obj_for_list_and_grid_view.dart';

class GridWidget extends StatelessWidget {
  final inputList;

  GridWidget({this.inputList});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 2;
    final height = MediaQuery.of(context).size.height / 2;
    return GridView.builder(
      itemCount: inputList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (width / 2) / (height / 2.5),
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 4.0),
      itemBuilder: (context, i) {
        final index = i;
        return _buildRow(inputList[index]);
      },
    );
  }

  Widget _buildRow(TwoFieldsObject item) {
    return Card(
      color: Colors.orange,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(item.firstField),
          Text(item.secondField),
        ],
      ),
    );
  }
}
