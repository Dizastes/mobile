import 'package:hive_flutter/hive_flutter.dart';

class Favorites {
  List favorite = [];
  List foods = [];

  final myBox = Hive.box('Food');

  void loadData() {
    favorite = myBox.get('favorite', defaultValue: []);
    foods = myBox.get('foods', defaultValue: []);
  }

  void update() {
    myBox.put('favorite', favorite);
    myBox.put('foods', foods);
  }
}