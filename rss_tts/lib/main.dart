import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:rss_tts/RSS_Feed.dart';
import 'package:rss_tts/Settings.dart';
import 'package:rss_tts/WebView.dart';
import 'package:rss_tts/help.dart';
import 'package:rss_tts/rss_mainmenu.dart';
import 'package:flutter_background/flutter_background.dart';
import 'dart:io' show Platform;

Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());
  if (Platform.isAndroid) {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText:
          "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.hasPermissions;

    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Settings.getValue<bool>(SettingsPage.keyDarkMode, true);
    return ValueChangeObserver<bool>(
      cacheKey: SettingsPage.keyDarkMode,
      defaultValue: true,
      builder: (_, isDarkMode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const RSS_mainmenu(),
          '/settings': (context) => const SettingsPage(),
          '/help': (context) => const HelpPage(),
        },
      ),
    );
  }
}
