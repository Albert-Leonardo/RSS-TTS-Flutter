import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:rss_tts/RSS_Feed.dart';
import 'package:webfeed/domain/rss_feed.dart';

class newsRSS {
  String newsTitle = '';
  String newsUrl = '';
  bool enable = false;
  newsRSS(a, b, c) {
    newsTitle = a;
    newsUrl = b;
    enable = c;
  }
}

List<newsRSS> rssList = [];

newsRSSBuilder() {
  return ListView.builder(
      itemCount: rssList.length,
      itemBuilder: (BuildContext context, int index) {
        if (rssList[index].enable == true) {
          return ListTile(
            title: Text(rssList[index].newsTitle),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              size: 30.0,
            ),
            contentPadding: EdgeInsets.all(5.0),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewsFeed(
                        rss: rssList[index],
                      )));
            },
          );
        } else {
          return SizedBox.shrink();
        }
      });
}

_SaveAndBack() {
  rssList.clear();
}

class RSS_mainmenu extends StatelessWidget {
  const RSS_mainmenu({super.key});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/rss.txt');
  }

  Future<File> writeFile(String s) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(s);
  }

  Future<String> readFile() async {
    File file = await _localFile;
    if (await file.exists()) {
      try {
        print("exists");
        String contents = await file.readAsString();
        if (contents == '') {
          print("no entry");
          String s =
              "Aljazeera,https://www.aljazeera.com/xml/rss/all.xml,true\nMalaysiaKini,https://www.malaysiakini.com/rss/en/news.rss,true\nUnited Nations,https://news.un.org/feed/subscribe/en/news/all/rss.xml,true";
          await writeFile(s);
          return s;
        }

        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      print("no exists");
      String s =
          "Aljazeera,https://www.aljazeera.com/xml/rss/all.xml,true\nMalaysiaKini,https://www.malaysiakini.com/rss/en/news.rss,true\nUnited Nations,https://news.un.org/feed/subscribe/en/news/all/rss.xml,true";
      await writeFile(s);
      return s;
    }
  }

  readRSS(List<newsRSS> rssList) async {
    String response;
    response = await readFile();
    LineSplitter ls = new LineSplitter();
    List<String> responseSplit = ls.convert(response);
    for (int i = 0; i < responseSplit.length; i++) {
      final splitNames = responseSplit[i].split(',');
      rssList.add(newsRSS(
          splitNames[0], splitNames[1], splitNames[2].toLowerCase() == 'true'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _SaveAndBack(),
        child: Scaffold(
            drawer: NavBar(),
            appBar: AppBar(
              title: Text("Main Menu"),
            ),
            body: FutureBuilder(
              future: readRSS(rssList),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('An Unexpected Error has Occured'));
                    } else {
                      return newsRSSBuilder();
                    }
                }
              },
            )));
  }
}
/*
class newsRSS {
  String newsTitle = '';
  String newsUrl = '';
  bool enable = false;
  newsRSS(a, b, c) {
    newsTitle = a;
    newsUrl = b;
    enable = c;
  }
}

List<newsRSS> rssList = [];

newsRSSBuilder() {
  return ListView.builder(
      itemCount: rssList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(rssList[index].newsTitle),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsFeed(
                      title: rssList[index].newsTitle,
                      feedUrl: rssList[index].newsUrl,
                    )));
          },
        );
      });
}

class RSS_mainmenu extends StatefulWidget {
  const RSS_mainmenu({super.key});
  @override
  State<RSS_mainmenu> createState() => _RSS_mainmenuState();
}

class _RSS_mainmenuState extends State<RSS_mainmenu> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/rss.txt');
  }

  Future<File> writeFile(String s) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(s);
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '0';
    }
  }

  readRSS(List<newsRSS> rssList) async {
    print(await readFile());
    String response = await readFile();
    LineSplitter ls = new LineSplitter();
    List<String> responseSplit = ls.convert(response);
    for (int i = 0; i < responseSplit.length; i++) {
      final splitNames = responseSplit[i].split(',');
      rssList.add(newsRSS(
          splitNames[0], splitNames[1], splitNames[2].toLowerCase() == 'true'));
    }
  }

  writeToFile() async {
    String builder = '';
    for (int i = 0; i < rssList.length; i++) {
      builder += rssList[i].newsTitle +
          ',' +
          rssList[i].newsUrl +
          ',' +
          rssList[i].enable.toString() +
          "\n";
    }
    await writeFile(builder);
    print('Successfully write to file');
  }

  addBasicRSS() async {
    String write =
        "Aljazeera,https://www.aljazeera.com/xml/rss/all.xml,true\nMalaysiaKini,https://www.malaysiakini.com/rss/en/news.rss,true\nUnited Nations,https://news.un.org/feed/subscribe/en/news/all/rss.xml,true";
    await writeFile(write);
    await readRSS(rssList);
    setState(() {});
  }

  emptyRssLink() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Looks like you dont have any RSS links. Click below to import 3 basic RSS links",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  await addBasicRSS();
                  print(rssList.length);
                  setState(() {});
                },
                child: const Text('Add Basic RSS'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  checkEmpty() {
    print(rssList.length);
    if (rssList.length == 0) {
      return emptyRssLink();
    } else {
      return FutureBuilder(
        future: readRSS(rssList),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('An Unexpected Error has Occured'));
              } else {
                return newsRSSBuilder();
              }
          }
        },
      );
    }
  }

  _saveAndPop() {
    writeToFile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _saveAndPop(),
        child: Scaffold(
          drawer: NavBar(),
          appBar: AppBar(
            title: Text("Main Menu"),
          ),
          body: checkEmpty(),

          /*FutureBuilder(
              future: readFile(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('An Unexpected Error has Occured'));
                    } else {
                      if (rssList.length == 0) {
                        return emptyRssLink();
                      } else {
                        return newsRSSBuilder();
                      }
                    }
                }
              },
            )*/
        ));
  }
}
*/