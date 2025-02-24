import 'package:flutter/material.dart';

import 'package:pokedex/screen/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex @yliqi_2',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'Pokemon', fontSize: 28, color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homescreen(),
    );
  }
}
