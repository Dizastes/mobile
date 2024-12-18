import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List depositsCategories = [];
  List expensesCategories = [];
  List depositsOperations = [];
  List expensesOperations = [];

  final localStorage = Hive.box('Finance');

  void loadData() {
    depositsCategories = localStorage.get('depositsCategories', defaultValue: [
      {
        'id': 0,
        'name': 'Разное',
        'color': const Color.fromARGB(255, 107, 155, 52).value
      }
    ]);
    expensesCategories = localStorage.get('expensesCategories', defaultValue: [
      {
        'id': 0,
        'name': 'Разное',
        'color': const Color.fromARGB(255, 107, 155, 52).value
      }
    ]);
    depositsOperations =
        localStorage.get('depositsOperations', defaultValue: []);
    expensesOperations =
        localStorage.get('expensesOperations', defaultValue: []);
  }

  void update() {
    localStorage.put('depositsCategories', depositsCategories);
    localStorage.put('expensesCategories', expensesCategories);
    localStorage.put('expensesOperations', expensesOperations);
    localStorage.put('depositsOperations', depositsOperations);
  }
}
