import 'package:flutter/material.dart';
import 'package:testing_app/counter/counter_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "List in Flutter",
        home: new Scaffold(
            appBar: new AppBar(
              title: Text("List"),
            ),
            body: CounterPage()
//        GridWidget(inputList: <TwoFieldsObject>[
//          TwoFieldsObject('Cool!', 'one'),
//          TwoFieldsObject('Awesome!', 'two'),
//          TwoFieldsObject('Greate!', 'three'),
//          TwoFieldsObject('Greate!', 'four'),
//          TwoFieldsObject('Greate!', 'five'),
//          TwoFieldsObject('Greate!', 'six'),
//          TwoFieldsObject('Greate!', 'seven')]
            ));
  }
}
