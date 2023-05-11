import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:see_me_now/api/see_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';

Codec<String, String> stringToBase64 = utf8.fuse(base64);

class BingRecord {
  static const int maxContentLength = 2048;
  String name = '';
  String url = '';
  String snippet = '';
  String language = '';
  String dateLastCrawled = '';
  String content = '';
  BingRecord(this.name, this.url, this.snippet, this.language,
      this.dateLastCrawled, this.content);
  factory BingRecord.fromJson(Map<String, dynamic> json) {
    String content = stringToBase64.decode(json['content']);
    return BingRecord(
        json['name'],
        json['url'],
        json['snippet'],
        json['language'],
        json['dateLastCrawled'],
        content.substring(
            0,
            content.length > maxContentLength
                ? maxContentLength
                : content.length));
  }
  @override
  String toString() {
    return jsonEncode({
      'name': name,
      'url': url,
      'snippet': snippet,
      'language': language,
      'dateLastCrawled': dateLastCrawled,
      'content': content
    });
  }
}

class Bing {
  String urlPath;
  Bing({this.urlPath = '/api/v2/bing'});
  Future<List<BingRecord>> search(String query,
      {int count = 1, int offset = 0}) async {
    List<BingRecord> rt = [];
    try {
      var request = SeeProxy.genRequest(query);
      request['count'] = count;
      request['offset'] = offset;

      var url = DB.seeProxy.urlPrefix + urlPath;
      Log.log.fine('bing search url: $url for query: $query');
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request));
      if (response.statusCode != 200) {
        Log.log.warning(
            'bing search get status code:${response.statusCode} ,body:${response.body}');
        return rt;
      }
      List<dynamic> resJson = jsonDecode(response.body);
      rt = List<BingRecord>.from(resJson.map((e) => BingRecord.fromJson(e)));

      Log.log.fine('bing search result: $rt');
      if (rt.isNotEmpty) {
        Log.log.finest('bing search result: ${rt[0].content}');
      }
      return rt;
    } catch (e) {
      Log.log.warning('bing search exception: $e');
    }
    return rt;
  }
}
