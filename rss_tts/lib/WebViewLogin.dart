import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'WebView.dart';

class WebViewLogin extends StatefulWidget {
  WebViewLogin({super.key, required this.RSSLink, required this.websiteName});
  String RSSLink;
  String websiteName;
  @override
  State<WebViewLogin> createState() => _WebViewLoginState();
}

class _WebViewLoginState extends State<WebViewLogin> {
  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.websiteName),
        ),
        body: Container(
          child: InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    transparentBackground: true, javaScriptEnabled: true)),
            initialUrlRequest:
                URLRequest(url: Uri.parse(stringConverter(widget.RSSLink))),
            onProgressChanged:
                (InAppWebViewController controller, int progress) async {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
        ));
  }
}
