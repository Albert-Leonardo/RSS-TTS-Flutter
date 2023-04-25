import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/ModifyRSS.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:rss_tts/delete.dart';
import 'package:rss_tts/exportFile.dart';

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
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(mainAxisSize: MainAxisSize.min, children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Days :',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, state) => Center(
                          child: Slider(
                            value: _time,
                            onChanged: (val) {
                              state(() {
                                _time = val;
                              });
                            },
                          ),
                        ),
                      )
                    ]);
                  },
                ),
                title: Text('Edit RSS'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('CONFIRM')),
                ],
              ));
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
          ])
        ],
      )),
    );
  }
}
