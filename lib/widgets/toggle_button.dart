import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final Widget? icon;
  final Widget? label;
  final void Function()? onPressed;
  final bool isSelected;

  const ToggleButton({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedStyle = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );

    final List<Widget> children = [];
    if (icon != null) {
      children.add(icon!);
    }
    if (label != null) {
      if (icon != null) {
        children.add(const SizedBox(width: 8.0));
      }
      children.add(label!);
    }

    if (isSelected) {
      return FilledButton(
        onPressed: onPressed,
        style: selectedStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      );
    } else {
      return FilledButton.tonal(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      );
    }
  }
}
