import 'package:flutter/material.dart';

class AppBarAction extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final bool isSelected;

  const AppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? IconButton.filledTonal(
            icon: icon,
            isSelected: isSelected,
            onPressed: onPressed,
          )
        : IconButton(icon: icon, isSelected: isSelected, onPressed: onPressed);
  }
}
