import 'package:flutter/material.dart';

import 'chip_tile.dart';

class ChipDemo extends StatefulWidget {
  @override
  _ChipDemoState createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  List<String> _inputMembers = <String>['poker', 'tortilla', 'fish', 'micro', 'wood', 'meat', 'mafia', 'play', 'mice', 'fire', 'home', 'mamoth', 'floccinaucinihilipilification'];

  String _selectedMaterial = '';
  bool _showShapeBorder = false;

  void _reset() {
    _selectedMaterial = '';
  }

  void _removeMaterial(String name) {
    _inputMembers.remove(name);
    if (_selectedMaterial == name) {
      _selectedMaterial = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = _inputMembers.map<Widget>((String name) {
      return Chip(
        key: ValueKey<String>(name),
        backgroundColor: Colors.grey,
        label: Text(name),
        onDeleted: () {
          setState(() {
            _removeMaterial(name);
          });
        },
      );
    }).toList();

    final ThemeData theme = Theme.of(context);
    final List<Widget> tiles = <Widget>[
      const SizedBox(height: 8.0, width: 0.0),
      ChipsTile(children: chips),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chips'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _showShapeBorder = !_showShapeBorder;
              });
            },
            icon: const Icon(Icons.vignette, semanticLabel: 'Update border shape'),
          ),
        ],
      ),
      body: ChipTheme(
        data: _showShapeBorder
            ? theme.chipTheme.copyWith(
                shape: BeveledRectangleBorder(
                side: const BorderSide(width: 0.66, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ))
            : theme.chipTheme,
        child: Scrollbar(child: ListView(children: tiles)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(_reset),
        child: const Icon(Icons.refresh, semanticLabel: 'Reset chips'),
      ),
    );
  }
}
