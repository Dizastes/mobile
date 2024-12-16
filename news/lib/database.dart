import 'package:hive_flutter/hive_flutter.dart';

class NewsList {
  List news = [];

  final myBox = Hive.box('News');

  void loadData() {
    news = myBox.get('news', defaultValue: []);
  }

  void update() {
    myBox.put('news', news);
  }
}