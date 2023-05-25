import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:see_me_now/api/azure/bing.dart';
import 'package:see_me_now/api/chatgpt/chatgpt_proxy.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/main.dart';
import 'package:see_me_now/ml/agent/agent_prompts.dart';
import 'package:see_me_now/ui/agent/ask_widget.dart';
import 'package:see_me_now/tools/string_tools.dart';

class MyAction {
  static const int gptCost = 10;
  static const int searchCost = 1;
  static const int searchAndSummaryCost = 11;
  double temperature = 0.5;
  SeeAction? act;
  Map<String, dynamic>? inputMap;
  String sysPromptText = '';
  String outputJsonFormat = '';
  String parentMessageId = '';
  Map<String, dynamic>? outputMap;
  MyAction(int goalId, int taskId, ActionType type, String input,
      {String sysPrompt = '',
      Map<String, dynamic> inMap = const {},
      String parentMessageIdIn = '',
      String outputJsonFormat = ''}) {
    if (type == ActionType.none) {
      return;
    }
    if (sysPrompt == '' && AgentPromts.agentPrompts.containsKey(type)) {
      sysPromptText = AgentPromts.agentPrompts[type] ?? '';
    } else {
      sysPromptText = sysPrompt;
    }
    parentMessageId = parentMessageIdIn;
    outputJsonFormat = outputJsonFormat;
    inputMap = inMap;
    act = SeeAction()
      ..goalId = goalId
      ..taskId = taskId
      ..cost = 1
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
    String prompts = '';
    if (inputMap.isNotEmpty) {
      // prompts = inputMap.toString();
      prompts = jsonEncode(inputMap);
    } else {
      prompts = act!.input;
    }
    String langAndFormat = '\n${DB.getFirstPromt()}\n${AgentPromts.askForJson}';
    prompts += langAndFormat;
    for (var i = 0; i < 2; i++) {
      try {
        ChatGPTRes res = await DB.chatGPTProxy.sendMessage(
            prompts,
            parentMessageId,
            DB.promptsMap[DB.firstPromptId]?.model ?? '',
            sysPromptText,
            temperature: temperature);
        if (res.status == false) {
          Log.log.warning('$i askGpt error: ${res.text}');
          return null;
        }
        parentMessageId = res.parentMessageId;
        try {
          act?.output = extractJsonPart(res.text);
          if (act?.output == null || act?.output == '') {
            Log.log.warning('$i askGpt return json error: ${res.text}');
            prompts = langAndFormat;
            continue;
          }
          outputMap = jsonDecode(act?.output ?? '');
          Log.log.fine('$i askGpt return: ${res.text}');
          return outputMap;
        } catch (e) {
          if (outputJsonFormat != '') {
            prompts = 'outputJsonFormat: $outputJsonFormat,  $langAndFormat';
          } else {
            prompts = langAndFormat;
          }
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
        .filter()
        .goalIdEqualTo(act?.goalId ?? 0)
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
    MyApp.goalManager.agentData.runningAction = true;
    if (act == null) {
      MyApp.goalManager.agentData.runningAction = false;
      return '';
    }
    switch (act?.type) {
      case ActionType.askUserCommon:
        if (act?.input == '') {
          Log.log.warning('askUserCommon input is empty');
          MyApp.goalManager.agentData.runningAction = false;
          return '';
        }

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
            barrierDismissible: false,
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
      case ActionType.askGptForTaskProgressEvaluation:
        act?.cost = MyAction.gptCost.toDouble();
        await askGptInJson(sysPromptText, inputMap!);
        break;
      case ActionType.queryRawData:
        // query raw data from camera
        break;
      case ActionType.search:
        outputMap = {};
        List<BingRecord> records = await DB.bing.search(act?.input ?? '');
        act?.output = records.toString();
        act?.cost = MyAction.searchAndSummaryCost.toDouble();

        break;
      default:
        break;
    }
    act!.endTime = DateTime.now();
    saveToDB();
    MyApp.goalManager.agentData.runningAction = false;
    return act!.output;
  }
}
