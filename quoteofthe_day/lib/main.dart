import 'package:flutter/material.dart';
import 'package:quoteofthe_day/views/home.dart';
import 'package:quoteofthe_day/model/quotes.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote of the Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        quotes: quotes,
        currentDay: 1,
        quoteIndex: 0,
      ),
    );
  }
}
