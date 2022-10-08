import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rss_tts/RSS_Feed.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:rss_tts/rss_mainmenu.dart';
import 'package:path_provider/path_provider.dart';

List<newsRSS> rssList = [];

class ModifyRSS extends StatefulWidget {
  const ModifyRSS({super.key});
  State<ModifyRSS> createState() => _ModifyRSSState();
}

class _ModifyRSSState extends State<ModifyRSS> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController urlController = TextEditingController();

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

  updateRssFile(List<newsRSS> rssList) async {
    String builder = '';
    for (int i = 0; i < rssList.length; i++) {
      builder +=
          '${rssList[i].newsTitle},${rssList[i].newsUrl},${rssList[i].enable.toString()}\n';
    }
    print(builder);

    writeFile(builder);
  }

  Future editRssDialog(int index) async {
    nameController.text = rssList[index].newsTitle;
    urlController.text = rssList[index].newsUrl;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit RSS'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Website name:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Website name'),
                  controller: nameController,
                ),
                const SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Website url:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Website Url'),
                  controller: urlController,
                )
              ]),
              actions: [
                TextButton(
                    onPressed: () {
                      rssList.removeAt(index);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      rssList[index].newsTitle = nameController.text;
                      rssList[index].newsUrl = urlController.text;
                      nameController.clear();
                      urlController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('CONFIRM')),
              ],
            ));
  }

  modRSS() {
    return ListView.builder(
        itemCount: rssList.length,
        itemBuilder: (BuildContext context, int index) {
          bool? _isSelected = rssList[index].enable;
          return CheckboxListTile(
            secondary: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await editRssDialog(index);
                setState(() {
                  updateRssFile(rssList);
                });
              },
            ),
            title: Text(rssList[index].newsTitle),
            value: _isSelected,
            onChanged: (bool? newValue) {
              setState(() {
                _isSelected = newValue;
                rssList[index].enable = newValue!;
                updateRssFile(rssList);
              });
            },
          );
        });
  }

  _popUp() {
    rssList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _popUp(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit RSS"),
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
                    return modRSS();
                  }
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                rssList.add(newsRSS('', '', true));
                updateRssFile(rssList);
              });
            },
          ),
        ));
  }
}
