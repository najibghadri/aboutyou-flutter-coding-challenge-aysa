import 'package:flutter/material.dart';

import 'package:aboutyou/home.dart';
import 'package:aboutyou/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grouped List Demo',
      theme: aboutYouTheme,
      home: const HomePage(),
    );
  }
}
