import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:see_me_now/api/chatgpt/chatgpt_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/ml/agent/agent_prompts.dart';
import 'package:see_me_now/ui/agent/ask_widget.dart';
import 'package:see_me_now/tools/string_tools.dart';

class MyAction {
  SeeAction? act;
  Map<String, dynamic>? inputMap;
  String sysPromptText = '';
  Map<String, dynamic>? outputMap;
  MyAction(int goalId, int taskId, ActionType type, String input,
      {String sysPrompt = '', Map<String, dynamic> inMap = const {}}) {
    if (type == ActionType.none) {
      return;
    }
    if (sysPrompt == '' && AgentPromts.agentPrompts.containsKey(type)) {
      sysPromptText = AgentPromts.agentPrompts[type] ?? '';
    } else {
      sysPromptText = sysPrompt;
    }
    inputMap = inMap;
    act = SeeAction()
      ..goalId = goalId
      ..taskId = taskId
      ..type = type;
    if (input.isEmpty) {
      if (inMap.isNotEmpty) {
        input = inMap.toString();
      } else {
        getInputFromLastAction();
        return;
      }
    }
    act!.input = input;
    saveToDB();
  }
  saveToDB() async {
    if (act == null) {
      return;
    }
    await DB.isar?.writeTxn(() async {
      act?.id = await DB.isar?.seeActions.put(act!) ?? 0;
    });
  }

  fromJsonString(String jsonstr) {
    // parse jsonStr, and set the fields of act
  }

  Future<Map<String, dynamic>?> askGptInJson(
      String sysPromptText, Map<String, dynamic> inputMap) async {
    String prompts = inputMap.toString();
    String parentMessageId = '';
    for (var i = 0; i < 2; i++) {
      try {
        ChatGPTRes res = await DB.chatGPTProxy.sendMessage(
            prompts,
            parentMessageId,
            '',
            DB.promptsMap[DB.firstPromptId]?.model ?? '',
            sysPromptText,
            true);
        if (res.status == false) {
          Log.log.warning('$i askGpt error: ${res.text}');
          return null;
        }
        parentMessageId = res.parentMessageId;
        try {
          act?.output = extractJsonPart(res.text);
          if (act?.output == null || act?.output == '') {
            Log.log.warning('$i askGpt return json error: ${res.text}');
            prompts = AgentPromts.askForJson;
            continue;
          }
          outputMap = jsonDecode(act?.output ?? '');
          Log.log.fine('$i askGpt return: ${res.text}');
          return outputMap;
        } catch (e) {
          prompts = AgentPromts.askForJson;
          Log.log.warning('$i askGpt json parse error: ${res.text}}');
          continue;
        }
      } catch (e) {
        Log.log.warning('$i askGpt error: $e');
        return null;
      }
    }
    return null;
  }

  Future<String> getInputFromLastAction() async {
    // get input from last action
    SeeAction? lastAction = DB.isar?.seeActions
        .where()
        .idNotEqualTo(act?.id ?? 0)
        .sortByStartTimeDesc()
        .findFirstSync();

    if (lastAction != null) {
      act?.input = lastAction.output;
      // save to db
      saveToDB();
    }
    return act!.input;
  }

  Future<String> excute() async {
    if (act == null) {
      return '';
    }
    switch (act?.type) {
      case ActionType.askUserForCreateTask:
        // ask user for create task
        try {
          // act?.output = await Get.dialog(AskWidget(
          //   tips: act!.input,
          //   onSubmitted: (ret) {
          //     Get.back(result: ret);
          //   },
          // ));
          await showDialog(
            barrierColor: Colors.transparent,
            context: Get.context!,
            builder: (_) => AskWidget(
                tips: act!.input,
                onSubmitted: (ret) {
                  act?.output = ret;
                }),
          );
          Log.log.fine('askUserForCreateTask return: ${act?.output}}');
        } catch (e) {
          Log.log.warning('askUserForCreateTask error: $e');
        }
        break;
      case ActionType.askGptForCreateTask:
      case ActionType.askGptForNewExperience:
        await askGptInJson(sysPromptText, inputMap!);
        break;
      case ActionType.queryRawData:
        // query raw data from camera
        break;
      default:
        break;
    }
    act!.endTime = DateTime.now();
    saveToDB();
    return act!.output;
  }
}
