import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String blogurl; // URL to the article

  const ArticleView({required this.blogurl, Key? key}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late WebViewController
      _controller; // WebView controller for interacting with the WebView

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setBackgroundColor(const Color(0x00000000)) // Transparent background
      ..loadRequest(Uri.parse(widget.blogurl)); // Load the initial URL
  }

  void _scrollToTop() {
    _controller.runJavaScript("window.scrollTo(0, 0);"); // Scroll to the top
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          // Center the title in the app bar
          child: Text(
            "Article", // Title for the article view
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        actions: [
          // Right-aligned buttons (if any)
          IconButton(
            // Example button for refreshing the WebView
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(), // Reload the WebView
          ),
        ],
      ),
      body: WebViewWidget(
        // Display the WebView
        controller: _controller,
      ),
      floatingActionButton: FloatingActionButton(
        // Floating action button to scroll to the top
        backgroundColor: Colors.white, // Color of the button
        onPressed: _scrollToTop, // Scroll to the top of the WebView
        child: Icon(Icons.arrow_upward), // Icon for the button
      ),
    );
  }
}
