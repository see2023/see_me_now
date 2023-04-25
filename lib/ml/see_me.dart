import 'package:get/get.dart';
import 'package:see_me_now/api/chatgpt/chatgpt_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/main.dart';
import 'package:see_me_now/ml/me.dart';
import 'package:see_me_now/tools/voice_assistant.dart';
import 'package:see_me_now/ui/home_page.dart';

class TalkData {
  List<int> lastSits = <int>[];
  List<int> lastExcitings = <int>[];

  List<int> reduceList(List<int> list, int count) {
    List<int> ret = <int>[];
    for (int i = 0; i < list.length; i += count) {
      double sum = 0;
      for (int j = 0; j < count; j++) {
        if (i + j < list.length) {
          sum += list[i + j];
        } else {
          break;
        }
      }
      ret.add((sum / count).round());
    }
    return ret;
  }

  @override
  String toString() {
    // reduce listSits and listExcitings to 10 elements, every element is average of 6 elements
    List<int> tmpSit = reduceList(lastSits, 6);
    List<int> tmpExcitings = reduceList(lastExcitings, 6);
    // Log.log.fine(
    //     'Silence debug: tmpSit: $tmpSit, tmpExcitings: $tmpExcitings, lastSits: $lastSits, lastExcitings: $lastExcitings');
    return '{ sit: $tmpSit, exciting: $tmpExcitings}';
  }
}

class SeeMe {
  // timestamp to record last talking time with ai
  DateTime lastTalkTime = DateTime.now();
  int talkInterval = 60; // seconds
  String parentMessageId = '';
  int talkTime = 0;

  gotData(List<StatData> statList) {
    int len = statList.length;
    if (len == 0) return;
    DateTime now = DateTime.now();
    int timeDiff = now.difference(lastTalkTime).inSeconds;
    if (timeDiff < talkInterval) {
      Log.log.fine(
          'SilenceTalk gotData, time diff: $timeDiff, wait for next data');
      return;
    }
    TalkData data = TalkData();
    for (int i = 0; i < len; i++) {
      StatData stat = statList[i];
      if (stat.insertTime.isBefore(lastTalkTime)) {
        continue;
      }
      if (stat.isSmile > 0.5) {
        data.lastExcitings.add(1);
      } else {
        data.lastExcitings.add(0);
      }
      if (stat.status == MyStatus.askew) {
        data.lastSits.add(0);
      } else if (stat.status == MyStatus.upright) {
        data.lastSits.add(1);
      }
    }
    lastTalkTime = now;
    String talkStr = data.toString();
    Log.log.info(
        'SilenceTalk gotData len: ${data.lastSits.length}, talking string: $talkStr');
    data.lastExcitings.clear();
    data.lastSits.clear();
    talkToAI(talkStr);
  }

  talkToAI(String text) async {
    final HomeController c = Get.put(HomeController());
    if (c.topicId >= 0) {
      Log.log.info('skip talking to ai, topicId: ${c.topicId}');
      return;
    }
    String promptText = '''
You only need to watch the child in front of you and maintain a normal learning state. 
You are given two arrays of input, which respectively record the sitting posture and exciting smile value of the child at the uniformly sampled time points in the last minute. 
The value range of sitting posture is 0 or 1, where 1 represents sitting posture. 
The value of exciting is 0 or 1, where 1 represents excitement; when in a long-term excited state, you need to let him calm down. 
For example, if you receive {sit: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], exciting: [0, 0, 0, 0, 0, 0, 0, 0, 1, 0]}, you need to remind the child to sit upright; 
if the excitement is not too high, there is no need to remind. 
If you receive {sit: [0, 1, 1, 1, 1, 1, 1, 1, 1, 1], exciting: [1 ,1 ,1 ,1 ,1 ,1 ,0 ,1 ,1 ,1]}, 
you need to praise the child for sitting more and more upright but being too excited and need to tell the child to calm down. 
Next minute you will receive two arrays and then give corresponding reminders based on these two sets of data. 
The response content should be short and easy to understand and should not exceed twenty words; encouragement is the main content and interesting. 
''';
    promptText += DB.promptsMap[DB.firstPromptId]?.text ?? '';
    DB.chatGPTProxy
        .sendMessage(
            text,
            parentMessageId,
            '',
            DB.promptsMap[DB.firstPromptId]?.model ?? '',
            promptText,
            talkTime == 0)
        .then((ChatGPTRes res) async {
      if (res.status == false) {
        Log.log.warning('got error response: ${res.text}');
        return;
      }
      talkTime++;
      parentMessageId = res.parentMessageId;
      Log.log.fine('got ai text response: ${res.text}');
      var rt = await DB.azureProxy.textToWavAndVisemes(
          res.text, res.parentMessageId,
          thisVoiceName: DB.promptsMap[DB.firstPromptId]?.voiceName ?? '');
      if (rt.status) {
        Log.log.fine(
            'start sending visemes to webview, got ${rt.visemesText.length} visemes');
        MyApp.glbViewerStateKey.currentState!.sendVisemes(rt.visemesText);
        MyApp.homePageStateKey.currentState!.changeOpacity(false);
        c.setReminderTxt(res.text);
        VoiceAssistant.play(rt.wavFilePath, clearReminderTxt: true);
      }
    });
  }
}
