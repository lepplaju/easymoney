import 'package:flutter/material.dart';

// FIXME Document
class MyTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.pink,
      onPrimary: Colors.white,
      primaryContainer: Colors.cyan,
      secondary: Colors.purple,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.purple,
      surface: const Color.fromARGB(255, 250, 235, 240),
      onSurface: Colors.black,
      tertiary: Colors.lightGreen,
      onTertiary: Colors.white,
      shadow: Colors.black.withOpacity(0.4),
    ),
    iconTheme: const IconThemeData(color: Colors.pink),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.pink,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.white,
    ),
    //========================================================================
    // SnackBar
    //========================================================================
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.purple,
      contentTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    textTheme: const TextTheme(
      //========================================================================
      // Displays are used in Big seperate texts which dont have any body
      //========================================================================
      displayLarge: TextStyle(
        color: Colors.black,
      ),

      displayMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 40,
      ),

      displaySmall: TextStyle(color: Colors.black, fontSize: 20),
      //========================================================================
      // Headlines are used for large titles which have many lower titles
      //========================================================================
      headlineLarge: TextStyle(
        color: Colors.black,
      ),

      headlineMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 35,
      ),

      headlineSmall: TextStyle(
        color: Colors.black,
      ),

      //========================================================================
      // Titles are used for text which has no sub titles but has body text
      //========================================================================
      titleLarge: TextStyle(fontWeight: FontWeight.w500),

      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),

      titleSmall: TextStyle(
        color: Colors.black,
      ),

      //========================================================================
      // Labels are used for small texts which are seperate and have no body
      //========================================================================
      labelLarge: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),

      labelMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      labelSmall: TextStyle(
        color: Colors.black,
      ),

      //========================================================================
      // Bodies are used for body text
      //========================================================================

      bodyLarge: TextStyle(
        color: Colors.black,
      ),

      bodyMedium: TextStyle(
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
      ),
    ),
  );
}
