import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:see_me_now/api/see_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';

Codec<String, String> stringToBase64 = utf8.fuse(base64);

class BingRecord {
  String name = '';
  String url = '';
  String snippet = '';
  String language = '';
  String dateLastCrawled = '';
  String content = '';
  BingRecord(this.name, this.url, this.snippet, this.language,
      this.dateLastCrawled, this.content);
  factory BingRecord.fromJson(Map<String, dynamic> json) {
    return BingRecord(
        json['name'],
        json['url'],
        json['snippet'],
        json['language'],
        json['dateLastCrawled'],
        stringToBase64.decode(json['content']));
  }
}

class Bing {
  String urlPath;
  Bing({this.urlPath = '/api/v2/bing'});
  Future<List<BingRecord>> search(String query) async {
    List<BingRecord> rt = [];
    try {
      var request = SeeProxy.genRequest(query);

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
