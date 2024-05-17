import 'package:flutter/material.dart';
import 'package:note_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinez Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: _lightTheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.purple.shade200,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: _darkTheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.blueGrey.shade900,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Light theme colors
var _lightTheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(13, 91, 13, 159),
);

// Dark theme colors
var _darkTheme = const ColorScheme.dark();
