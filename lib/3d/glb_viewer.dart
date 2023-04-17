import 'package:flutter/material.dart';
import 'package:see_me_now/3d/babylonjs_viewer/babylonjs_viewer.dart';
import 'package:see_me_now/data/log.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GlbViewer extends StatefulWidget {
  const GlbViewer({Key? key, this.url = 'assets/3d/zhugeliang.low.glb'})
      : super(key: key);

  final String url;

  @override
  State<GlbViewer> createState() => GlbViewerState();
}

class GlbViewerState extends State<GlbViewer> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    Log.log.fine('initState glb viewer $this');
    // debuggingEnabled: true,
    // backgroundColor: Colors.white,
    // javascriptMode: JavaScriptMode.unrestricted,
    _controller = WebViewController()
      ..addJavaScriptChannel('Print',
          onMessageReceived: (JavaScriptMessage message) {
        Log.log.info('webview: ${message.message}');
      })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
    // ..loadRequest(Uri.parse("assets/viewer/index.html"));
  }

  @override
  Widget build(BuildContext context) {
    Log.log.fine('build glb viewer');
    return BabylonJSViewer(
        controller: _controller,
        functions: '''
function sayHello() { 
  Print.postMessage("Hello World!"); 
}

function toggleAutoRotate(texture) {
  let viewer = BabylonViewer.viewerManager.getViewerById('viewer-id');
  viewer.sceneManager.camera.useAutoRotationBehavior = !viewer.sceneManager.camera.useAutoRotationBehavior
}
''',
        src: widget.url);
  }

  void toggleAutoRotate() {
    _controller?.runJavaScript('toggleAutoRotate()');
  }

  void sendVisemes(String visemesValuesString) {
    _controller?.runJavaScript('setVisemes("$visemesValuesString")');
  }

  void sendMouthSmileMorphTargetInfluence(int influence) {
    _controller
        ?.runJavaScript('setMouthSmileMorphTargetInfluence("$influence")');
  }
}
