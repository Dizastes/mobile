import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<dynamic> weatherDays = [];
  final _cityController = TextEditingController();
  Map<String,dynamic> currentDay = {};
  String activeCity = 'Ханты-Мансийск';
  @override
  void initState() {
    super.initState();
     _cityController.text = "Ханты-Мансийск";
     initWeather();
  }

  void initWeather() async{
    await getWeather( _cityController.text);
  }

  Future<void> getWeather(String city) async {
    final apiKey = "b92cde5b4bcc47e99e092634241012";
    final url = "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no&lang=ru";

    List<dynamic> returnData;
    Map<String,dynamic> tempCurrDay;
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        String decoded = utf8.decode(response.bodyBytes);
        Map<String,dynamic> temp = json.decode(decoded);
        setState(() {
           weatherDays = temp["forecast"]['forecastday'];
           currentDay = temp["current"];
           _cityController.text = temp['location']['name'];
           activeCity = temp['location']['name'];
        });
      }else{
        throw Exception(response.statusCode);
    }
    }catch(e){
      print(e);
      _cityController.text = activeCity;
    }
  }



 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(250, 26, 64, 25),
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(250, 210, 250, 210),
      title: const Text("MeteoVlada - погода", style: TextStyle(color: Color.fromARGB(250, 26, 64, 25)),),
    ),
    body: weatherDays.isEmpty ? Center(child: CircularProgressIndicator(),) : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _cityController,
            onSubmitted: (value) => {initWeather()},
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network("http:${currentDay['condition']['icon']}"),
                      Text(currentDay['temp_c'].toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Влажность: ${currentDay['humidity'].toString()}%', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210)),),
                      Text('Скорость ветра: ${currentDay['wind_kph'].toString()} км/ч', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210)),),
                      Text('Давление: ${currentDay['pressure_mb'].toString()} мбар', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210)),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weatherDays[0]['hour'].length,
              itemBuilder: (context, index){
                Map<String,dynamic> currHour = weatherDays[0]['hour'][index];
                return Column(
                  children: [
                    Text(currHour["time"].toString().substring(11,16)),
                    Image.network("http:${currHour["condition"]['icon']}"),
                    Text(currHour["temp_c"].toString())
                  ],
                );
              }),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: weatherDays.length-1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(250, 210, 250, 210),
                    borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(weatherDays[index+1]['date'].toString(), style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
                      Text(weatherDays[index+1]['day']["mintemp_c"].toString(), style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
                      Text(weatherDays[index+1]['day']["maxtemp_c"].toString(), style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

}