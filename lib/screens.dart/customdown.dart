import 'package:flutter/material.dart';

import '../menu/model.dart';

class MyDropdownButton extends StatelessWidget {
  final String dropdownValue;
  final List<Menus> menuList;
  final Function(String?)? onChanged;

  MyDropdownButton({
    required this.dropdownValue,
    required this.menuList,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: menuList.map((Menus menu) {
        return DropdownMenuItem<String>(
        
          child: Text(menu.menuName),
        );
      }).toList()
      ..add(DropdownMenuItem<String>(value: 'New List', child: Text('New List'))),
      onChanged: onChanged,
    );
  }
}


