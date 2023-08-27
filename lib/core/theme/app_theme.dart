import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xff18171b),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[900],
        filled: true,
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
              minimumSize:
                  MaterialStateProperty.all(const Size.fromHeight(50)))),
      textTheme: const TextTheme(
          labelSmall: TextStyle(fontSize: 16, color: Colors.grey),
          labelMedium: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          headlineLarge: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              minimumSize:
                  MaterialStateProperty.all(const Size.fromHeight(50)))));
}
