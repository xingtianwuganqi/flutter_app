import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  WebViewPage({Key key,@required this.url}): super(key: key);
  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {

  String _webTitle;
  WebViewController _controller;


  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_webTitle ?? ''),
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child:  WebView(
          backgroundColor: Colors.white,
          initialUrl: widget.url,
          //JS执行模式 是否允许JS执行
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onPageFinished: (url) {
            _controller.runJavascriptReturningResult("document.title").then((result){
              setState(() {
                _webTitle = result;
              });
            }
            );
          },
        ),
      ),
    );
  }
}