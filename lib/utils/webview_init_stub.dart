// Stub file for non-web platforms
// This file is replaced by webview_flutter_web on web platform
// Note: This stub is never actually used because we check kIsWeb before calling it
// But it's needed for conditional imports to work

// Import webview_flutter_platform_interface to get WebViewPlatform interface and types
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

// Stub class that implements WebViewPlatform interface
// This is never actually instantiated on non-web platforms due to kIsWeb check
class WebWebViewPlatform implements WebViewPlatform {
  WebWebViewPlatform() {
    // This should never be called on non-web platforms
    throw UnimplementedError('WebWebViewPlatform should not be instantiated on non-web platforms');
  }
  
  @override
  PlatformWebViewController createPlatformWebViewController(PlatformWebViewControllerCreationParams params) {
    throw UnimplementedError('WebWebViewPlatform is not available on this platform');
  }
  
  @override
  PlatformWebViewWidget createPlatformWebViewWidget(PlatformWebViewWidgetCreationParams params) {
    throw UnimplementedError('WebWebViewPlatform is not available on this platform');
  }
  
  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(PlatformNavigationDelegateCreationParams params) {
    throw UnimplementedError('WebWebViewPlatform is not available on this platform');
  }
  
  @override
  PlatformWebViewCookieManager createPlatformCookieManager(PlatformWebViewCookieManagerCreationParams params) {
    throw UnimplementedError('WebWebViewPlatform is not available on this platform');
  }
}

