import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  String? url;
  String? filePath;
  WebViewPage({this.url, this.filePath});
  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {

  late String _webTitle;
  late WebViewController _controller;


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
          initialUrl: widget.url != null ? widget.url : "",
          //JS执行模式 是否允许JS执行
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
            if (widget.filePath != null) {
              _loadHtmlFromAssets();
            }
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

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(widget.filePath);
    _controller.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}