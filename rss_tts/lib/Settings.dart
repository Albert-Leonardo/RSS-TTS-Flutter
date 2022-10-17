import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/ModifyRSS.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/viewed.txt');
  }

  Future<File> writeFile(String s) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(s);
  }

  const SettingsPage({super.key});
  static const keyDarkMode = 'key-dark-mode';

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

    Widget buildDarkMode() => SwitchSettingsTile(
          settingKey: keyDarkMode,
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
    Widget clearViewedCacheSettings() => SimpleSettingsTile(
        title: 'Clear Viewed Cache',
        subtitle: '',
        leading: Icon(Icons.delete),
        onTap: () => alertWrite());
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
            clearViewedCacheSettings()
          ])
        ],
      )),
    );
  }
}
