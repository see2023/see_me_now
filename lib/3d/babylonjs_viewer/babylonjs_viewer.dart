import 'dart:convert' show utf8;
import 'package:mime/mime.dart';
import 'dart:io'
    show File, HttpRequest, HttpServer, HttpStatus, InternetAddress;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:see_me_now/data/log.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'html_builder.dart';

/// Flutter widget for rendering interactive 3D models.
class BabylonJSViewer extends StatefulWidget {
  const BabylonJSViewer({
    Key? key,
    required this.src,
    this.controller,
    this.functions,
  }) : super(key: key);

  final String src;
  final WebViewController? controller;
  final String? functions;

  @override
  State<BabylonJSViewer> createState() => _BabylonJSViewerState();
}

class _BabylonJSViewerState extends State<BabylonJSViewer> {
  HttpServer? _proxy;
  String? url;
  String? proxyIndexUrl;

  @override
  void initState() {
    super.initState();
    _initProxy();
  }

  @override
  void dispose() {
    super.dispose();
    if (_proxy != null) {
      _proxy!.close(force: true);
      _proxy = null;
    }
  }

  @override
  void didUpdateWidget(final BabylonJSViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    if (_proxy != null) {
      return WebViewWidget(
        controller: widget.controller!,
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  String _buildHTML(final String htmlTemplate) {
    return HTMLBuilder.build(
        htmlTemplate: htmlTemplate,
        src: '/modelLink.glb',
        functions: widget.functions);
  }

  Future<void> _initProxy() async {
    final url = Uri.parse(widget.src);
    Log.log.fine('initProxy $url');
    _proxy = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    Log.log.info('Viewer Proxy listening on port ${_proxy!.port}');
    proxyIndexUrl = 'http://localhost:${_proxy!.port}/v2/index.html';
    _proxy!.listen((final HttpRequest request) async {
      final response = request.response;

      if (request.uri.path.startsWith('/v2')) {
        // as a static http server, read from 'assets/viewer/v2/' using rootBundle
        final String mimeType =
            lookupMimeType(request.uri.path) ?? 'application/octet-stream';
        final data = await (request.uri.isScheme("file")
            ? _readFile(request.uri.path)
            : _readAsset('assets/viewer${request.uri.path}'));
        response
          ..statusCode = HttpStatus.ok
          ..headers.add("Content-Type", mimeType)
          ..headers.add("Content-Length", data.lengthInBytes.toString())
          ..headers.add("Access-Control-Allow-Origin", "*")
          ..add(data);
        Log.log.fine(
            'proxy serving v2 ${request.uri.path} with mime $mimeType, length ${data.lengthInBytes}');
        await response.close();
      } else {
        Log.log.fine('proxy serving v1 ${request.uri.path}');
        switch (request.uri.path) {
          case '/':
          case '/index.html':
            final htmlTemplate =
                await rootBundle.loadString('assets/viewer/template.html');
            final html = utf8.encode(_buildHTML(htmlTemplate));
            response
              ..statusCode = HttpStatus.ok
              ..headers.add("Content-Type", "text/html;charset=UTF-8")
              ..headers.add("Content-Length", html.length.toString())
              ..add(html);
            await response.close();
            break;

          case '/babylon.viewer.min.js':
            final code =
                await _readAsset('assets/viewer/babylon.viewer.min.js');
            response
              ..statusCode = HttpStatus.ok
              ..headers
                  .add("Content-Type", "application/javascript;charset=UTF-8")
              ..headers.add("Content-Length", code.lengthInBytes.toString())
              ..add(code);
            await response.close();
            break;

          case '/bg_nx.jpg':
          case '/bg_ny.jpg':
          case '/bg_nz.jpg':
          case '/bg_px.jpg':
          case '/bg_py.jpg':
          case '/bg_pz.jpg':
            final code = await _readAsset('assets/viewer/bg_nx.jpg');
            response
              ..statusCode = HttpStatus.ok
              ..headers
                  .add("Content-Type", "application/javascript;charset=UTF-8")
              ..headers.add("Content-Length", code.lengthInBytes.toString())
              ..add(code);
            await response.close();
            break;

          case '/modelLink.glb':
            if (url.isAbsolute && !url.isScheme("file")) {
              await response.redirect(url);
            } else {
              final data = await (url.isScheme("file")
                  ? _readFile(url.path)
                  : _readAsset(url.path));
              response
                ..statusCode = HttpStatus.ok
                ..headers.add("Content-Type", "application/octet-stream")
                ..headers.add("Content-Length", data.lengthInBytes.toString())
                ..headers.add("Access-Control-Allow-Origin", "*")
                ..add(data);
              await response.close();
            }
            break;

          case '/favicon.ico':
          default:
            final text = utf8.encode("Resource '${request.uri}' not found");
            response
              ..statusCode = HttpStatus.notFound
              ..headers.add("Content-Type", "text/plain;charset=UTF-8")
              ..headers.add("Content-Length", text.length.toString())
              ..add(text);
            await response.close();
            break;
        }
      }
    });
    widget.controller!.loadRequest(Uri.parse(proxyIndexUrl!));
    setState(() {});
  }

  Future<Uint8List> _readAsset(final String key) async {
    final data = await rootBundle.load(key);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<Uint8List> _readFile(final String path) async {
    return await File(path).readAsBytes();
  }
}
