// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rss_tts/Settings.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;

import 'package:rss_tts/main.dart';

// ignore: use_key_in_widget_constructors
class NavBar extends StatelessWidget {
  void navigateRoute(String? origin, String destination, BuildContext context) {
    if (origin == destination) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Timer(Duration(milliseconds: 90),
          () => {Navigator.of(context).pushReplacementNamed(destination)});
    }
  }

  void exitApp() {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (Platform.isIOS) {}
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text('RSS TTS'),
            decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://wallpaperaccess.com/full/1261770.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              var route = ModalRoute.of(context);
              if (route != null) {
                String? origin = route.settings.name;
                navigateRoute(origin, '/home', context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              var route = ModalRoute.of(context);
              if (route != null) {
                String? origin = route.settings.name;
                navigateRoute(origin, '/settings', context);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            // ignore: avoid_returning_null_for_void
            onTap: () => exitApp(),
          ),
        ],
      ),
    );
  }
}
