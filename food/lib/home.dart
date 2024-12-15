import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final favorite = Hive.box('Food');
  Favorites Food = Favorites();
  final supabase = Supabase.instance.client;
  List foods = [];
  bool isFavorite = false;

  TextEditingController text = TextEditingController();

  void getFoods() async {
    final response = await supabase.from('product').select();

    setState(() {
      foods = response;
      Food.foods = foods;
      Food.update();
    });
    print(await supabase.from('product').select());
  }

  void getFiltered() {
    RegExp regExp = RegExp('^${text.text.toLowerCase()}');

    setState(() {
      if (isFavorite) {
        if (text.text.length == 0) {
          foods = Food.favorite;
        } else {
          foods = Food.favorite
              .where((food) => regExp.hasMatch(food['food']['name'].toLowerCase()))
              .toList();
              
        }
      } else {
        if (text.text.length == 0) {
          foods = Food.foods;
        } else {
          foods = Food.foods
              .where((food) => regExp.hasMatch(food['name'].toLowerCase()))
              .toList();
        }
      }
    });
  }

  bool colorCheck(int index) {
    return Food.favorite
            .where((food) => food['id'] == foods[index]['id'])
            .length != 0;
  }

  @override
  void initState() {
    Food.loadData();
    getFoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(250, 210, 250, 210),
        appBar: AppBar(
            // toolbarHeight: 100,
            backgroundColor: Color.fromARGB(250, 210, 250, 210),
            title: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text('Ккал', style: TextStyle(color: Color.fromARGB(250, 26, 64, 25)),),
                    SizedBox(
                      width: 50,
                    ),
                    Text('Б', style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
                    SizedBox(
                      width: 40,
                    ),
                    Text('Ж', style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
                    SizedBox(
                      width: 45,
                    ),
                    Text('У', style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
                    SizedBox(
                      width: 30,
                      height: 50,
                    ),
                  ],
                ),
                Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                            getFiltered();
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Color.fromARGB(250, 26, 64, 25),
                        )))
              ],
            )),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(250, 210, 250, 210),
          child: SizedBox(
            width: 150,
            height: 30,
            child: TextField(
              controller: text,
              onChanged: (value) {
                getFiltered();
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Stack(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text('${!isFavorite ? foods[index]['name'] : foods[index]['food']['name']}'),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                        '${!isFavorite ? foods[index]['calories'] : foods[index]['food']['calories']}'),
                                  ),
                                  Text(
                                      '${!isFavorite ? foods[index]['protein'] : foods[index]['food']['protein']}'),
                                  Text(
                                      '${!isFavorite ? foods[index]['fats'] : foods[index]['food']['fats']}'),
                                  Text(
                                      '${!isFavorite ? foods[index]['carbohydrates'] : foods[index]['food']['carbohydrates']}'),
                                  SizedBox(
                                    width: 50,
                                  )
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                              top: 10,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (colorCheck(index)) {
                                        Food.favorite.removeWhere((food) =>
                                            food['id'] == foods[index]['id']);
                                      } else {
                                        Food.favorite.add({
                                          'id': foods[index]['id'],
                                          'food': foods[index]
                                        });
                                      }
                                      Food.update();
                                      print(Food.favorite);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: colorCheck(index)
                                        ? Colors.red
                                        : Color.fromARGB(250, 26, 64, 25),
                                  )))
                        ],
                      ));
                    }))
          ],
        ));
  }
}
