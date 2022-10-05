import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const keyDarkMode = 'key-dark-mode';
  Widget buildDarkMode() => SwitchSettingsTile(
        settingKey: keyDarkMode,
        leading: Icon(Icons.dark_mode),
        title: 'Dark mode',
        onChange: (isDarkMode) {},
      );
  @override
  Widget build(BuildContext context) {
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
          )
        ],
      )),
    );
  }
}
