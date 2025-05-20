import 'package:flutter/material.dart';
import 'home_page.dart';
import 'prediction_page.dart';
import 'result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CekParu',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
      routes: {
        '/prediction': (context) => const FormPage(),
        '/result': (context) => const ResultPage(riskResult: ''),
      },
    );
  }
}
