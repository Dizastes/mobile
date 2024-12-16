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
  final newsList = Hive.box('News');
  NewsList News = NewsList();
  final supabase = Supabase.instance.client;
  List news = [];
  List dates = [];
  List tags = [];

  List selectedDates = [];
  List selectedTags = [];

  bool isReversed = false;

  void itemnews() async {
    final response = await supabase.from('news').select();

    setState(() {
      if (response.length > News.news.length) {
        News.news = response;
        News.update();
        news = News.news;
        data();
      }
    });
  }

  void data() {
    Set dt = {};
    Set tg = {};
    for (int i = 0; i < news.length; i++) {
      dt.add(news[i]['date']);
      tg.add(news[i]['tag']);
    }
    dates = dt.toList();
    tags = tg.toList();
  }

  void sortByDate() {
    setState(() {
      news.sort((a, b) {
        DateTime dateA = DateTime.parse(a['created_at']);
        DateTime dateB = DateTime.parse(b['created_at']);
        return isReversed ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });

      isReversed = !isReversed;
    });
  }

  void filtered() {
    List temp = News.news;
    if (selectedDates.length > 0) {
      temp =
          temp.where((item) => selectedDates.contains(item['date'])).toList();
    }
    if (selectedTags.length > 0) {
      temp = temp.where((item) => selectedTags.contains(item['tag'])).toList();
    }
    news = temp;
  }

  Future model(bool isDate) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: isDate ? dates.length : tags.length,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return CheckboxListTile(
                          title: Text(isDate ? dates[index] : tags[index]),
                          value: isDate
                              ? selectedDates.contains(dates[index])
                              : selectedTags.contains(tags[index]),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value ?? false) {
                                isDate
                                    ? selectedDates.add(dates[index])
                                    : selectedTags.add(tags[index]);
                              } else {
                                isDate
                                    ? selectedDates.remove(dates[index])
                                    : selectedTags.remove(tags[index]);
                              }
                            });
                            this.setState(() {
                              filtered();
                            });
                          });
                    },
                  );
                }),
          );
        });
  }

  @override
  void initState() {
    itemnews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(250, 26, 64, 25),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(250, 210, 250, 210),
        title: Text('News by Vlada', style: TextStyle(color: Color.fromARGB(250, 26, 64, 25))),
        actions: [
          IconButton(onPressed: () {sortByDate();}, icon: Icon(Icons.access_time, color: !isReversed ? Colors.red : Colors.blue,)),
          IconButton(
              onPressed: () {
                model(true);
              },
              icon: Icon(Icons.calendar_month,)),
          IconButton(
              onPressed: () {
                model(false);
              },
              icon: Icon(Icons.tag))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/opisanie',
                            arguments: <String, Map>{'item': news[index]});
                      },
                      child: Card(
                        color: Color.fromARGB(250, 210, 250, 210),
                        child: Padding(
                          
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                
                                children: [
                                  Expanded(
                                      child: Text(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    news[index]['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      news[index]['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(news[index]['date']),
                                  Text('#${news[index]['tag']}')
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
