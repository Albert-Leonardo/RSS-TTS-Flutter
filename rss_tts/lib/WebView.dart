import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/NavBar.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:rss_tts/main.dart';
import 'package:rss_tts/rss_mainmenu.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:webfeed/domain/rss_feed.dart';

class WebView extends StatefulWidget {
  WebView(
      {super.key,
      required this.rss,
      required this.feed,
      required this.index,
      required this.isNewest});
  final newsRSS rss;
  final int index;
  RssFeed feed;
  final bool isNewest;
  @override
  State<WebView> createState() => _WebViewState();
}

stringConverter(String? s) {
  String nonNullableString = s ?? 'default';
  return nonNullableString;
}

class _WebViewState extends State<WebView> {
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

  saveNext() {
    viewed.add(widget.feed.items![widget.index + 1].link as String);
  }

  savePrevious() {
    viewed.add(widget.feed.items![widget.index - 1].link as String);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopSpeak();
    TTS = [];
    ttsIndex = 0;
    checkPlay = true;
    playerVisibility = true;
    readed = 0;
    startRSS = true;
    canGoNext = false;
    loadOnce = false;
    loadFinish = false;
    mainPage = 0;
    checkViewed();
  }

  final FlutterTts flutterTts = FlutterTts();

  speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage('en-UN');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  stopSpeak() async {
    await flutterTts.stop();
  }

