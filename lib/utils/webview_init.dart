import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:webview_flutter/webview_flutter.dart';

// Conditional import for web platform
// On web: imports webview_flutter_web
// On other platforms: imports stub
import 'webview_init_stub.dart'
    if (dart.library.html) 'package:webview_flutter_web/webview_flutter_web.dart' as webview_web;

void initializeWebView() {
  // For web platform, initialize webview_flutter_web
  // For other platforms, the plugin system auto-registers the platform implementation
  if (kIsWeb) {
    try {
      // Only try to initialize on web platform
      // The conditional import ensures webview_web is only available on web
      if (WebViewPlatform.instance == null) {
        // This will only compile/run on web due to conditional import
        // On web, webview_web.WebWebViewPlatform() returns the real implementation
        // On other platforms, this code path is never reached due to kIsWeb check
        final platform = webview_web.WebWebViewPlatform();
        WebViewPlatform.instance = platform as WebViewPlatform;
      }
    } catch (e) {
      debugPrint('WebView web platform initialization: $e');
    }
  }
  // For Android, iOS, Windows: platform implementation is auto-registered
}

