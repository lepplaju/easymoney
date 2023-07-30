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
      labelColor: Colors.white,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.white,
    ),
    //==========================================================================
    // FloatingActionButton
    //==========================================================================
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      iconSize: 40,
      smallSizeConstraints: BoxConstraints(minHeight: 60, minWidth: 60),
      extendedSizeConstraints: BoxConstraints(minHeight: 70),
      extendedTextStyle: TextStyle(
        fontSize: 25,
      ),
    ),
    //==========================================================================
    // SnackBar
    //==========================================================================
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

    textTheme: TextTheme(
      //========================================================================
      // Displays are used in Big seperate texts which dont have any body
      //========================================================================
      displayLarge: const TextStyle(
          //color: Colors.black,
          ),

      displayMedium: const TextStyle(
        //color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 40,
      ),

      displaySmall: const TextStyle(color: Colors.black, fontSize: 20),
      //========================================================================
      // Headlines are used for large titles which have many lower titles
      //========================================================================
      headlineLarge: const TextStyle(
          //color: Colors.black,
          ),

      // Used in ReceiptCard titles
      headlineMedium: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.w500,
        fontSize: 30,
      ),

      headlineSmall: TextStyle(
        color: Colors.white.withOpacity(0.8),
      ),

      //========================================================================
      // Titles are used for text which has no sub titles but has body text
      //========================================================================
      titleLarge: const TextStyle(fontWeight: FontWeight.w500),

      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),

      titleSmall: const TextStyle(
          //color: Colors.black,
          ),

      //========================================================================
      // Labels are used for small texts which are seperate and have no body
      //========================================================================
      labelLarge: const TextStyle(
        //color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),

      labelMedium: const TextStyle(
        //color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      labelSmall: const TextStyle(
          //color: Colors.black,
          ),

      //========================================================================
      // Bodies are used for body text
      //========================================================================

      bodyLarge: const TextStyle(
          //color: Colors.black,
          ),

      bodyMedium: const TextStyle(
          //color: Colors.black,
          ),
      bodySmall: const TextStyle(
          //color: Colors.black,
          ),
    ),
  );
}
