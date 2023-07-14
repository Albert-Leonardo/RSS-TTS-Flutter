import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/ModifyRSS.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:rss_tts/delete.dart';
import 'package:rss_tts/exportFile.dart';
import 'package:rss_tts/language.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = 'key-dark-mode';
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _time = 0.0;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/viewed.txt');
  }

  Future<File> get _localFileSave async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<File> get _localFileMark async {
    final path = await _localPath;
    return File('$path/mark.txt');
  }

  Future<File> writeFile(String s) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(s);
  }

  Future<File> writeFileMark(String s) async {
    final file = await _localFileMark;

    // Write the file
    return file.writeAsString(s);
  }

  Future<File> writeFileSave(String s) async {
    final file = await _localFileSave;

    // Write the file
    return file.writeAsString(s);
  }

  Future<String> readFileMark() async {
    File file = await _localFileMark;
    if (await file.exists()) {
      try {
        String contents = await file.readAsString();
        if (contents == '') {
          String s = "1";
          await writeFile(s);
          return s;
        }
        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      String s = "1";
      await writeFile(s);
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    alertWrite() {
      writeFile("");
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

    alertWriteSaved() {
      writeFileSave("");
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success!'),
          content: const Text('Successfully cleared Saved history'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    Future editOldTime(BuildContext context) async {
      int day = int.parse(await readFileMark());
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Mark Articles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mark articles older than a certain day as yellow (1-100)'),
              TextFormField(
                initialValue: day.toString(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  NumericalRangeFormatter(min: 1, max: 99),
                ],
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    hintText: "0-99",
                    border: InputBorder.none),
                onChanged: (String str) {
                  day = int.parse(str);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                print("test");
                Navigator.pop(context, 'OK');

                await writeFileMark(day.toString());
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    Widget buildDarkMode() => SwitchSettingsTile(
          settingKey: SettingsPage.keyDarkMode,
          leading: Icon(Icons.dark_mode),
          title: 'Dark mode',
          onChange: (isDarkMode) {},
        );

    Widget modifyRssSettings() => SimpleSettingsTile(
          title: 'Modify RSS Links',
          subtitle: '',
          leading: Icon(Icons.rss_feed),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ModifyRSS())),
        );
    Widget modifyTime(BuildContext context) => SimpleSettingsTile(
        title: 'Mark old feed color',
        subtitle: '',
        leading: Icon(Icons.timer),
        onTap: () async {
          await editOldTime(context);
        });
    Widget clearViewedCacheSettings() => SimpleSettingsTile(
          title: 'Delete Cache',
          subtitle: '',
          leading: Icon(Icons.delete),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => delete())),
        );

    Widget exportSettings() => SimpleSettingsTile(
          title: 'Import/Export Settings',
          subtitle: '',
          leading: Icon(Icons.import_export),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => exportFile())),
        );

    Widget languageSpeeds() => SimpleSettingsTile(
          title: 'Change Language Speeds',
          subtitle: '',
          leading: Icon(Icons.language),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => language())),
        );

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          SettingsGroup(
            title: 'GENERAL',
            children: <Widget>[
              buildDarkMode(),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          SettingsGroup(title: "Rss Links", children: <Widget>[
            modifyRssSettings(),
            modifyTime(context),
            clearViewedCacheSettings(),
            exportSettings(),
          ]),
          SettingsGroup(title: "Language", children: <Widget>[languageSpeeds()])
        ],
      )),
    );
  }
}
