import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:rss_tts/RSS_Feed.dart';
import 'package:webfeed/domain/rss_feed.dart';

class newsRSS {
  String newsTitle = '';
  String newsUrl = '';
  newsRSS(a, b) {
    newsTitle = a;
    newsUrl = b;
  }
}

List<newsRSS> rssList = [];
readRSS() async {
  String response;
  response = await rootBundle.loadString('text/rss.txt');
  LineSplitter ls = new LineSplitter();
  List<String> responseSplit = ls.convert(response);
  for (int i = 0; i < responseSplit.length; i++) {
    final splitNames = responseSplit[i].split(',');
    print(splitNames);
    rssList.add(newsRSS(splitNames[0], splitNames[1]));
  }
}

newsRSSBuilder() {
  return ListView.builder(
      itemCount: rssList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(rssList[index].newsTitle),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsFeed(
                      title: rssList[index].newsTitle,
                      feedUrl: rssList[index].newsUrl,
                    )));
          },
        );
      });
}

_SaveAndBack() {
  rssList.clear();
}

class RSS_mainmenu extends StatelessWidget {
  const RSS_mainmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _SaveAndBack(),
        child: Scaffold(
            drawer: NavBar(),
            appBar: AppBar(
              title: Text("Main Menu"),
            ),
            body: FutureBuilder(
              future: readRSS(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('An Unexpected Error has Occured'));
                    } else {
                      return newsRSSBuilder();
                    }
                }
              },
            )));
  }
}