  nextPage() async {
    checkPlay = false;
    player();

    checkPlay = true;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WebView(
              rss: widget.rss,
              feed: widget.feed,
              index: widget.index + 1,
              isNewest: widget.isNewest,
            )));
    setState(() {
      saveNext();
      writeFile(writeViewed());
    });
    checkPlay = true;
  }

  previousPage() {
    checkPlay = false;
    player();
    checkPlay = true;

    Navigator.pop(context);
    setState(() {
      savePrevious();
      writeFile(writeViewed());
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebView(
              rss: widget.rss,
              feed: widget.feed,
              index: widget.index - 1,
              isNewest: widget.isNewest,
            )));

    checkPlay = true;
  }

  player() async {
    while (ttsIndex < TTS.length) {
      if (checkPlay == true) {
        await speak(TTS[ttsIndex]);
        ttsIndex++;
        print("Index: " + ttsIndex.toString());
        print("TTSLENGTH: " + TTS.length.toString());

        if (canGoNext && ttsIndex == TTS.length) {
          print("iaugysufdchgvhjbhuoasy8dg7fyucgvhjbsad");
          nextPage();
        }
      } /*else if (checkPlay == true && widget.rss.login) {
        if (loadFinish) {
          await speak(TTS[ttsIndex]);
          ttsIndex++;
          print("Index: " + ttsIndex.toString());
          print("TTSLENGTH: " + TTS.length.toString());
          if (canGoNext && ttsIndex == TTS.length) {
            //nextPage();
            print("NEXT PAGEEEE");
          }
        }
      }*/
      else if (checkPlay == false) {
        stopSpeak();
        break;
      }
    }
  }

  List<String> TTS = [];
  int ttsIndex = 0;
  bool checkPlay = true;
  bool playerVisibility = true;
  bool startRSS = true;
  bool canGoNext = false;
  int readed = 0;
  bool loadFinish = false;
  bool loadOnce = false;
  int mainPage = 0;

  queryString() {
    if (widget.rss.newsUrl.contains('aljazeera')) {
      return 'main > div > ul > li, div > p ';
    } else if (widget.rss.newsUrl.contains('news.un.org'))
      return 'div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > p:';
    else
      return 'p';
  }

  Future getWebsiteData() async {
    if (!widget.rss.login) {
      final url =
          Uri.parse(stringConverter(widget.feed.items![widget.index].link));
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);
      final news = html
          .querySelectorAll(queryString())
          .map((e) => e.innerHtml.trim())
          .toList();
      print('Count: ${news.length}');
      TTS.add(widget.feed.items![widget.index].title as String);
      for (String p in news) {
        p = p.replaceAll(RegExp(r"<\\?.*?>"), "");
        p = p.replaceAll("&nbsp", " ");
        print(p);
        final pp = p.split('. ');
        TTS = TTS + pp;
      }
      print(TTS);
    } else {
      TTS.add(widget.feed.items![widget.index].title as String);
    }
  }

  _popUp() {
    print("Popup");
  }

  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 9;
    return WillPopScope(
        onWillPop: _popUp(),
        child: Scaffold(
            appBar: AppBar(
              title:
                  Text(stringConverter(widget.feed.items![widget.index].title)),
            ),
            body: Stack(
              children: [
                InAppWebView(
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          transparentBackground: true,
                          javaScriptEnabled: true)),
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(stringConverter(
                          widget.feed.items![widget.index].link))),
                  onWebViewCreated: (InAppWebViewController controller) async {
                    print("Lollllllllllll");
                    await getWebsiteData();
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
                    if (startRSS && !widget.rss.login) {
                      if (progress > 50) {
                        player();
                        startRSS = false;
                      }
                    }
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (_, Uri? uri, __) {
                    mainPage++;

                    print("VISITEDDDDDDDDDDDDDDDDDDDD: " + mainPage.toString());
                  },
                  onLoadStop: (controller, url) async {
                    checkPlay = true;
                    startRSS = true;
                    if (mainPage <= 2) {
                      if (widget.rss.login) {
                        print(
                            "=================================================");
                        var response = await controller.evaluateJavascript(
                            source: "document.documentElement.innerText;");
                        LineSplitter ls = new LineSplitter();
                        List<String> responseSplit = ls.convert(response);
                        print(responseSplit);
                        responseSplit.removeRange(
                            responseSplit.length - 5, responseSplit.length);
                        List<String> newResponse = [];
                        for (String p in responseSplit) {
                          p = p.replaceAll(r'ADS', '');
                          if (p.startsWith("#")) continue;
                          print(p);
                          newResponse.add(p);
                        }
                        TTS = newResponse;
                        loadFinish = true;
                        print(
                            "=================================================");
                        print("TTS LENGTH:" + TTS.length.toString());
                        canGoNext = true;
                        print(TTS);

                        if (loadOnce) {
                          await player();
                        }
                        if (!loadOnce) loadOnce = !loadOnce;
                      }
                    }
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
                            icon: Icon(Icons.skip_previous),
                            iconSize: screenWidth,
                            color: Colors.blue,
                            onPressed: () {
                              if (widget.isNewest) {
                                if (widget.index >= 1) previousPage();
                              } else {
                                if (!(widget.feed.items?.length ==
                                    widget.index + 1)) nextPage();
                              }
                            },
                          ),
                          IconButton(
                            iconSize: screenWidth,
                            color: Colors.blue,
                            onPressed: () async {
                              checkPlay = false;
                              await player();
                              if (ttsIndex >= 1) ttsIndex--;
                              checkPlay = true;
                              await player();
                            },
                            icon: Icon(
                              Icons.fast_rewind,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                  checkPlay ? Icons.pause : Icons.play_arrow),
                              iconSize: screenWidth + 10,
                              color: Colors.blue[800],
                              onPressed: () {
                                setState(() {
                                  checkPlay = !checkPlay;
                                  player();
                                });
                              }),
                          IconButton(
                            iconSize: screenWidth,
                            color: Colors.blue,
                            onPressed: () async {
                              checkPlay = false;
                              await player();
                              ttsIndex++;
                              checkPlay = true;
                              await player();
                            },
                            icon: Icon(
                              Icons.fast_forward,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            iconSize: screenWidth,
                            color: Colors.blue,
                            onPressed: () {
                              if (widget.isNewest) {
                                if (!(widget.feed.items?.length ==
                                    widget.index + 1)) nextPage();
                              } else {
                                if (widget.index >= 1) previousPage();
                              }
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              iconSize: screenWidth,
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
                      alignment: Alignment.bottomRight,
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
