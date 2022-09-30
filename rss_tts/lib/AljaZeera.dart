import 'package:flutter/material.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class AljaZeera extends StatefulWidget {
  const AljaZeera({super.key, required this.title});
  final String title;
  @override
  State<AljaZeera> createState() => _AljaZeeraState();
}

class _AljaZeeraState extends State<AljaZeera> {
  static const String FEED_URL = 'https://www.aljazeera.com/xml/rss/all.xml';
  late RssFeed _feed;
  late String _title;
  static const String loadingFeedMsg = 'Loading Feed. . .';
  static const String feedLoadErr = 'Error Loading Feed';
  late GlobalKey<RefreshIndicatorState> _refreshKey;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      return RssFeed.parse(response.body);
    } catch (e) {}
    return null;
  }

  load() async {
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErr);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title);
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
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
            //
          },
        );
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: listNews(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: body(),
      ),
    );
  }
}
