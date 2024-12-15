import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/db.dart';
import 'addProduct.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dccfndkqtzcvjwsolteq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjY2ZuZGtxdHpjdmp3c29sdGVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3ODI1ODgsImV4cCI6MjA0OTM1ODU4OH0.dvSWHBlJ1eaOOjSi-GweJrf3_15gYgSw-5Nduz-NfY0',
  );
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Counter',
      home: const FoodCounter(),
      debugShowCheckedModeBanner: false,
       routes: {
        '/home': (context) => const FoodCounter()
       }
    );
  }
}

class FoodCounter extends StatefulWidget {
  const FoodCounter({super.key});

  @override
  State<FoodCounter> createState() => _FoodCounterState();
}

class _FoodCounterState extends State<FoodCounter> {
  final myBox = Hive.box('mybox');
  DataBase db = DataBase();
  @override
  
  void initState(){
    db.loadData();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        title: const Text('Calendar', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(15),
          itemCount: 6,
          itemBuilder: (context, index){
            Map values = {
              'time': 'Breakfast',
              'calories': 0,
              'text': 'Завтрак',
              'list': db.breakfast
            };
            double temp = 0;

            if (index == 1) {
              values['calories'] = temp.toString();
              values['time'] = 'Brunch';
              values['text'] = 'Ланч';
              values['list'] = db.brunch;
            }else if (index == 2) {
              values['calories'] = temp.toString();
              values['time'] = 'Lunch';
              values['text'] = 'Обед';
              values['list'] = db.lunch;
            }else if (index == 3) {
              values['calories'] = temp.toString();
              values['time'] = 'Afternoontea';
              values['text'] = 'Полдник';
              values['list'] = db.afternoontea;
            } else if (index == 4) {
              values['calories'] = temp.toString();
              values['time'] = 'Dinner';
              values['text'] = 'Ужин';
              values['list'] = db.dinner;  
            }else if (index == 5) {
              values['calories'] = temp.toString();
              values['time'] = 'Snack';
              values['text'] = 'Снэки';
              values['list'] = db.snack;
            }
            for (int i = 0; i < values['list'].length; i++) {
              temp += double.parse(
                values['list'][i]['calories'].toString());
            }
            values['calories'] = temp.toString();

             return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color.fromARGB(250, 26, 64, 25),
                      child: Theme(
                          data: ThemeData(
                            dividerColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            leading: values['icon'],
                            showTrailingIcon: false,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${values['calories']} Ккал', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
                                Text(values['text'], style: TextStyle(color: Color.fromARGB(250, 210, 250, 210), fontWeight: FontWeight.w900)),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/select',
                                          arguments: <String, String>{
                                            'time': values['time'],
                                            'text': values['text']
                                          });
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.plus,
                                      color: Color.fromARGB(250, 210, 250, 210),
                                    ),
                                  ),
                              ],
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: values['list'].length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      ListTile(
                                          minVerticalPadding: 0,
                                          title: Text(values['list'][index]
                                                  ['name']
                                              .toString()),
                                          subtitle: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    '${values['list'][index]['grams']} г'),
                                              ),
                                              const Divider()
                                            ],
                                          )),
                                      Positioned(
                                          top: 10,
                                          right: 110,
                                          child: Text(
                                            '${values['list'][index]['calories'].toString()} Ккал',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )),
                                      Positioned(
                                          right: 25,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                values['list'].removeAt(index);
                                                print(values['list']);
                                                db.updateFood(values['time'],
                                                    values['list'], false);
                                              });
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.minus,
                                              color: Color.fromARGB(
                                                  255, 185, 82, 82),
                                            ),
                                          ))
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                      )
                    );
                  }))
        ],
      ),
    );
  }
}        
   