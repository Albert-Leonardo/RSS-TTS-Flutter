import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:rss_tts/WebView.dart';
import 'package:rss_tts/rss_mainmenu.dart';
import 'dart:async';
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

  Future<String> readFileSave() async {
    File file = await _localFileSave;
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

  checkColor(RssItem item) {
    DateTime d1 = item.pubDate as DateTime;
    DateTime d2 = DateTime.now().subtract(const Duration(days: 1));
    if (viewed.contains(item.link)) {
      return Color.fromARGB(255, 188, 132, 237);
    } else if (d1.isBefore(d2)) {
      print(d1.toString());
      print(d2.toString());
      print("----------------------");
      return Color.fromARGB(255, 207, 221, 51);
    } else {
      return Theme.of(context).textTheme.bodyText2?.color;
    }
  }

  convertRssFeedToString(RssFeed _feed) {
    String sb = '';

    for (int i = 0; i < _feed.items!.length; i++) {
      String title = _feed.items![i].title ?? 'title';
      String url = _feed.items![i].link ?? 'url';
      DateTime date = _feed.items![i].pubDate!;
      String pubdate = dateFormat.format(date);
      sb = sb +
          widget.rss.newsTitle +
          ';,' +
          title +
          ';,' +
          url +
          ';,' +
          pubdate +
          "\n";
    }
    print(sb);
    return sb;
  }

  late RssFeed _feed;
  late String _title;
  late String _saved;
  static const String loadingFeedMsg = 'Loading Feed. . .';
  static const String feedLoadErr = 'Error Loading Feed';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  addSavedFeed() {
    const splitter = LineSplitter();
    final savedList = splitter.convert(_saved);
    print(savedList);
    for (int i = 0; i < savedList.length; i++) {
      final rssData = savedList[i].split(';,');
      print("Data " + i.toString() + ': ' + rssData[1]);
      if (rssData[0] == widget.rss.newsTitle) {
        print("Data " + i.toString() + ': ' + rssData[2]);
        RssItem temp = new RssItem(
            author: '',
            title: rssData[1],
            link: rssData[2],
            pubDate: DateTime.parse(rssData[3]));
        _feed.items!.add(temp);
      }
    }
  }

  Future loadFeed() async {
    print("Load Feed initiated");
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(widget.rss.newsUrl));
      _feed = RssFeed.parse(response.body);
      await checkViewed();
      _saved = await readFileSave();
      print("====================SAVED BEFORE ====================");
      print(_saved);

      print("==============Start OF FEED=============");
      for (int i = 0; i < _feed.items!.length; i++) {
        String stringChecker = _feed.items![i].title as String;

        if (_saved.contains(stringChecker)) {
          print("LINKKKKKK ==== " + stringChecker);
          _feed.items!.removeAt(i);
          i--;
        }
      }
      _saved = convertRssFeedToString(_feed) + _saved;
      print(convertRssFeedToString(_feed));
      print("==============END OF FEED=============");
      //_saved = convertRssFeedToString(_feed) + _saved;
      //_saved = '';
      print(_saved);
      await writeFileSave(_saved);

      addSavedFeed();
      return 1;
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

  String _now = '';
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();
    updateTitle(widget.rss.newsTitle);
    // sets first value
    _now = DateTime.now().second.toString();

    // defines a timer
  }

  void _update(int count) {
    setState(() {
      _now = DateTime.now().second.toString();
    });
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
          textColor: checkColor(item),
          subtitle: newsDate(dateFormat.format(item.pubDate as DateTime)),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WebView(
                      rss: widget.rss,
                      feed: _feed,
                      index: isNewest ? index : _feed.items!.length - index - 1,
                      isNewest: isNewest,
                      update: _update,
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
