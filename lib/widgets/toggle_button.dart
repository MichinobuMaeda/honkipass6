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
    return isSelected
        ? (label == null
              ? IconButton.filled(onPressed: onPressed, icon: icon ?? Text(''))
              : (icon == null
                    ? FilledButton(
                        onPressed: onPressed,
                        child: Row(spacing: 8.0, mainAxisSize: MainAxisSize.min,children: [label!]),
                      )
                    : FilledButton(
                        onPressed: onPressed,
                        child: Row(spacing: 8.0, mainAxisSize: MainAxisSize.min,children: [icon!, label!]),
                      )))
        : (label == null
              ? IconButton.filledTonal(
                  onPressed: onPressed,
                  icon: icon ?? Text(''),
                )
              : (icon == null
                    ? FilledButton.tonal(
                        onPressed: onPressed,
                        child: Row(spacing: 8.0,mainAxisSize: MainAxisSize.min, children: [label!]),
                      )
                    : FilledButton.tonal(
                        onPressed: onPressed,
                        child: Row(spacing: 8.0, mainAxisSize: MainAxisSize.min,children: [icon!, label!]),
                      )));
  }
}
