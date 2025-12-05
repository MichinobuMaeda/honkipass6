import 'package:flutter/material.dart';

const useMaterial3 = true;
const seedColor = Colors.teal;
const breakpointMobile = 480.0;
const contentWidth = 640.0;
const contentPadding = 16.0;

final defaultButtonStyle = ButtonStyle(
  padding: WidgetStateProperty.all(
    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  ),
);
final filledButtonTheme = FilledButtonThemeData(style: defaultButtonStyle);
final outlinedButtonTheme = OutlinedButtonThemeData(style: defaultButtonStyle);
final elevatedButtonTheme = ElevatedButtonThemeData(style: defaultButtonStyle);

final themeData = ThemeData(
  useMaterial3: useMaterial3,
  colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
  filledButtonTheme: filledButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  sliderTheme: SliderThemeData(
    year2023: false,
    trackHeight: 24.0,
    showValueIndicator: ShowValueIndicator.alwaysVisible,
  ),
);

final darkThemeData = ThemeData(
  useMaterial3: useMaterial3,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
  filledButtonTheme: filledButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  elevatedButtonTheme: elevatedButtonTheme,
);
