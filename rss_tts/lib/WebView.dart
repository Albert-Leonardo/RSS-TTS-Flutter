import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:rss_tts/rss_mainmenu.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  stopSpeak() async {
    await flutterTts.stop();
  }

  player() async {
    while (ttsIndex < TTS.length) {
      if (checkPlay == true) {
        await speak(TTS[ttsIndex]);
        ttsIndex++;
      } else if (checkPlay == false) {
        stopSpeak();
        break;
      }
    }
  }

  List<String> TTS = [];
  int ttsIndex = 0;
  bool checkPlay = true;
  bool playerVisibility = true;
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

  _popUp() {
    print("Popup");
  }

  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _popUp(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(stringConverter(widget.title)),
            ),
            body: Stack(
              children: [
                InAppWebView(
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform:
                          InAppWebViewOptions(transparentBackground: true)),
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(stringConverter(widget.newsUrl))),
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
                    if (progress > 70) {
                      player();
                    }
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  onLoadStop: (controller, url) {
                    //player();
                  },
                ),
                _progress < 1
                    ? SizedBox(
                        height: 3,
                        child: LinearProgressIndicator(value: _progress),
                      )
                    : SizedBox(),
                if (playerVisibility)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 62.0,
                            color: Colors.blue,
                            onPressed: () {},
                            icon: Icon(
                              Icons.skip_previous,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                  checkPlay ? Icons.pause : Icons.play_arrow),
                              iconSize: 62.0,
                              color: Colors.blue[800],
                              onPressed: () {
                                setState(() {
                                  checkPlay = !checkPlay;
                                  player();
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.skip_next),
                              iconSize: 62.0,
                              color: Colors.blue,
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              iconSize: 62.0,
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  playerVisibility = !playerVisibility;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                if (!playerVisibility)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).bottomAppBarColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 30.0,
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      playerVisibility = !playerVisibility;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_up,
                                  ),
                                ),
                              ])))
              ],
            )));
  }
}
