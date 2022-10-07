import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rss_tts/ModifyRSS.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) {
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
          SettingsGroup(
              title: "Rss Links", children: <Widget>[modifyRssSettings()])
        ],
      )),
    );
  }
}
