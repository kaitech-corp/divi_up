

import 'package:flutter/material.dart';

ThemeData themeDataBuilder() {
  return ThemeData.dark().copyWith(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
      elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
      shape: MaterialStateProperty.all<
      RoundedRectangleBorder>(
      RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
  )
  ),))
  );
}
