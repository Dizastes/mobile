import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../database.dart';
import 'package:intl/intl.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String name = '';
  String description = '';
  String date = '';
  final myBox = Hive.box('mybox');
  ToDoList db = ToDoList();
  String text = '';
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  final RegExp _dateRegex = RegExp(
    r'^(19|20)\d\d-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$',
  );

  void _validateDate(String value) {
    if (_dateRegex.hasMatch(value)) {
      setState(() {
        date = value;
        _errorText = null; // Сбрасываем ошибку
      });
    } else {
      setState(() {
        _errorText = 'Введите дату в формате YYYY-MM-DD';
      });
    }
  }
  int getId() {
    if (db.toDo.isNotEmpty) {
      if (db.toDo.length == 1) {
        return 1;
      } else {
        return db.toDo[db.toDo.length - 1]['id'] + 1;
      }
    } else {
      return 0;
    }
  }
  @override
  void initState() {
    db.loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        title: const Text('Создание задачи',
            style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
        leading: IconButton(
            onPressed: () => {Navigator.pushNamed(context, '/home')},
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Color.fromARGB(250, 210, 250, 210),
            )),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (value) => name = value,
                    )),
                SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (value) => description = value,
                    )),
                SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Дата (YYYY-MM-DD)",
                        errorText: _errorText,
                      ),
                      onChanged: _validateDate,
                    ))
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(250, 26, 64, 25),
          onPressed: () {
            if (name != '') {
              setState(() {
                db.toDo.add({
                  'id': getId(),
                  'name': name,
                  'description': description,
                  'date': date,
                  'active': false
                });
                db.update();
                print(db.toDo);
              });
            }
            Navigator.pushNamed(context, '/home');
          },
          child: FaIcon(
            FontAwesomeIcons.circlePlus,
            color: Color.fromARGB(250, 210, 250, 210),
          )),
    );
  }
}
