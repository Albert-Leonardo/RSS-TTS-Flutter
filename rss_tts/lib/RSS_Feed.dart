import 'package:flutter/material.dart';
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
        final item = _feed.items![index];
        return ListTile(
          title: newsTitle(item.title),
          subtitle: newsDate(dateFormat.format(item.pubDate as DateTime)),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30.0,
          ),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WebView(
                      title: item.title,
                      newsUrl: item.link,
                      rss: widget.rss,
                    )));
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
        body: FutureBuilder(
          future: loadFeed(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('An Unexpected Error has Occured'));
                } else {
                  return listNews();
                }
            }
          },
        ));
  }
}
