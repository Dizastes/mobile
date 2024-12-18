import 'package:flutter/material.dart';

import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataBase db = DataBase();

  void _deleteOperation(bool isDivident, int index) {
    setState(() {
      if (isDivident) {
        db.depositsOperations.removeAt(index);
      } else {
        db.expensesOperations.removeAt(index);
      }
    });
  }

  Widget getColumn(bool isDivident) {
    return Column(
      children: [
        Text(isDivident ? 'Доходы' : 'Расходы', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(250, 26, 64, 25), fontSize: 20),),
        SizedBox(
          
          height: 550,
          width: 205,
          child: ListView.builder(
            
              itemCount: isDivident
                  ? db.depositsOperations.length
                  : db.expensesOperations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isDivident
                          ? db.depositsOperations[index]['name']
                          : db.expensesOperations[index]['name']),
                      Text(
                          '${isDivident ? '+' : '-'}${isDivident ? db.depositsOperations[index]['sum'] : db.expensesOperations[index]['sum']}')
                    ],
                  ),
                  onLongPress: () {
                    _deleteOperation(isDivident, index);
                  },
                );
              }),
        ),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add',
                  arguments: {'isDevident': isDivident});
            },
            icon: Icon(Icons.add_circle, color: Color.fromARGB(250, 26, 64, 25),))
      ],
    );
  }

  @override
  void initState() {
    db.loadData();
    print(db.depositsCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 26, 64, 25),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Money by Vlada', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210), fontWeight: FontWeight.bold),),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/stats');
              },
              icon: Icon(Icons.analytics, color: Color.fromARGB(250, 210, 250, 210),))
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [getColumn(true), getColumn(false)],
      ),
    );
  }
}
