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
import 'package:rss_tts/WebViewLogin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

List<newsRSS> rssList = [];

class ModifyRSS extends StatefulWidget {
  const ModifyRSS({super.key});
  State<ModifyRSS> createState() => _ModifyRSSState();
}

class _ModifyRSSState extends State<ModifyRSS> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController urlController = TextEditingController();
  late bool _checked;

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
          "Aljazeera,https://www.aljazeera.com/xml/rss/all.xml,true,false,en-US\nMalaysiaKini,https://www.malaysiakini.com/rss/en/news.rss,true,true,en-US\nUnited Nations,https://news.un.org/feed/subscribe/en/news/all/rss.xml,true,false,en-US\nMalaysiaKiniBM,https://www.malaysiakini.com/rss/my/news.rss,true,false,ms-MY";
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
          splitNames[0],
          splitNames[1],
          splitNames[2].toLowerCase() == 'true',
          splitNames[3].toLowerCase() == 'true',
          splitNames[4]));
    }
  }

  checkLanguage(String s) {
    if (s == 'English')
      return 'en-US';
    else if (s == 'Bahasa')
      return 'ms-MY';
    else if (s == 'Chinese')
      return 'zh-TW';
    else if (s == 'Korean')
      return 'ko-KR';
    else if (s == 'Japanese')
      return 'ja-JP';
    else if (s == 'Russian')
      return 'ru-RU';
    else if (s == 'Hungarian')
      return 'hu-HU';
    else if (s == 'Thai')
      return 'th-TH';
    else if (s == 'Norwegian Bokmal')
      return 'nb-no';
    else if (s == 'Turkish')
      return 'tr-TR';
    else if (s == 'Estonian')
      return 'et-EE';
    else if (s == 'Swahili')
      return 'sw';
    else if (s == 'Portuguese ')
      return 'pt-PT';
    else if (s == 'Vietnamese')
      return 'vi-VN';
    else if (s == 'Swedish')
      return 'sv-VE';
    else if (s == 'Hindi')
      return 'hi-IN';
    else if (s == 'French')
      return 'fr-FR';
    else if (s == 'Dutch')
      return 'nl-NL';
    else if (s == 'Czech')
      return 'cs-CZ';
    else if (s == 'Polish')
      return 'pl-PL';
    else if (s == 'Filipino')
      return 'fil-PH';
    else if (s == 'Italian')
      return 'it-IT';
    else if (s == 'Spanish') return 'es-ES';
  }

  checkLanguageBack(String s) {
    if (s == 'en-US')
      return 'English';
    else if (s == 'ms-MY')
      return 'Bahasa';
    else if (s == 'zh-TW')
      return 'Chinese';
    else if (s == 'ko-KR')
      return 'Korean';
    else if (s == 'ja-JP')
      return 'Japanese';
    else if (s == 'ru-RU')
      return 'Russian';
    else if (s == 'hu-HU')
      return 'Hungarian';
    else if (s == 'th-TH')
      return 'Thai';
    else if (s == 'nb-no')
      return 'Norwegian Bokmal';
    else if (s == 'tr-TR')
      return 'Turkish';
    else if (s == 'et-EE')
      return 'Estonian';
    else if (s == 'sw')
      return 'Swahili';
    else if (s == 'pt-PT')
      return 'Portuguese';
    else if (s == 'vi-VN')
      return 'Vietnamese';
    else if (s == 'sv-VE')
      return 'Swedish';
    else if (s == 'hi-IN')
      return 'Hindi';
    else if (s == 'fr-FR')
      return 'French';
    else if (s == 'nl-NL')
      return 'Dutch';
    else if (s == 'cs-CZ')
      return 'Czech';
    else if (s == 'pl-PL')
      return 'Polish';
    else if (s == 'fil-PH')
      return 'Filipino';
    else if (s == 'it-IT')
      return 'Italian';
    else if (s == 'es-ES') return 'Spanish';
  }

  updateRssFile(List<newsRSS> rssList) async {
    String builder = '';
    for (int i = 0; i < rssList.length; i++) {
      builder +=
          '${rssList[i].newsTitle},${rssList[i].newsUrl},${rssList[i].enable.toString()},${rssList[i].login.toString()},${rssList[i].language}\n';
    }
    print(builder);

    writeFile(builder);
  }

  Future editRssDialog(int index) async {
    const List<String> list = <String>[
      'English',
      'Bahasa',
      'Chinese',
      'Korean',
      'Japanese',
      'Russian',
      'Hungarian',
      'Thai',
      'Norwegian Bokmal',
      'Turkish',
      'Estonian',
      'Swahili',
      'Portuguese',
      'Vietnamese',
      'Swedish',
      'Hindi',
      'French',
      'Dutch',
      'Czech',
      'Polish',
      'Filipino',
      'Italian',
      'Spanish'
    ];

    String dropdownValue = checkLanguageBack(rssList[index].language);
    nameController.text = rssList[index].newsTitle;
    urlController.text = rssList[index].newsUrl;
    _checked = rssList[index].login;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                    ),
                    CheckboxListTile(
                      title: Text("Website with Login?"),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _checked,
                      onChanged: (bool? value) {
                        setState(() {
                          _checked = value!;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Language:',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          alignment: Alignment.centerLeft,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                  ]));
                },
              ),
              title: Text('Edit RSS'),
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
                      rssList[index].login = _checked;
                      rssList[index].language = checkLanguage(dropdownValue);
                      nameController.clear();
                      urlController.clear();

                      Navigator.of(context).pop();
                      if (_checked == true) {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Login to website'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'You have just added/edited a login RSS feed'),
                                    Text('Would you like to login first??'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    RssFeed _feed;
                                    final client = http.Client();
                                    final response = await client
                                        .get(Uri.parse(rssList[index].newsUrl));
                                    _feed = RssFeed.parse(response.body);
                                    print("LOLeksdee");
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => WebViewLogin(
                                                  RSSLink: _feed.items![0].link
                                                      as String,
                                                  websiteName:
                                                      rssList[index].newsTitle,
                                                )));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
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
                rssList.add(newsRSS('', '', true, false, 'en'));
                updateRssFile(rssList);
              });
            },
          ),
        ));
  }
}
