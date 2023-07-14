import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_background/flutter_background.dart';
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
      required this.isNewest,
      required this.update,
      required this.updateIndex,
      required this.readingIndex,
      required this.continueBool,
      required this.languageSpeeds});
  final ValueChanged<String> update;
  final ValueChanged<int> updateIndex;
  final newsRSS rss;
  int readingIndex;
  int index;
  bool continueBool;
  RssFeed feed;
  final bool isNewest;
  bool _visible1 = true;
  bool _visible2 = false;
  InAppWebViewController? _controller1;
  InAppWebViewController? _controller2;
  late Map<String, double> languageSpeeds;
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
        String contents = await file.readAsString();
        return contents;
      } catch (e) {
        // If encountering an error, return 0
        return '0';
      }
    } else {
      String s = "";
      await writeFile(s);
      return s;
    }
  }

  checkViewed() async {
    if (!FlutterBackground.isBackgroundExecutionEnabled) {
      await FlutterBackground.enableBackgroundExecution();
    }
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
    viewed.add(widget.feed.items![widget.index].link as String);
  }

  savePrevious() {
    viewed.add(widget.feed.items![widget.index].link as String);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopSpeak();
    TTS = [[], []];
    if (widget.continueBool) {
      ttsIndex = widget.readingIndex;
      widget.continueBool = false;
    } else
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
    await flutterTts.setLanguage(widget.rss.language);
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(widget.languageSpeeds[widget.rss.language]!);
    await flutterTts.speak(text);
  }

  testTTS() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage('en-UN');
    await flutterTts.setPitch(1);
    await flutterTts.speak("Hello this is a TTS test");
  }

  stopSpeak() {
    flutterTts.stop();
  }

  nextPage() async {
    nextPageCheck = true;
    checkPlay = false;
    await player1();
    await player2();
    print(TTS[0]);
    print(TTS[1]);
    print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
    setState(() {
      saveNext();
      writeFile(writeViewed());
    });
    print("Widget is : ${widget.rss.login}");
    if (widget.feed.items?.length == widget.index + 1) {
      return null;
    }
    if (widget.index == -1) {
      return null;
    }

    if (widget.isNewest) {
      print("PUSHHHHHHHHHHHHHHHH!");
      widget.index++;
      if (widget._visible1) {
        setState(() {
          TTS[0] = [];
          widget._visible1 = !widget._visible1;
          widget._visible2 = !widget._visible2;
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller1!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index + 1].link.toString())));
        });
      } else {
        TTS[1] = [];
        setState(() {
          widget._visible1 = !widget._visible1;
          widget._visible2 = !widget._visible2;
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller2!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index + 1].link.toString())));
        });
      }
      print("VISIBLE1&2: ${widget._visible1}${widget._visible2}");
      if (!widget.rss.login && widget._visible1) getWebsiteData2(1);
      if (!widget.rss.login && widget._visible2) getWebsiteData1(1);

      ttsIndex = 0;
      checkPlay = true;
      playerVisibility = true;
      readed = 0;
      startRSS = true;
      canGoNext = false;
      loadOnce = false;
      loadFinish = false;
      mainPage = 0;
      loadOnce2 = false;

      checkViewed();
      print(TTS[0]);
      print(TTS[1]);
      print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
      print("CHANGED!!!");
      if (widget.rss.login) stopSpeak();
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WebView(
              rss: widget.rss,
              feed: widget.feed,
              index: widget.index + 1,
              isNewest: widget.isNewest,
            )));*/
      if (!widget.rss.login) {
        checkPlay = true;
        if (widget._visible1)
          await player1();
        else
          await player2();
        print("Nologin");
      }
      if (widget.rss.login) {
        if (widget._visible1)
          await player1();
        else
          await player2();
        checkPlay = true;
      }
      print(TTS[0]);
      print(TTS[1]);
      print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
    } else {
      print("PUSHHHHHHHHHHHHHHHH!");
      widget.index++;
      if (widget._visible1) {
        setState(() {
          TTS[0] = [];
          TTS[1] = [];
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller1!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index].link.toString())));
          widget._controller2!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index + 1].link.toString())));
        });
      } else {
        setState(() {
          TTS[1] = [];
          TTS[0] = [];
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller2!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index].link.toString())));
          widget._controller1!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index + 1].link.toString())));
        });
      }
      stopSpeak();

      ttsIndex = 0;
      checkPlay = true;
      playerVisibility = true;
      readed = 0;
      startRSS = true;
      canGoNext = false;
      loadOnce = false;
      loadFinish = false;
      mainPage = 0;
      loadOnce2 = false;

      checkViewed();
      if (!widget.rss.login && widget._visible1) {
        await getWebsiteData2(1);
        await getWebsiteData1(0);
      }
      if (!widget.rss.login && widget._visible2) {
        await getWebsiteData1(1);
        await getWebsiteData2(0);
      }
      if (widget.rss.login) {
        stopSpeak();
      }
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => WebView(
                rss: widget.rss,
                feed: widget.feed,
                index: widget.index + 1,
                isNewest: widget.isNewest,
              )));*/

      if (!widget.rss.login) {
        checkPlay = true;
        if (widget._visible1)
          await player1();
        else
          await player2();
        print("Nologin");
      }
      if (widget.rss.login) {
        if (widget._visible1)
          await player1();
        else
          await player2();
        checkPlay = true;
      }
      print(TTS[0]);
      print(TTS[1]);
      print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
    }
  }

  previousPage() async {
    if (widget.index == 0) {
      return null;
    }
    checkPlay = false;

    await player1();
    await player2();
    setState(() {
      saveNext();
      writeFile(writeViewed());
    });
    if (!widget.isNewest) {
      print("PUSHHHHHHHHHHHHHHHH!");
      widget.index--;
      if (widget._visible1) {
        setState(() {
          TTS[0] = [];
          widget._visible1 = !widget._visible1;
          widget._visible2 = !widget._visible2;
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller1!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index - 1].link.toString())));
        });
      } else {
        TTS[1] = [];
        setState(() {
          widget._visible1 = !widget._visible1;
          widget._visible2 = !widget._visible2;
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller2!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index - 1].link.toString())));
        });
      }
      print("VISIBLE1&2: ${widget._visible1}${widget._visible2}");
      if (!widget.rss.login && widget._visible1) getWebsiteData2(-1);
      if (!widget.rss.login && widget._visible2) getWebsiteData1(-1);

      ttsIndex = 0;
      checkPlay = true;
      playerVisibility = true;
      readed = 0;
      startRSS = true;
      canGoNext = false;
      loadOnce = false;
      loadFinish = false;
      mainPage = 0;
      loadOnce2 = false;

      checkViewed();
      print(TTS[0]);
      print(TTS[1]);
      print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
      print("CHANGED!!!");
      if (widget.rss.login) stopSpeak();
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WebView(
              rss: widget.rss,
              feed: widget.feed,
              index: widget.index + 1,
              isNewest: widget.isNewest,
            )));*/
      if (!widget.rss.login) {
        checkPlay = true;
        if (widget._visible1)
          await player1();
        else
          await player2();
        print("Nologin");
      }
      if (widget.rss.login) {
        if (widget._visible1)
          await player1();
        else
          await player2();
        checkPlay = true;
      }
      print(TTS[0]);
      print(TTS[1]);
      print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
    } else {
      print("PUSHHHHHHHHHHHHHHHH!");
      widget.index--;
      if (widget._visible1) {
        setState(() {
          TTS[0] = [];
          TTS[1] = [];
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller1!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index].link.toString())));
          widget._controller2!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index + 1].link.toString())));
        });
      } else {
        setState(() {
          TTS[1] = [];
          TTS[0] = [];
          widget.update(widget.feed.items![widget.index].title as String);
          stopSpeak();
          checkPlay = true;
          widget._controller2!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index].link.toString())));
          widget._controller1!.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(
                      widget.feed.items![widget.index + 1].link.toString())));
        });
      }
      stopSpeak();

      ttsIndex = 0;
      checkPlay = true;
      playerVisibility = true;
      readed = 0;
      startRSS = true;
      canGoNext = false;
      loadOnce = false;
      loadFinish = false;
      mainPage = 0;
      loadOnce2 = false;

      checkViewed();
      if (!widget.rss.login && widget._visible1) {
        await getWebsiteData2(1);
        await getWebsiteData1(0);
      }
      if (!widget.rss.login && widget._visible2) {
        await getWebsiteData1(1);
        await getWebsiteData2(0);
      }
      if (widget.rss.login) {
        stopSpeak();
      }
      /*Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => WebView(
                rss: widget.rss,
                feed: widget.feed,
                index: widget.index + 1,
                isNewest: widget.isNewest,
              )));*/

      if (!widget.rss.login) {
        checkPlay = true;
        if (widget._visible1)
          await player1();
        else
          await player2();
        print("Nologin");
      }
      if (widget.rss.login) {
        if (widget._visible1)
          await player1();
        else
          await player2();
        checkPlay = true;
      }
      print(TTS[0]);
      print(TTS[1]);
      print(": TTSINDEXXXXXXXXXXXXXXXXX: " + ttsIndex.toString());
    }
  }

  player1() async {
    while (ttsIndex < TTS[0].length) {
      if (checkPlay == true) {
        await speak(TTS[0][ttsIndex]);
        ttsIndex++;
        widget.updateIndex(ttsIndex);
        print("Index: " + ttsIndex.toString());
        print("TTSLENGTH: " + TTS[0].length.toString());
        if (ttsIndex == TTS[0].length && widget._visible1) {
          print("NEXT PAGE!!!!");
          if (widget.isNewest) {
            print("NEwest!!");
            if (!(widget.feed.items?.length == widget.index + 1))
              await nextPage();
          } else {
            print("OLDESTT!!");
            if (widget.index >= 1) previousPage();
          }
        }

        if (canGoNext &&
            ttsIndex == TTS[0].length &&
            widget.rss.login &&
            widget._visible1) {
          print("iaugysufdchgvhjbhuoasy8dg7fyucgvhjbsad");
          if (widget.isNewest) {
            print("NEwest!!");
            if (!(widget.feed.items?.length == widget.index + 1))
              await nextPage();
          } else {
            print("OLDESTT!!");
            if (widget.index >= 1) previousPage();
          }
        }
      } else if (checkPlay == false) {
        stopSpeak();
        print("STop Speaking");
        break;
      }
    }
  }

  player2() async {
    while (ttsIndex < TTS[1].length) {
      if (checkPlay == true) {
        await speak(TTS[1][ttsIndex]);
        ttsIndex++;
        widget.updateIndex(ttsIndex);
        print("Index: " + ttsIndex.toString());
        print("TTSLENGTH: " + TTS[1].length.toString());
        if (ttsIndex == TTS[1].length && widget._visible2) {
          print("NEXT PAGE!!!!");
          if (widget.isNewest) {
            print("NEwest!!");
            if (!(widget.feed.items?.length == widget.index + 1))
              await nextPage();
          } else {
            print("OLDESTT!!");
            if (widget.index >= 1) previousPage();
          }
        }

        if (canGoNext &&
            ttsIndex == TTS[1].length &&
            widget.rss.login &&
            widget._visible2) {
          print("iaugysufdchgvhjbhuoasy8dg7fyucgvhjbsad");
          if (widget.isNewest) {
            print("NEwest!!");
            if (!(widget.feed.items?.length == widget.index + 1))
              await nextPage();
          } else {
            print("OLDESTT!!");
            if (widget.index >= 1) previousPage();
          }
        }
      } else if (checkPlay == false) {
        stopSpeak();
        break;
      }
    }
  }

  // ignore: deprecated_member_use
  List<dom.Document> html =
      List<dom.Document>.generate(1000, (index) => dom.Document.html(''));
  List<List<String>> TTS = [[], []];
  int ttsIndex = 0;
  bool checkPlay = true;
  bool playerVisibility = true;
  bool startRSS = true;
  bool canGoNext = false;
  int readed = 0;
  bool loadFinish = false;
  bool loadOnce = false;
  int mainPage = 0;
  bool contPlay = false;
  bool loadOnce2 = false;
  bool nextPageCheck = false;
  bool firstTimeWebview2 = true;

  queryString() {
    if (widget.rss.newsUrl.contains('aljazeera')) {
      return 'main > div > ul > li, div > p ';
    } else if (widget.rss.newsUrl.contains('news.un.org'))
      return 'div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > p:';
    else if (widget.rss.newsUrl.contains('hmetro'))
      return 'p > p';
    else
      return 'p';
  }

  Future getWebsiteData1(int index) async {
    if (!widget.rss.login) {
      TTS[0] = [];
      final url = Uri.parse(
          stringConverter(widget.feed.items![widget.index + index].link));
      final response = await http.get(url);
      html[widget.index] = dom.Document.html(response.body);
      print("SUccessss1");
      final news = html[widget.index]
          .querySelectorAll(queryString())
          .map((e) => e.innerHtml.trim())
          .toList();
      print('Count: ${news.length}');
      TTS[0].add(widget.feed.items![widget.index + index].title as String);
      for (String p in news) {
        p = p.replaceAll(RegExp(r"<\\?.*?>"), "");
        p = p.replaceAll("&nbsp", "");
        p = p.replaceAll(";", " ");
        print(p);
        final pp = p.split('. ');
        TTS[0] = TTS[0] + pp;
      }
      print(TTS[0]);
    }
    contPlay = true;
    if (!widget.rss.login) {
      if (TTS[0][0].isNotEmpty && startRSS && widget._visible1) {
        print("START READINGGG");
        checkPlay = true;
        if (widget.continueBool) {
          print("Continued!");

          widget.readingIndex = ttsIndex;
          print(widget.readingIndex);
          widget.continueBool = false;
        }
        if (widget._visible1) await player1();
        startRSS = false;
      }
    }
    if (widget.rss.login) {
      if (widget._visible1) {
        checkPlay = false;
        await player1();
      }
    }
  }

  startPlayer1OnCreate() async {
    if (!(TTS[0].length > 3)) {
      TTS[0] = await getJavascript1(widget._controller1);
      loadFinish = true;
      print("TTSlengthandtext");
      print("TTS LENGTH:" + TTS[0].length.toString());
      print("LoadOnce");
      if (widget.continueBool) {
        widget.readingIndex = ttsIndex;
        widget.continueBool = false;
      }
      if (widget._visible1) {
        checkPlay = true;
        await player1();
        await saveNext();
        await writeFile(writeViewed());
        loadOnce = true;
      }
    }
  }

  player1NextPage() async {
    TTS[0] = await getJavascript1(widget._controller1);
  }

  player2NextPage() async {
    TTS[1] = await getJavascript2(widget._controller2);
  }

  getPlayer2OnCreate() async {
    if (!(TTS[1].length > 3)) {
      TTS[1] = await getJavascript2(widget._controller2);
      print("+++++++++++++++++++");
      print("TTS LENGTHabcsd:" + TTS[1].length.toString());
      loadOnce2 = true;
    }
  }

  Future getWebsiteData2(int index) async {
    if (!widget.rss.login) {
      TTS[1] = [];
      final url = Uri.parse(
          stringConverter(widget.feed.items![widget.index + index].link));
      final response = await http.get(url);
      html[widget.index] = dom.Document.html(response.body);
      print("SUccessss2");
      final news = html[widget.index]
          .querySelectorAll(queryString())
          .map((e) => e.innerHtml.trim())
          .toList();
      print('Count: ${news.length}');
      TTS[1].add(widget.feed.items![widget.index + index].title as String);
      for (String p in news) {
        p = p.replaceAll(RegExp(r"<\\?.*?>"), "");
        p = p.replaceAll("&nbsp", "");
        p = p.replaceAll(";", " ");
        print(p);
        final pp = p.split('. ');
        TTS[1] = TTS[1] + pp;
      }
      print(TTS[1]);
    }
    contPlay = true;
  }

  int getIncrement() {
    if (widget.isNewest)
      return 1;
    else
      return -1;
  }

  _popUp() {
    print("Popup");
  }

  getJavascript1(controller) async {
    var response = await controller.evaluateJavascript(
        source: "document.documentElement.innerText;");
    LineSplitter ls = new LineSplitter();
    List<String> responseSplit = ls.convert(response);
    print(responseSplit);
    //responseSplit.removeRange(responseSplit.length - 5, responseSplit.length);
    List<String> newResponse = [];
    for (String p in responseSplit) {
      p = p.replaceAll(r'ADS', '');

      if (p.startsWith("#")) continue;
      newResponse.add(p);
    }
    return newResponse;
  }

  getJavascript2(controller) async {
    var response = await controller.evaluateJavascript(
        source: "document.documentElement.innerText;");
    LineSplitter ls = new LineSplitter();
    List<String> responseSplit = ls.convert(response);
    print(responseSplit);
    responseSplit.removeRange(responseSplit.length - 5, responseSplit.length);
    List<String> newResponse = [];
    for (String p in responseSplit) {
      p = p.replaceAll(r'ADS', '');

      if (p.startsWith("#")) continue;
      newResponse.add(p);
    }
    return newResponse;
  }

  checkContPlay() {
    setState(() {
      checkPlay = true;
    });
  }

  checkLastEntry() {
    if (widget.isNewest) {
      if (!(widget.feed.items?.length == widget.index + 1)) {
        print("FIRST ARTICLE");

        if (firstTimeWebview2) {
          getWebsiteData2(getIncrement());
          firstTimeWebview2 = false;
        }
        return URLRequest(
            url: Uri.parse(stringConverter(
                widget.feed.items![widget.index + getIncrement()].link)));
      } else {
        return URLRequest(url: Uri.parse(stringConverter('')));
      }
    } else {
      if (widget.index >= 1) {
        print("LAST ARTICLE");
        if (firstTimeWebview2) {
          getWebsiteData2(getIncrement());
          firstTimeWebview2 = false;
        }
        return URLRequest(
            url: Uri.parse(stringConverter(
                widget.feed.items![widget.index + getIncrement()].link)));
      } else {
        return URLRequest(url: Uri.parse(stringConverter('')));
      }
    }
  }

  double _progress = 0;
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
                Visibility(
                  child: InAppWebView(
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            transparentBackground: true,
                            javaScriptEnabled: true)),
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(stringConverter(
                            widget.feed.items![widget.index].link))),
                    onWebViewCreated:
                        (InAppWebViewController controller) async {
                      widget._controller1 = controller;
                      if (!widget.rss.login) await getWebsiteData1(0);
                    },
                    onProgressChanged: (InAppWebViewController controller,
                        int progress) async {
                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (_, Uri? uri, __) {
                      mainPage++;
                    },
                    onLoadStop: (controller, url) async {
                      await Future.delayed(Duration(seconds: 2));
                      if (widget.rss.login) {
                        print(
                            "=================================================");

                        if (!loadOnce) {
                          await startPlayer1OnCreate();
                        }
                        if (nextPageCheck) {
                          await player1NextPage();
                          nextPageCheck = false;
                        }
                      } else {
                        if (checkPlay == false && widget._visible1) {
                          setState(() {
                            checkPlay == true;
                            player1();
                          });
                        }
                      }
                    },
                  ),
                  maintainState: true,
                  visible: widget._visible1,
                ),
                _progress < 1
                    ? SizedBox(
                        height: 3,
                        child: LinearProgressIndicator(value: _progress),
                      )
                    : SizedBox(),
                Visibility(
                  child: InAppWebView(
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            transparentBackground: true,
                            javaScriptEnabled: true)),
                    initialUrlRequest: checkLastEntry(),
                    onWebViewCreated:
                        (InAppWebViewController controller) async {
                      widget._controller2 = controller;
                      print("Lollllllllllll");
                    },
                    onProgressChanged: (InAppWebViewController controller,
                        int progress) async {
                      if (!widget.rss.login) {
                        if (TTS[0][0].isNotEmpty && startRSS) {
                          checkPlay = true;
                          if (widget.continueBool) {
                            widget.readingIndex = ttsIndex;
                            print(widget.readingIndex);
                            widget.continueBool = false;
                          }
                          if (widget._visible2) {
                            await player2();
                            print("PLAYER2222222222");
                          }
                          startRSS = false;
                        }
                      }
                      if (widget.rss.login) {
                        if (widget._visible2) {
                          checkPlay = false;
                          await player2();
                        }
                      }

                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (_, Uri? uri, __) {
                      mainPage++;

                      print(
                          "VISITEDDDDDDDDDDDDDDDDDDDD: " + mainPage.toString());
                    },
                    onLoadStop: (controller, url) async {
                      if (widget.rss.login) {
                        if (!loadOnce2) {
                          await getPlayer2OnCreate();
                        }
                        if (nextPageCheck) {
                          await player2NextPage();
                          nextPageCheck = false;
                        }
                        print("TEST TTS2");
                        print(TTS[1]);
                      }
                    },
                  ),
                  maintainState: true,
                  visible: widget._visible2,
                ),
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

                              if (widget._visible1)
                                player1();
                              else
                                player2();
                              if (ttsIndex >= 1) ttsIndex--;
                              checkPlay = true;
                              if (widget._visible1)
                                player1();
                              else
                                player2();
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
                                  contPlay = checkPlay;
                                  if (widget._visible1)
                                    player1();
                                  else
                                    player2();
                                });
                              }),
                          IconButton(
                            iconSize: screenWidth,
                            color: Colors.blue,
                            onPressed: () async {
                              checkPlay = false;

                              if (widget._visible1)
                                player1();
                              else
                                player2();
                              ttsIndex++;
                              widget.updateIndex(ttsIndex);
                              checkPlay = true;
                              if (widget._visible1)
                                player1();
                              else
                                player2();
                            },
                            icon: Icon(
                              Icons.fast_forward,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            iconSize: screenWidth,
                            color: Colors.blue,
                            onPressed: () async {
                              if (widget.isNewest) {
                                if (!(widget.feed.items?.length ==
                                    widget.index + 1)) await nextPage();
                              } else {
                                if (widget.index >= 1) await previousPage();
                              }
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              iconSize: screenWidth,
                              color: Colors.blue,
                              onPressed: () {
                                setState(() {
                                  //testTTS();
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
