import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:math';

class ViewStats extends StatefulWidget {
  const ViewStats({super.key});

  @override
  State<ViewStats> createState() => _ViewStatsState();
}

class _ViewStatsState extends State<ViewStats> {
  DataBase db = DataBase();
  final List<bool> _selectedDate = <bool>[false, false, true];
  final List<bool> _selectedMainCategory = <bool>[true, false];
  Map categorySums = {};
  List<dynamic> selectedDB = [];
  List categories = [];

  @override
  void initState() {
    super.initState();
    db.loadData();
    selectedDB = db.depositsOperations;
    categories = db.depositsCategories;
    countCategorySums();
    print(categorySums);
  }

  void countCategorySums() {
    categorySums = {};
    DateTime temp = DateTime.now();
    if (_selectedDate[0]) {
      selectedDB.forEach((item) {
        if (item['date'].day == temp.day) {
          if (!categorySums.containsKey(item['categoryName'])) {
            categorySums[item['categoryName']] = 0;
          }
          categorySums[item['categoryName']] += int.parse(item['sum']);
        }
      });
    } else if (_selectedDate[1]) {
      selectedDB.forEach((item) {
        if (item['date'].month == temp.month) {
          if (!categorySums.containsKey(item['categoryName'])) {
            categorySums[item['categoryName']] = 0;
          }
          categorySums[item['categoryName']] += int.parse(item['sum']);
        }
      });
    } else {
      selectedDB.forEach((item) {
        if (item['date'].year == temp.year) {
          if (!categorySums.containsKey(item['categoryName'])) {
            categorySums[item['categoryName']] = 0;
          }
          categorySums[item['categoryName']] += int.parse(item['sum']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar( backgroundColor: Color.fromARGB(250, 26, 64, 25),
        title: Text('Статистика', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210), fontWeight: FontWeight.bold)),),
        
        body: Column(
          children: [
            SizedBox(
              height: 420,
              child:
                  ListView(physics: NeverScrollableScrollPhysics(), children: [
                Center(
                  child: ToggleButtons(
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedMainCategory.length; i++) {
                          _selectedMainCategory[i] = i == index;
                        }
                        if (_selectedMainCategory[0] == true) {
                          selectedDB = db.depositsOperations;
                          categories = db.depositsCategories;
                        } else {
                          selectedDB = db.expensesOperations;
                          categories = db.expensesCategories;
                        }
                        countCategorySums();
                      });
                    },
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedMainCategory,
                    children: const [Text('Доходы'), Text('Расходы')],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedDate.length; i++) {
                            _selectedDate[i] = i == index;
                          }
                          countCategorySums();
                        });
                      },
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _selectedDate,
                      children: const [
                        Text('День'),
                        Text('Неделя'),
                        Text('Месяц')
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: 300,
                    child: PieChart(PieChartData(
                      sections: showingSections(),
                    ))),
              ]),
            ),
            Expanded(
                child: categorySums.isNotEmpty ?  ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return categorySums.containsKey(categories[index]['name'])
                          ? ListTile(
                              leading: Icon(
                                Icons.circle,
                                color: Color(categories[index]['color']),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(categories[index]['name']),
                                  Text(categorySums[categories[index]['name']]
                                      .toString())
                                ],
                              ),
                            )
                          : null;
                    }) : ListTile(leading: Icon(Icons.circle, color: Colors.grey,), title: Text('Ничего'),))
          ],
        ));
  }

  List<PieChartSectionData> showingSections() {
    if (categorySums.isNotEmpty) {
      return categorySums.entries.map((entry) {

        return PieChartSectionData(
          color: Color(categories
              .where((item) => item['name'] == entry.key)
              .toList()[0]['color']),
          value: entry.value.toDouble(),
          title: '',
          radius: 40,
          titleStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        );
      }).toList();
    } else {
      return [PieChartSectionData(
        color: Colors.grey, 
        value: 1.0, 
        title: '',
      )];
    }
  }
}
