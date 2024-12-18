import 'package:flutter/material.dart';
import 'dart:math';

import 'database.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sumController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();

  String categoryName = '';
  DateTime? date;
  List categories = [];
  DataBase db = DataBase();
  bool isDivident = false;

  int getId(bool isDivident) {
    if (isDivident) {
      if (db.depositsOperations.isEmpty) {
        return 1;
      } else {
        return db.depositsOperations[db.depositsOperations.length - 1]['id'] +
            1;
      }
    } else {
      if (db.expensesOperations.isEmpty) {
        return 1;
      } else {
        return db.expensesOperations[db.expensesOperations.length - 1]['id'] +
            1;
      }
    }
  }

  int getCategoryId(bool isDivident) {
    if (isDivident) {
      if (db.depositsCategories.isEmpty) {
        return 1;
      } else {
        return db.depositsCategories[db.depositsCategories.length - 1]['id'] +
            1;
      }
    } else {
      if (db.expensesCategories.isEmpty) {
        return 1;
      } else {
        return db.expensesCategories[db.expensesCategories.length - 1]['id'] +
            1;
      }
    }
  }

  Color generateRandomColor() {
    Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    int alpha = random.nextInt(256);

    return Color.fromARGB(alpha, red, green, blue);
  }

  bool check() {
    if (nameController.text.isNotEmpty &&
        sumController.text.isNotEmpty &&
        date != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    db.loadData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, bool>;
      setState(() {
        isDivident = args['isDevident']!;
        categories = isDivident ? db.depositsCategories : db.expensesCategories;
        categoryName = categories[0]['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 26, 64, 25),
        title: const Text("Создание новой операции", style: TextStyle(color: Color.fromARGB(250, 210, 250, 210)),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                        
                    controller: nameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: 'Название',
                      border: OutlineInputBorder(),
                    ),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: sumController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: 'Сумма',
                      border: OutlineInputBorder(),
                    ),
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Категория', style: TextStyle(fontSize: 18, color:  Color.fromARGB(250, 26, 64, 25))),
                  ),
                  DropdownButton<String>(
                    value: categoryName,
                    items: categories.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['name'].toString(),
                        child: Text(item['name']),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          categoryName = value;
                          print(categoryName);
                        });
                      }
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: SizedBox(
                                      height: 150,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 5,),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: TextField(
                                                
                                                    controller:
                                                        categoryNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                     
                                                      contentPadding:
                                                          EdgeInsets.all(5),
                                                      hintText: 'Название' , 
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (categoryNameController
                                                          .text.isNotEmpty) {
                                                        isDivident
                                                            ? db.depositsCategories
                                                                .add({
                                                                'id':
                                                                    getCategoryId(
                                                                        true),
                                                                'name':
                                                                    categoryNameController
                                                                        .text,
                                                                'color':
                                                                    generateRandomColor()
                                                                        .value
                                                              })
                                                            : db.expensesCategories
                                                                .add({
                                                                'id':
                                                                    getCategoryId(
                                                                        false),
                                                                'name':
                                                                    categoryNameController
                                                                        .text,
                                                                'color':
                                                                    generateRandomColor()
                                                                        .value
                                                              });
                                                        db.update();
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                  child: Text('Добавить операцию'))
                                            ],
                                          ),
                                          Positioned(
                                              top: -15,
                                              right: -15,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(Icons.close)))
                                        ],
                                      )));
                            });
                      },
                      icon: Icon(Icons.add_circle, color:  Color.fromARGB(250, 26, 64, 25),))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now());

                        if (pickedDate != null && date != pickedDate) {
                          setState(() {
                            date = pickedDate;
                          });
                        }
                      },
                      child: Text(date == null
                          ? 'Выбрать дату'
                          : date.toString().split(' ')[0], style: TextStyle(color:  Color.fromARGB(250, 26, 64, 25))))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (check()) {
                          setState(() {
                            isDivident
                                ? db.depositsOperations.add({
                                    'id': getId(isDivident),
                                    'categoryName': categoryName,
                                    'sum': sumController.text,
                                    'name': nameController.text,
                                    'date': date
                                  })
                                : db.expensesOperations.add({
                                    'id': getId(isDivident),
                                    'categoryName': categoryName,
                                    'sum': sumController.text,
                                    'name': nameController.text,
                                    'date': date
                                  });
                            db.update();
                            Navigator.pushNamed(context, '/home');
                          });
                        }
                      },
                      child: Text('Добавить операцию', style: TextStyle(color:  Color.fromARGB(250, 26, 64, 25))))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
