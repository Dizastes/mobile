import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Food');
  await Supabase.initialize(
    url: 'https://dccfndkqtzcvjwsolteq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjY2ZuZGtxdHpjdmp3c29sdGVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3ODI1ODgsImV4cCI6MjA0OTM1ODU4OH0.dvSWHBlJ1eaOOjSi-GweJrf3_15gYgSw-5Nduz-NfY0',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food by Vlada',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}

