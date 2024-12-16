import 'package:flutter/material.dart';

class Opisanie extends StatefulWidget {
  const Opisanie({super.key});

  @override
  State<Opisanie> createState() => _OpisanieState();
}

class _OpisanieState extends State<Opisanie> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, Map>;
    Map item = args['item']!;
    return Scaffold(
      backgroundColor: Color.fromARGB(250, 210, 250, 210),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(250, 26, 64, 25),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    item['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [Expanded(child: Text(item['description']))],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(item['date']), Text('#${item['tag']}')],
              )
            ],
          ),
        ));
  }
}
