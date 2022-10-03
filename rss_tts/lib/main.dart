import 'package:flutter/material.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:rss_tts/RSS_Feed.dart';
import 'package:rss_tts/Settings.dart';
import 'package:rss_tts/rss_mainmenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const RSS_mainmenu(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
