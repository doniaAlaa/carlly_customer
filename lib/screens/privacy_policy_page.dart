import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PrivacyPolicyPage extends StatefulWidget {
  // dynamic from;
  dynamic url;
  PrivacyPolicyPage({super.key, this.url});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    // #docregion platform_features
    dynamic paymentUrl;

    paymentUrl = "https://carllyadmin.carllymotors.com/pages/privacy_policy";

    late final PlatformWebViewControllerCreationParams params;

    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));

    _controller = controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      child: Material(
        child: Stack(
          children: [
            Container(
              height: media.height,
              width: media.width,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                    Container(
                      width: media.width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(media.width * 0.05),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: const Icon(Icons.arrow_back)),
                    ),
                  Expanded(
                    child: WebViewWidget(
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
