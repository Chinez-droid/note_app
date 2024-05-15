import 'package:flutter/material.dart';
import 'package:note_app/screens/home_screen.dart';

// storing the purple theme for the light mode
var purpleTheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(13, 91, 13, 159),
);

void main() {
  runApp(MaterialApp(
    // configuring the app bar theme
    theme: ThemeData().copyWith(
      useMaterial3: true,
      // using stored colors for theming aside the display backround
      colorScheme: purpleTheme,
      appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: purpleTheme.onPrimaryContainer,
          foregroundColor: purpleTheme.primaryContainer),
    ),
    home: const HomeScreen(),
  ));
}
