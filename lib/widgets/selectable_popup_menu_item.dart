import 'package:flutter/material.dart';

class SelectablePopupMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget? icon;
  final Widget label;
  final bool isSelected;

  const SelectablePopupMenuItem({
    super.key,
    required this.value,
    this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem<T>(
      value: value,
      padding: EdgeInsets.zero,
      child: Expanded(child:  Container(
        alignment: Alignment.centerLeft,
        color: isSelected 
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        child: Row(children: [icon ?? const SizedBox(width: 24.0), label]),
      ),
    ));
  }
}
