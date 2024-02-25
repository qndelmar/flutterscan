import 'package:flutter/material.dart';

final dartTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 31, 31, 31),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,

        ),
        centerTitle: true
    ),

    textTheme: const TextTheme(
      bodyMedium:  TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 20,

      ),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31)
);