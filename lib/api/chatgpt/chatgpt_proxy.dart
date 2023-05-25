import 'package:see_me_now/api/see_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:see_me_now/ml/agent/agent_prompts.dart';
import 'package:see_me_now/tools/string_tools.dart';

class ChatGPTRes extends ApiRes {
  String parentMessageId = '';
}

class ChatGPTResWithMotion extends ChatGPTRes {
  String style = '';
  String motions = '';
}

class ChatGPTProxy {
  String urlPath;
  bool status = false;

  ChatGPTProxy({this.urlPath = "/api/v1/chatgpt"});

  // get chatgpt response
  /*
	request: {
    ... , // basic auth from SeeProxy
	  text: 'hello',
	  parentMessageId: lastMessageI.id,  // optional
	  conversationId: '...' // optional
	}
	response: {
	  role: 'assistant',
	  id: '...',
	  parentMessageId: '....',
	  conversationId: '...',
	  text: ''
	  detail: {
		id: 'cmpl-...',
		object: 'text_completion',
		created: 1676346410,
		model: 'text-davinci-003',
		choices: [ [Object] ],
		usage: { prompt_tokens: 117, completion_tokens: 259, total_tokens: 376 }
	  }
	}
  */
  Future<ChatGPTRes> sendMessage(
      String text, String parentMessageId, String model, String systemMessage,
      {double temperature = -1}) async {
    var rt = ChatGPTRes();
    try {
      status = false;
      var request = SeeProxy.genRequest(text);
      if (parentMessageId.isNotEmpty) {
        request['parentMessageId'] = parentMessageId;
      }
      if (model.isNotEmpty) {
        request['model'] = model;
      }
      if (systemMessage.isNotEmpty) {
        request['systemMessage'] = systemMessage;
      }
      if (temperature >= 0 && temperature <= 2) {
        request['temperature'] = temperature;
      }

      var url = DB.seeProxy.urlPrefix + urlPath;
      Log.log.fine('chatgpt before sending request to: $url, req: $request');
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request));
      if (response.statusCode != 200) {
        Log.log.info(
            'chatgpt get status code:${response.statusCode} ,body:${response.body}');
        rt.text = response.body.toString();
        return rt;
      }
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      Log.log.fine(decodedResponse);
      rt.parentMessageId = decodedResponse['id'] ?? '';
      rt.status = true;
      rt.text = decodedResponse['text'];
      return rt;
    } catch (e) {
      Log.log.warning('chatGPTProxy exception: $e');
      rt.text = e.toString();
      return rt;
    }
  }

  Future<ChatGPTResWithMotion> sendMessgeRequiresMotion(String text,
      String parentMessageId, String model, String systemMessage) async {
    var rt = ChatGPTResWithMotion();
    systemMessage += AgentPromts.askWithMotionFewShot;
    text += AgentPromts.askWithMotion;
    ChatGPTRes res =
        await sendMessage(text, parentMessageId, model, systemMessage);
    if (!res.status) {
      rt.text = res.text;
      return rt;
    }
    rt.status = res.status;
    rt.parentMessageId = res.parentMessageId;
    try {
      Map<String, dynamic>? outputMap;
      String jsonStr = extractJsonPart(res.text);
      outputMap = jsonDecode(jsonStr);
      if (outputMap == null) {
        rt.text = res.text;
        return rt;
      }

      if (outputMap['reply'] != null) {
        rt.text = outputMap['reply'];
        rt.motions = outputMap['motions'] ?? '';
        rt.style = outputMap['style'] ?? '';
      } else {
        rt.text = res.text;
      }
      return rt;
    } catch (e) {
      Log.log.info('chatGPTProxy sendMessgeRequiresMotion got exception: $e');
      rt.text = res.text;
      return rt;
    }
  }
}
