import 'package:flutter/material.dart';

class ChipsTile extends StatelessWidget {
  const ChipsTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      child: Wrap(
        children: children.map<Widget>((Widget chip) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: chip,
          );
        }).toList(),
      ),
    );
  }
}
