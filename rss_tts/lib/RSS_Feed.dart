import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:rss_tts/WebView.dart';
import 'package:rss_tts/rss_mainmenu.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key, required this.rss});
  final newsRSS rss;
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  bool isNewest = true;
  late List<String> viewed;
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

  Future<String> readFile() async {
    File file = await _localFile;
    if (await file.exists()) {
      try {
        print("exists");
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      print("no exists");
      String s = "";
      await writeFile(s);
      return s;
    }
  }

  checkViewed() async {
    String s = await readFile();
    LineSplitter ls = new LineSplitter();
    List<String> responseSplit = ls.convert(s);
    viewed = responseSplit;
  }

  writeViewed() {
    String s = '';
    for (String ss in viewed) {
      s += ss + '\n';
    }
    return s;
  }

  late RssFeed _feed;
  late String _title;
  static const String loadingFeedMsg = 'Loading Feed. . .';
  static const String feedLoadErr = 'Error Loading Feed';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  Future loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(widget.rss.newsUrl));
      _feed = RssFeed.parse(response.body);
      await checkViewed();
      return RssFeed.parse(response.body);
    } catch (e) {
      throw new FormatException('thrown-error');
    }
    return null;
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  @override
  void initState() {
    super.initState();
    updateTitle(widget.rss.newsTitle);
    setState(() {});
  }

  newsTitle(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  newsDate(date) {
    return Text(
      date,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  listNews() {
    return ListView.builder(
      itemCount: _feed.items?.length,
      itemBuilder: (BuildContext context, int index) {
        final sortedItems =
            isNewest ? _feed.items : _feed.items?.reversed.toList();
        final item = sortedItems![index];
        return ListTile(
          title: newsTitle(item.title),
          textColor: viewed.contains(item.link)
              ? Color.fromARGB(255, 188, 132, 237)
              : Theme.of(context).textTheme.bodyText2?.color,
          subtitle: newsDate(dateFormat.format(item.pubDate as DateTime)),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WebView(
                      rss: widget.rss,
                      feed: _feed,
                      index: isNewest ? index : _feed.items!.length - index - 1,
                      isNewest: isNewest,
                    )));

            setState(() {
              viewed.add(item.link as String);
              writeFile(writeViewed());
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                  onPressed: () => setState(() => isNewest = !isNewest),
                  icon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.compare_arrows, size: 28),
                  ),
                  label: Text(
                    isNewest ? 'Newest' : 'Oldest',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
            Expanded(
                child: FutureBuilder(
              future: loadFeed(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('An Unexpected Error has Occured'));
                    } else {
                      return listNews();
                    }
                }
              },
            ))
          ],
        ));
  }
}
