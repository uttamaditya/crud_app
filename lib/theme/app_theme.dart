

import 'package:flutter/material.dart';

class AppTheme{

  static const TextTheme textTheme = TextTheme(
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 12
    ),
    titleMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15
    ),
    titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none
    ),
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.lineThrough
  )

  );

  static ThemeData myAppTheme = appTheme();

  static ThemeData appTheme()
  {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,

          elevatedButtonTheme: ElevatedButtonThemeData(

            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 50),
              elevation: 10,
              shadowColor: Colors.black
            ),
          ),

      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Colors.white, width: 3.0)),
        border: OutlineInputBorder(borderRadius:BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Colors.white, width: 3.0)),
        focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Colors.white, width: 1.0)),
      ),

      textTheme: textTheme,
      checkboxTheme: CheckboxThemeData(
        fillColor:  MaterialStateProperty.all<Color>(Colors.black),
      )
    );

  }
}