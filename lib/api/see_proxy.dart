import 'package:crypto/crypto.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/db.dart';
import 'dart:convert';

import 'package:see_me_now/data/setting.dart';

class ApiRes {
  bool status = false;
  String text = '';
}

class SeeProxy {
  String user;
  String key;
  String urlPrefix;

  SeeProxy(
      {this.user = '',
      this.key = '',
      this.urlPrefix = "http://localhost:3000"});

  void setParam(
      {String user = '',
      String key = '',
      String urlPrefix = '',
      String userAndKey = '',
      bool saveDB = false}) {
    if (user.isNotEmpty) {
      this.user = user;
      if (saveDB) {
        DB.setting.putString(SettingKeyConstants.seeProxyUser, user);
        Log.log.fine('SeeProxy setParam() user: $user');
      }
    }
    if (key.isNotEmpty) {
      this.key = key;
      if (saveDB) {
        DB.setting.putString(SettingKeyConstants.seeProxyKeyKey, key);
        Log.log.fine('SeeProxy setParam() key: $key');
      }
    }
    if (urlPrefix.isNotEmpty) {
      this.urlPrefix = urlPrefix;
      if (saveDB) {
        DB.setting.putString(SettingKeyConstants.seeProxyUrlPrefix, urlPrefix);
        Log.log.fine('SeeProxy setParam() url: $urlPrefix');
      }
    }
    if (userAndKey.isNotEmpty) {
      List<String> strs = userAndKey.split('-');
      if (strs.length == 2) {
        this.user = strs[0];
        this.key = strs[1];
        if (saveDB) {
          Log.log.fine('SeeProxy setParam() userAndKey: ${strs[0]}-${strs[1]}');
          DB.setting.putString(SettingKeyConstants.seeProxyUser, strs[0]);
          DB.setting.putString(SettingKeyConstants.seeProxyKeyKey, strs[1]);
        }
      }
    }
  }

  /*
	request: {
	  user: 'user1',
	  timestamp: 1676346410,
	  text: 'hello',
	  md5hash: '', // md5sum(user + key + timestamp + text)
	}
  */
  static Map<String, Object> genRequest(String text) {
    var timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    var md5hash = md5
        .convert(
            utf8.encode('${DB.seeProxy.user}${DB.seeProxy.key}$timestamp$text'))
        .toString();
    var request = {
      'user': DB.seeProxy.user,
      'timestamp': timestamp,
      'text': text,
      'md5hash': md5hash,
    };
    return request;
  }
}
