import 'package:flutter/material.dart';

class SelectablePopupMenuItem<T> extends PopupMenuItem<T> {
  SelectablePopupMenuItem({
    super.key,
    required T super.value,
    Widget? icon,
    required Widget label,
    bool isSelected = false,
  }) : super(
         padding: EdgeInsets.zero,
         child: Builder(
           builder: (context) => Container(
             alignment: Alignment.centerLeft,
             height: kMinInteractiveDimension,
             color: isSelected
                 ? Theme.of(context).colorScheme.secondaryContainer
                 : null,
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: Row(
               spacing: 8.0,
               children: <Widget>[icon ?? SizedBox(width: 24.0), label],
             ),
           ),
         ),
       );
}
