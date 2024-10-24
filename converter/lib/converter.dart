
import 'package:flutter/material.dart';

class Converter extends StatefulWidget {
  const Converter({super.key});

  @override
  State<Converter> createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  Map<String,dynamic> info = {};
  List list =[];
  List k =[];
  bool flag = true;
  String dropIndex = 's';
  String str = '0';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        info = args['list']!;
        list = info['unit'];
        k = info['k'];
        dropIndex = info['unit'][0];
        flag = false;
      });
    });
    super.initState();
  }
  String conv (String unit, String str, String dropIndex){
    if (unit == dropIndex){
      return str;
    }
    if (dropIndex == list[0]){
      if (unit == list[1]){
        return (int.parse(str) / k[0]).toStringAsFixed(3);
      }
      return (int.parse(str) / k[0] * k[2]).toStringAsFixed(3);
    }
    else if (dropIndex == list[1]){
      if (unit == list[0]){
        return (int.parse(str) * k[0]).toStringAsFixed(3);
      }
      return (int.parse(str) * k[2]).toStringAsFixed(3);
    }
    else if (dropIndex == list[2]){
      if (unit == list[0]){
        return (int.parse(str) / k [2] * k[0]).toStringAsFixed(3);
      }
      return (int.parse(str) / k[2]).toStringAsFixed(3);
    }
    
    return '';
  }
  @override
  Widget build(BuildContext context) {
    if (flag) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
        body: Center(
            child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        //title: const Text(//info['name'].toString(),
           // style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  child: TextField(
                    onChanged: (value) => {
                      setState(() {
                        str = value;
                      })
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                DropdownMenu(
                  width: 150,
                  initialSelection: list[0],
                  onSelected: (values) => {
                    setState(() {
                      dropIndex = values;
                    })
                  },
                  dropdownMenuEntries: list
                      .map((item) => DropdownMenuEntry(
                            value: item,
                            label: item,
                          ))
                      .toList(),
                ),
              ],
            ),
            Card(
              color: Color.fromARGB(250, 26, 64, 25),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conv(list[0], str, dropIndex) + '  ' + list[0],
                      style: TextStyle(
                          color: Color.fromARGB(250, 210, 250, 210),
                          fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(250, 26, 64, 25),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conv(list[1], str, dropIndex) + '  ' + list[1],
                      style: TextStyle(
                          color: Color.fromARGB(250, 210, 250, 210),
                          fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: Color.fromARGB(250, 26, 64, 25),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conv(list[2], str, dropIndex) + '  ' + list[2],
                      style: TextStyle(
                          color: Color.fromARGB(250, 210, 250, 210),
                          fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
