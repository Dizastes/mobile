import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();
  DateTime today = DateTime.now();

  List wekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Widget getGrid() {
    List<Widget> grid = [];

    for (int i = 0; i < 7; i++) {
      grid.add(Container(
        width: 50,
        height: 50,
        child: Center(
          child: Text(
            wekdays[i],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(250, 26, 64, 25)),
          ),
        ),
      ));
    }

    int days = DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);

    int firstDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month, 1).weekday;

    int emptyContainers =
        (firstDayOfMonth == 1) ? 8 : firstDayOfMonth; 

    for (int i = 0; i < emptyContainers - 1; i++) {
      grid.add(Container(
        width: 50,
        height: 50,
      ));
    }

    for (int i = 1; i <= days; i++) {
      grid.add(getCell(i));
    }

    int lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month, days).weekday;
    int trailingEmptyContainers =
        (lastDayOfMonth == 1) ? 8 : (7 - lastDayOfMonth);

    for (int i = 0; i < trailingEmptyContainers; i++) {
      grid.add(Container(
        width: 50,
        height: 50,
      ));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 500,
      child: GridView.count(
        crossAxisCount: 7,
        physics: NeverScrollableScrollPhysics(),
        children: grid,
      ),
    );
  }

  Widget getCell(int day) {
    return Container(
      decoration: BoxDecoration(
        color: DateTime(selectedDate.year, selectedDate.month, day) !=
                DateTime(today.year, today.month, today.day)
            ? Colors.transparent
            : const Color.fromARGB(250, 26, 64, 25),
        borderRadius: BorderRadius.circular(35),
      ),
      width: 50,
      height: 50,
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: DateTime(selectedDate.year, selectedDate.month, day) !=
                    DateTime(today.year, today.month, today.day)
                ? const Color.fromARGB(250, 26, 64, 25)
                : const Color.fromARGB(250, 210, 250, 210),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        title: const Text('Calendar',
            style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
        actions: [
          DateTime(selectedDate.year, selectedDate.month) !=
                  DateTime(today.year, today.month)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: Color.fromARGB(250, 210, 250, 210),
                  ))
              : SizedBox()
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedDate.year.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(250, 26, 64, 25)),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate =
                            DateTime(selectedDate.year, selectedDate.month - 1);
                      });
                    },
                    icon: Icon(Icons.arrow_back,
                        color: Color.fromARGB(250, 26, 64, 25))),
                SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(250, 26, 64, 25)),
                          DateFormat.MMMM().format(selectedDate).toString()),
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate =
                            DateTime(selectedDate.year, selectedDate.month + 1);
                      });
                    },
                    icon: Icon(Icons.arrow_forward,
                        color: Color.fromARGB(250, 26, 64, 25))),
              ],
            ),
            Row(
              children: [getGrid()],
            )
          ],
        ),
      ),
    );
  }
}
