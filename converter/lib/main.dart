import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'converter.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      title: 'Converter',
      initialRoute: '/main',
      routes: {
        '/main' : (context)=>Home(),
        '/lenght':(context)=> Converter(),
        '/square':(context)=> Converter(),
        '/volume':(context)=> Converter(),
        '/mass':(context)=> Converter(),
        '/currency':(context)=> Converter(),
        '/bit':(context)=> Converter(),

      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, Map<String, dynamic>> values = {
    '/lenght': {
      'name': 'ДЛИННА',
      'unit': ['дюйм', 'м', 'фут'],
      'k': [39.4, 1, 3.28]
    },
    '/square': {
      'name': 'ПЛОЩАДЬ',
      'unit': ['см2', 'м2', 'км2'],
      'k': [10000, 1, 0.000001]
    },
    '/volume': {
      'name': 'ОБЪЕМ',
      'unit': ['см3', 'м3', 'км3'],
      'k': [1000000, 1, 0.000000001]
    },
    '/mass': {
      'name': 'МАССА',
      'unit': ['г', 'кг', 'т'],
      'k': [1000, 1, 0.001]
    },
    '/currency': {
      'name': 'ВАЛЮТА',
      'unit': ['EUR', 'USD', 'RUB'],
      'k': [0.9, 1, 97]
    },
    '/bit': {
      'name': 'ОБЪЕМ ИФОРМАЦИИ',
      'unit': ['бит', 'Кбайт', 'байт'],
      'k': [8192, 1, 1024]
    }, 
  };
  Widget getButton(String text, String redirect, Color color) 
  {
    bool t;
    if (text == '0') 
    {
      t = true;
    } 
    else 
    {
      t = false;
    }
    return Expanded

    (
        flex: t == true ? 2 : 1,
        child: Padding
        (
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SizedBox(height: 175,
            child: ElevatedButton
            (
              style: ElevatedButton.styleFrom
              (
                  backgroundColor: color,
                  foregroundColor: const Color.fromARGB(250, 210, 250, 210),
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20)),
              onPressed: () 
              {
               Navigator.pushNamed(context, redirect, arguments: <String,dynamic>{'list': values[redirect]});
              },
              child: Text(text, style: const TextStyle(fontSize: 24)),
            ),)));
  }

   @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor:const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar
      (
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        title: const Text('Converter', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
      ),
      body: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical:20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
           Row(
            children: [
              getButton('Длина 📏', '/lenght', Color.fromARGB(250, 26, 64, 25)),
              getButton('Масса 🐘', '/mass', const Color.fromARGB(250, 26, 64, 25)),
            ],
           ),
           SizedBox(height: 20,),

           Row(
            children: [
              getButton('Площадь 📐', '/square', const Color.fromARGB(250, 26, 64, 25)),
              getButton('Объем 🧊', '/volume', const Color.fromARGB(250, 26, 64, 25)),
            ],
           ),
           SizedBox(height: 20,),
           Row(
            children: [
              getButton('Объем 💻 информации', '/bit', const Color.fromARGB(250, 26, 64, 25)),
              getButton('Валюты 💰', '/currency', const Color.fromARGB(250, 26, 64, 25)),
            ],
           )
          ],
        ),
      ),
    );
  }
}