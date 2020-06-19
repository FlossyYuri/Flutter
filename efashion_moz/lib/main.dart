import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: "E Fashion",
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  final _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("E-FASHION"),
          centerTitle: false,
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          initialUrl: "https://efashionmoz.com/",
        ),
        floatingActionButton: FutureBuilder<WebViewController>(
          future: _controller.future,
          builder: (context, AsyncSnapshot<WebViewController> controller) {
            if (controller.hasData)
              return FloatingActionButton(
                child: Icon(Icons.remove_red_eye),
                onPressed: () {
                  controller.data.loadUrl(
                      "https://efashionmoz.com/2019/09/30/hello-world/");
                },
              );
            else
              return Container();
          },
        ));
  }
}
