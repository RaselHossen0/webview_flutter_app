import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WebView App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://ie.bigboss.easycalldns.com:5005/"),
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _isLoading = false;
                });
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                // Allow self-signed certificates for testing purposes
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
              onReceivedError: (controller, request, error) {
                print('Web resource error: ${error.description}');
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _isLoading = progress < 100;
                });
              },
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator.adaptive())
              : Container(),
        ],
      ),
    );
  }
}
