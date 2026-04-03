// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewPage extends StatefulWidget {
//   String? url;
//   String? filePath;
//   WebViewPage({this.url, this.filePath});
//   @override
//   WebViewPageState createState() => WebViewPageState();
// }
//
// class WebViewPageState extends State<WebViewPage> {
//
//   late String _webTitle;
//   late WebViewController _controller;
//
//
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_webTitle ?? ''),
//         elevation: 0.5,
//       ),
//       body: Container(
//         color: Colors.white,
//         width: double.infinity,
//         height: double.infinity,
//         child: Container()
//         // WebView(
//         //   backgroundColor: Colors.white,
//         //   initialUrl: widget.url != null ? widget.url : "",
//         //   //JS执行模式 是否允许JS执行
//         //   javascriptMode: JavascriptMode.unrestricted,
//         //   onWebViewCreated: (controller) {
//         //     _controller = controller;
//         //     if (widget.filePath != null) {
//         //       _loadHtmlFromAssets();
//         //     }
//         //   },
//         //   onPageFinished: (url) {
//         //     _controller.runJavascriptReturningResult("document.title").then((result){
//         //       setState(() {
//         //         _webTitle = result;
//         //       });
//         //     }
//         //     );
//         //   },
//         // ),
//       ),
//     );
//   }
//
//   _loadHtmlFromAssets() async {
//     // String fileHtmlContents = await rootBundle.loadString(widget.filePath);
//     // _controller.loadUrl(Uri.dataFromString(fileHtmlContents,
//     //     mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//     //     .toString());
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  WebViewPage(this.url);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  String? _webTitle;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)..setNavigationDelegate(NavigationDelegate(onProgress: (int progress){

      },onPageStarted: (String url){

      },onPageFinished: (String url){
        _controller.runJavaScriptReturningResult("document.title").then((value) {
            setState(() {
              _webTitle = value as String?;
            });
        });
      },onWebResourceError: (WebResourceError error) {
        // "Error ${error.description}".log();
      },onNavigationRequest: (NavigationRequest request){
        if (request.url.startsWith(widget.url)) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }))..loadRequest(Uri.parse(widget.url),method: LoadRequestMethod.get);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_webTitle ?? '')),
      body: WebViewWidget(controller: _controller),
    );
  }
}