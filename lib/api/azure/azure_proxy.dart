import 'dart:io';

import 'package:see_me_now/api/see_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bson/bson.dart';

class AzureRes extends ApiRes {
  String parentMessageId = '';
  String wavFilePath = '';
  String visemesFilePath = '';
  String visemesText = '';
}

class AzureProxy {
  String urlPath;
  String urlPathV2;
  String voiceName;
  // zh-CN-XiaoyiNeural support role: zh-CN-XiaomoNeural zh-CN-XiaoxuanNeural YunyeNeural5 ...
  String style;
  // https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support?tabs=tts
  String role;
  // https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/speech-synthesis-markup-voice#speaking-styles-and-roles
  // Boy, Girl, OlderAdultFemale, OlderAdultMale, SeniorFemale, SeniorMale, YoungAdultFemale, YoungAdultMale

  AzureProxy(
      {this.urlPath = "/api/v1/azuretts",
      this.urlPathV2 = "/api/v2/azurettsWithVisemes",
      // this.voiceName = 'zh-CN-YunyeNeural',
      this.voiceName = 'zh-CN-YunfengNeural',
      this.style = 'cheerful',
      this.role = ''});

  void setVoiceParams(String voiceName, {String style = '', String role = ''}) {
    if (voiceName.isEmpty) return;
    this.voiceName = voiceName;
    if (style.isNotEmpty) this.style = style;
    if (role.isNotEmpty) this.role = role;
  }

  void appendParams(Map<String, Object> request, String thisVoiceName) {
    if (thisVoiceName.isNotEmpty) {
      request['voiceName'] = thisVoiceName;
    } else if (voiceName.isNotEmpty) {
      request['voiceName'] = voiceName;
    }
    if (style.isNotEmpty) {
      request['style'] = style;
    }
    if (role.isNotEmpty) {
      request['role'] = role;
    }
  }

  /*
	request: {
    ... , // basic auth from SeeProxy
	  text: 'hello',
	}
	response: wav binary data
  */
  Future<AzureRes> textToWav(String text, String fileID) async {
    var rt = AzureRes();
    rt.wavFilePath = '${DB.cacheDirPath}/$fileID.wav';
    // check if file exists
    File wavFile = File(rt.wavFilePath);

    bool exist = await wavFile.exists();
    if (exist) {
      Log.log.info('azuretts wav file exists: ${rt.wavFilePath}');
      rt.status = true;
      return rt;
    }

    try {
      var request = SeeProxy.genRequest(text);
      appendParams(request, '');

      var url = DB.seeProxy.urlPrefix + urlPath;
      Log.log.fine('azuretts before sending request to: $url, req: $request');
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request));
      if (response.statusCode != 200) {
        Log.log.warning(
            'azuretts get status code:${response.statusCode} ,body:${response.body}');
        rt.text = response.body.toString();
        return rt;
      }
      wavFile.writeAsBytesSync(response.bodyBytes);
      Log.log.info('azuretts wav file saved to: ${rt.wavFilePath}');
      rt.status = true;
      return rt;
    } catch (e) {
      Log.log.warning('azuretts exception: $e, delete wav file: $wavFile');
      rt.text = e.toString();
      try {
        await wavFile.delete();
      } catch (eDelete) {
        Log.log.warning(
            'azuretts delete exception: $eDelete, deleting wav file: $wavFile');
      }
      return rt;
    }
  }

  /*
	request: {
    ... , // basic auth from SeeProxy
	  text: 'hello',
	}
	response: wav binary data
  */
  Future<AzureRes> textToWavAndVisemes(String text, String fileID,
      {bool keepVisemes = true, String thisVoiceName = ''}) async {
    var rt = AzureRes();
    rt.wavFilePath = '${DB.cacheDirPath}/$fileID.wav';
    rt.visemesFilePath = '${DB.cacheDirPath}/$fileID.visemes.json';
    // check if file exists
    File wavFile = File(rt.wavFilePath);
    File visemesFile = File(rt.visemesFilePath);

    bool existWav = await wavFile.exists();
    bool existVisemes = await visemesFile.exists();
    if (existWav && existVisemes) {
      Log.log.info(
          'azuretts wav and visemes file exists: ${rt.wavFilePath}, ${rt.visemesFilePath}');
      if (keepVisemes) {
        rt.visemesText = await visemesFile.readAsString();
      }
      rt.status = true;
      return rt;
    }

    try {
      var request = SeeProxy.genRequest(text);
      appendParams(request, thisVoiceName);

      var url = DB.seeProxy.urlPrefix + urlPathV2;
      Log.log.fine('azuretts before sending request to: $url, req: $request');
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request));
      if (response.statusCode != 200) {
        Log.log.warning(
            'azuretts get status code:${response.statusCode} ,body:${response.body}');
        rt.text = response.body.toString();
        return rt;
      }
      Log.log.fine('azuretts get ok, bytes: ${response.bodyBytes.length}');
      final decodedJsonObj =
          BSON().deserialize(BsonBinary.from(response.bodyBytes));
      rt.visemesText = decodedJsonObj['visemes'];
      final BsonBinary audio = decodedJsonObj['audio'];
      wavFile.writeAsBytesSync(audio.byteList);
      Log.log.info('azuretts wav file saved to: ${rt.wavFilePath}');
      visemesFile.writeAsStringSync(rt.visemesText);
      Log.log.info('azuretts visemes file saved to: ${rt.visemesFilePath}');
      rt.status = true;
      return rt;
    } catch (e) {
      Log.log.warning(
          'azuretts exception: $e, deleting files: $wavFile $visemesFile');
      rt.text = e.toString();
      try {
        await wavFile.delete();
        await visemesFile.delete();
      } catch (eDelete) {
        Log.log.warning(
            'azuretts delete exception: $eDelete, deleting file: $wavFile, $visemesFile');
      }
      return rt;
    }
  }
}
