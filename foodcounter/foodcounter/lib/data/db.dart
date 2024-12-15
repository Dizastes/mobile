import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List product = [];
  List breakfast = [];
  List brunch = [];
  List lunch = [];
  List afternoontea = [];
  List dinner = [];
  List snack = [];

  final myBox = Hive.box('mybox');

  void loadData() {
    DateTime date;
     if (myBox.get('date') == null) {
      myBox.put('date', DateTime.now());
    } else {
      date = myBox.get('date');
      if (DateTime.now().day != date.day) {
        myBox.put('Breakfast', []);
        myBox.put('Brunch', []);
        myBox.put('Lunch', []);
        myBox.put('Afternoontea', []);
        myBox.put('Dinner', []);
        myBox.put('Snack', []);
        myBox.put('date', DateTime.now());
      }
    }

    product = myBox.get('List', defaultValue: []);
    breakfast = myBox.get('Breakfast', defaultValue: []);
    brunch = myBox.get('Brunch', defaultValue: []);
    lunch = myBox.get('Lunch', defaultValue: []);
    afternoontea = myBox.get('Afternoontea', defaultValue: []);
    dinner = myBox.get('Dinner', defaultValue: []);
    snack = myBox.get('Snack', defaultValue: []);
  }

  void updateFood(String time, List choosen, bool flag) {
    if (flag) {
      if (time == 'Breakfast') {
        breakfast.addAll(choosen);
        myBox.put(time, breakfast);
      } else if (time == 'Brunch') {
        lunch.addAll(choosen);
        myBox.put(time, brunch);
      } else if (time == 'Lunch') {
        lunch.addAll(choosen);
        myBox.put(time, lunch);
      }else if (time == 'Afternoontea') {
        lunch.addAll(choosen);
        myBox.put(time, afternoontea);
      }else if (time == 'Dinner') {
        lunch.addAll(choosen);
        myBox.put(time, dinner);
      }else {
        dinner.addAll(choosen);
        myBox.put(time, snack);
      }

    } else {
      if (time == 'Breakfast') {
        breakfast = choosen;
        myBox.put(time, breakfast);
      } else if (time == 'Brunch') {
        brunch = choosen;
        myBox.put(time, brunch);
      } else if (time == 'Lunch') {
        lunch = choosen;
        myBox.put(time, lunch);
      }else if (time == 'Afternoontea') {
        afternoontea = choosen;
        myBox.put(time, afternoontea);
      }else if (time == 'Dinner') {
        dinner = choosen;
        myBox.put(time, dinner);
      }else {
        snack = choosen;
        myBox.put(time, snack);
      }
    }
  }

  void updateProduct() {
    myBox.put('List', product);
  }
}