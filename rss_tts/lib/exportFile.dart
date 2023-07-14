import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rss_tts/RSS_Feed.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:rss_tts/rss_mainmenu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/webfeed.dart';

List<newsRSS> rssList = [];
List<RssItem> feed = [];
List<String> newsPage = [];
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class exportFile extends StatefulWidget {
  const exportFile({super.key});
  State<exportFile> createState() => _exportFileState();
}

class _exportFileState extends State<exportFile> {
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

  Future<File> get _localFileHistory async {
    final path = await _localPath;
    return File('$path/viewed.txt');
  }

  Future<File> get _localFileSave async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<File> get _localFileSettings async {
    final path = await _localPath;
    return File('$path/settings.txt');
  }

  Future<File> writeFile(String s) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(s);
  }

  Future<File> writeFileSave(String s) async {
    final file = await _localFileSave;

    // Write the file
    return file.writeAsString(s);
  }

  Future<File> writeFileHistory(String s) async {
    final file = await _localFileHistory;

    // Write the file
    return file.writeAsString(s);
  }

  Future<File> writeFileSettings(String s) async {
    final file = await _localFileSettings;

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
          "Aljazeera,https://www.aljazeera.com/xml/rss/all.xml,true,false,en-US\nMalaysiaKini,https://www.malaysiakini.com/rss/en/news.rss,true,true,en-US\nUnited Nations,https://news.un.org/feed/subscribe/en/news/all/rss.xml,true,false,en-US";
      await writeFile(s);
      return s;
    }
  }

  Future<String> readFileSave() async {
    File file = await _localFileSave;
    if (await file.exists()) {
      try {
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      String s = "";
      await writeFile(s);
      return s;
    }
  }

  Future<String> readFileHistory() async {
    File file = await _localFileHistory;
    if (await file.exists()) {
      try {
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      String s = "";
      await writeFile(s);
      return s;
    }
  }

  Future<String> readFileSettings() async {
    File file = await _localFileSettings;
    if (await file.exists()) {
      try {
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      String s = "true";
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

  updateRssFile(List<newsRSS> rssList) async {
    String builder = '';
    for (int i = 0; i < rssList.length; i++) {
      builder +=
          '${rssList[i].newsTitle},${rssList[i].newsUrl},${rssList[i].enable.toString()},${rssList[i].login.toString()},${rssList[i].language}\n';
    }
    print(builder);

    writeFile(builder);
  }

  convertRssFeedToString(List<RssItem> feed) {
    String sb = '';

    for (int i = 0; i < feed.length; i++) {
      String title = feed[i].title ?? 'title';
      String url = feed[i].link ?? 'url';
      DateTime date = feed[i].pubDate!;
      String pubdate = dateFormat.format(date);
      sb = sb + newsPage[i] + ';,' + title + ';,' + url + ';,' + pubdate + "\n";
    }
    return sb;
  }

  addSavedFeed() async {
    List<String> viewedArticleList = [];

    String history = await readFileSave();
    String viewedList = await readFileHistory();
    print("=============");
    print(history);
    const splitter = LineSplitter();
    final savedList = splitter.convert(history);
    for (int i = 0; i < savedList.length; i++) {
      final rssData = savedList[i].split(';,');

      RssItem temp = new RssItem(
          author: '',
          title: rssData[1],
          link: rssData[2],
          pubDate: DateTime.parse(rssData[3]));
      feed.add(temp);
      newsPage.add(rssData[0]);
    }

    final savedListHistory = splitter.convert(viewedList);
    print(savedListHistory);

    for (int i = 0; i < feed.length; i++) {
      for (int j = 0; j < savedListHistory.length; j++) {
        if (feed[i].link == savedListHistory[j]) {
          print("============");
          print(newsPage[i]);
          print(feed[i].link);
          print(savedListHistory[j]);
          print("============");
          feed.removeAt(i);
          newsPage.removeAt(i);

          continue;
        }
      }
    }
  }

  deleteRead() async {
    await addSavedFeed();
    print("ToString...");
    await writeFileSave(convertRssFeedToString(feed));
    await writeFileHistory("");
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Success!'),
        content: const Text('Successfully cleared read articless'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  combineAllFiles() async {
    String temp = "ashhhasjdhjsadhhsadjbasd \n";
    String s = await readFile();
    String h = await readFileHistory();
    String v = await readFileSave();
    String se = await readFileSettings();
    temp = temp +
        s +
        "====================================\n" +
        h +
        "====================================\n" +
        v +
        "====================================\n" +
        se;
    print(temp);
    return temp;
  }

  importAllFiles(String s) async {
    LineSplitter ls = new LineSplitter();
    List<String> responseSplit = ls.convert(s);
    String temp = '';
    int state = 0;
    for (int i = 1; i < responseSplit.length; i++) {
      if (responseSplit[i] == "====================================") {
        print(temp);
        if (state == 0) {
          await writeFile(temp);
          state++;
        } else if (state == 1) {
          await writeFileHistory(temp);
          state++;
        } else if (state == 2) {
          await writeFileSave(temp);
          state++;
        }
        temp = '';
        continue;
      }
      temp = temp + responseSplit[i] + '\n';
    }
    print(temp);
    await writeFileSettings(temp);
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appstorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appstorage.path}/${file.name}');
    print('${appstorage.path}');
    return File(file.path!).copy(newFile.path);
  }

  _popUp() {
    rssList.clear();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> createFolder(String cow) async {
      final dir = Directory((Platform.isAndroid
                  ? await getExternalStorageDirectory() //FOR ANDROID
                  : await getApplicationSupportDirectory() //FOR IOS
              )!
              .path +
          '/$cow');
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if ((await dir.exists())) {
        print(dir.path);
        return dir.path;
      } else {
        dir.create();
        print(dir.path);
        return dir.path;
      }
    }

    alertWrite() async {
      await writeFileHistory("");
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success!'),
          content: const Text('Successfully cleared view history'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

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
                    return Container(
                      padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(Icons.import_contacts),
                            title: Text('Import file'),
                            contentPadding: EdgeInsets.all(5.0),
                            onTap: () async {
                              final result =
                                  await FilePicker.platform.pickFiles();
                              if (result == null) return;
                              final file = result.files.first;
                              if (file.extension != 'txt')
                                return showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Wrong file'),
                                    content: const Text(
                                        'File chosen was not a txt file'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );

                              final newFile = await saveFilePermanently(file);
                              String s = await newFile.readAsString();
                              print(s);
                              if (s.startsWith("ashhhasjdhjsadhhsadjbasd")) {
                                await importAllFiles(s);
                                return showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                        'Successfully imported all files'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Wrong file'),
                                    content: const Text(
                                        'File chosen was not a correct file'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              //await deleteRead();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.import_export_sharp),
                            title: Text('Export File'),
                            contentPadding: EdgeInsets.all(5.0),
                            onTap: () async {
                              final bytes = await combineAllFiles();
                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/combined.txt';
                              print("Success");
                              File(path).writeAsString(bytes);

                              final externalPath =
                                  await createFolder("RSS_TTS");
                              File("${externalPath}/combined.txt")
                                  .writeAsString(bytes);

                              print("Success");
                              await Share.shareFiles([path],
                                  text:
                                      'Here is the exported file for the RSS TTS Reader');
                              //await alertWrite();
                            },
                          ),
                        ],
                      ),
                    );
                  }
              }
            },
          ),
        ));
  }
}
