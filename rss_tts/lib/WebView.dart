import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rss_tts/NavBar.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.title, required this.newsUrl});
  final String? title;
  final String? newsUrl;

  @override
  State<WebView> createState() => _WebViewState();
}

stringConverter(String? s) {
  String nonNullableString = s ?? 'default';
  return nonNullableString;
}

class _WebViewState extends State<WebView> {
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
                webView = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
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
