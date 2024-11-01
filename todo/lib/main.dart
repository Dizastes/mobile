import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/create.dart';
import 'package:todo/database.dart';

void main() async {
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
        title: 'ToDo',
        initialRoute: '/home',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const Home(),
          '/create': (context) => const Create(),
        });
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ToDoList db = ToDoList();
  List selectedItems = [];
  void redact(int index) {
    final TextEditingController controllerN = TextEditingController();
    controllerN.text = selectedItems[index]['name'];
    final TextEditingController controllerD = TextEditingController();
    controllerD.text = selectedItems[index]['description'];
    final TextEditingController controllerDa = TextEditingController();
    controllerDa.text = selectedItems[index]['date'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Изменить задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controllerN,
                decoration: const InputDecoration(
                    hintText: 'Введите измененное название'),
              ),
              TextField(
                controller: controllerD,
                decoration: const InputDecoration(
                    hintText: 'Введите измененное описание'),
              ),
              TextField(
                controller: controllerDa,
                decoration:
                    const InputDecoration(hintText: 'Введите измененную дату'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed:(){
              setState(() {
                db.toDo.removeAt(index);
                db.update();
              });
            }, child: const Text('Удалить')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                String name = controllerN.text;
                String description = controllerD.text;
                String date = controllerDa.text;
                setState(() {
                  db.toDo[selectedItems[index]['id']] = {
                    'id': selectedItems[index]['id'],
                    'active': false,
                    'name': name,
                    'description': description,
                    'date': date,
                  };
                  db.update();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Изменить'),
            ),
          ],
        );
      },
    );
  }

  List get(int filter) {
    if (filter == 1) {
      return db.toDo.where((item) => item['active'] == false).toList();
    } else if (filter == 2) {
      return db.toDo.where((item) => item['active'] == true).toList();
    }
    return db.toDo;
  }

  @override
  void initState() {
    db.loadData();
    setState(() {
      selectedItems = db.toDo;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        title: const Text('ToDo',
            style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
        actions: [
          DropdownMenu(
            inputDecorationTheme: InputDecorationTheme(border: null),
            initialSelection: 0,
            textStyle: TextStyle(color: Color.fromARGB(250, 210, 250, 210)),
            onSelected: (value) {
              setState(() {
                selectedItems = get(int.parse(value!.toString()));
              });
            },
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: 0,
                label: 'All',
              ),
              DropdownMenuEntry(
                value: 1,
                label: 'Active',
              ),
              DropdownMenuEntry(
                value: 2,
                label: 'End',
              ),
            ],
          ),
          IconButton(
              color: const Color.fromARGB(250, 210, 250, 210),
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(context, '/create');
                });
              },
              icon: const FaIcon(FontAwesomeIcons.circlePlus)),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListView.builder(
            itemCount: selectedItems.length,
            itemBuilder: (context, index) {
              print(selectedItems);
              return SizedBox(
                  child: GestureDetector(
                child: Card(
                  child: Row(
                    children: [
                      Checkbox(
                          value: selectedItems[index]['active'],
                          onChanged: (value) {
                            setState(() {
                              db.toDo[selectedItems[index]['id']]['active'] =
                                  value;
                              db.update();
                            });
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          children: [
                            Text(
                              selectedItems[index]['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(selectedItems[index]['date'])
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  redact(index);
                },
              ));
            },
          )),
    );
  }
}
