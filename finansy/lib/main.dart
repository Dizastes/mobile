import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home.dart';
import 'add.dart';
import 'stats.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Finance');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eight by Vlada',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: HomePage(),
      routes: {
        '/add': (context) => Add(),
        '/home': (context) => HomePage(),
        '/stats': (context) => ViewStats()
        
      },
    );
  }
}
