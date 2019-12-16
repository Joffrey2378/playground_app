import 'package:flutter/material.dart';

import 'components/obj_for_list_and_grid_view.dart';

class CompetenciesListWidget extends StatelessWidget {
  final inputList;

  CompetenciesListWidget({this.inputList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: inputList.length + 1,
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
      itemBuilder: (context, i) {
        final index = i;
        if (index >= inputList.length) return Divider();
        return _buildRow(inputList[index]);
      },
    );
  }

  Widget _buildRow(TwoFieldsObject item) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(item.firstField),
        Text(item.secondField),
      ],
    );
  }
}
