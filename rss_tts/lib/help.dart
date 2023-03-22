import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/ModifyRSS.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text("Help"),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.import_contacts),
                title: Text('Adding RSS Links'),
                contentPadding: EdgeInsets.all(5.0),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddRSS()));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Deleting RSS Links'),
                contentPadding: EdgeInsets.all(5.0),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DeleteRSS()));
                },
              ),
              ListTile(
                leading: Icon(Icons.question_mark),
                title: Text('Other FAQs'),
                contentPadding: EdgeInsets.all(5.0),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => FAQs()));
                },
              ),
            ],
          ),
        ));
  }
}

class DeleteRSS extends StatelessWidget {
  const DeleteRSS({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "How to Delete RSS Links",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 15),
                const Text(
                  "1. Open the nav bar on the top right of the screen",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "2. Open the Settings page",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "3. Open the Modify RSS Links option",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "4. Press the edit button on the RSS Link you would like to delete",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "5. Press the delete option from the pop up box",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
      ),
    );
  }
}

class AddRSS extends StatelessWidget {
  const AddRSS({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "How to import your own rss link",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 15),
                const Text(
                  "1. Open the nav bar on the top right of the screen",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "2. Open the Settings page",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "3. Open the Modify RSS Links option",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "4. Press the add button on the bottom right of the screen",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  "5. Press the pencil icon on the newly created RSS and input the name and RSS Link",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
      ),
    );
  }
}

class FAQs extends StatelessWidget {
  const FAQs({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What do the checkboxes do in the 'Modify RSS' Option?",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 15),
                const Text(
                  "- To enable/disable the rss in the main page",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 25),
                const Text(
                  "How to save RSS Feeds",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 15),
                const Text(
                  "- Just load the rss page and it will save articles at the time",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
              ],
            )),
      ),
    );
  }
}
/*
Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  const Text(
                    "How to import your own rss link",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "1. Open the nav bar on the top right of the screen",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "2. Open the Settings page",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "3. Open the Modify RSS Links option",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "4. Press the add button on the bottom right of the screen",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "5. Press the pencil icon on the newly created RSS and input the name and RSS Link",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ))
*/