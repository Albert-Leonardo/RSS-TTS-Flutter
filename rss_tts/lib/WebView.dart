import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:rss_tts/rss_mainmenu.dart';

class WebView extends StatefulWidget {
  const WebView(
      {super.key,
      required this.title,
      required this.newsUrl,
      required this.rss});
  final String? title;
  final String? newsUrl;
  final newsRSS rss;

  @override
  State<WebView> createState() => _WebViewState();
}

stringConverter(String? s) {
  String nonNullableString = s ?? 'default';
  return nonNullableString;
}

class _WebViewState extends State<WebView> {
  List<String> TTS = [];
  queryString() {
    if (widget.rss.newsUrl.contains('aljazeera'))
      return 'div > p';
    else if (widget.rss.newsUrl.contains('news.un.org'))
      return 'div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > p:';
    else
      return 'p';
  }

  Future getWebsiteData() async {
    final url = Uri.parse(stringConverter(widget.newsUrl));
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final news = html
        .querySelectorAll(queryString())
        .map((e) => e.innerHtml.trim())
        .toList();
    print('Count: ${news.length}');
    for (final p in news) {
      TTS.add(p.replaceAll(RegExp(r"<\\?.*?>"), ""));
    }
    print(TTS);
  }

  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(stringConverter(widget.title)),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform:
                      InAppWebViewOptions(transparentBackground: true)),
              initialUrlRequest:
                  URLRequest(url: Uri.parse(stringConverter(widget.newsUrl))),
              onWebViewCreated: (InAppWebViewController controller) {
                print("Lollllllllllll");
                getWebsiteData();
                webView = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                /*if (progress >= 80) {
                  print("Lol22222222222222222222");
                  String? htmlString = '';
                  controller.getHtml().then((value) => htmlString = value);
                  dom.Document html = dom.Document.html(htmlString!);
                  final news = html
                      .querySelectorAll('p')
                      .map((e) => e.innerHtml.trim())
                      .toList();
                  print('Count: ${news.length}');
                  for (final title in news) {
                    debugPrint(title);
                  }
                }
                */
                setState(() {
                  _progress = progress / 100;
                });
              },
              onLoadStop: (controller, url) {},
            ),
            _progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(value: _progress),
                  )
                : SizedBox()
          ],
        ));
  }
}
