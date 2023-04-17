// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:get/get.dart';
import 'package:see_me_now/api/chatgpt/chatgpt_proxy.dart';
import 'package:see_me_now/data/constants.dart';
import 'package:see_me_now/data/models/topic.dart';
import 'package:see_me_now/main.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/tools/voice_assistant.dart';
import 'package:see_me_now/ui/home_page.dart';

// A StatefulWidget for chat

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, this.chatId = 0});

  final int chatId;

  @override
  State<StatefulWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  int topicId = 0;
  int topicIdFromDB = 0;
  bool disposed = false;
  final HomeController c = Get.put(HomeController());

  final String name = '...';
  final List<types.Message> _messages = [];
  final _me = const types.User(
      id: SettingValueConstants.me, lastName: SettingValueConstants.me);
  final _users = <String, types.User>{};
  final List<ApiState> _apis = [];
  late int _promptIdUsed = 0;
  String _activeUser = '';
  String _newTopicName = '';

  _ChatWidgetState() {
    _users[SettingValueConstants.openai] = const types.User(
        id: SettingValueConstants.openai,
        lastName: SettingValueConstants.openai);
    _next();
    Log.log.fine('creating chat widget, default user: $_activeUser');
    _initApis();
  }

  void _initApis() {
    _apis.clear();
    var openai = ApiState();
    openai.apiId = SettingValueConstants.openai;
    openai.enabled = true;
    _apis.add(openai);
  }

  void _next() {
    _activeUser = SettingValueConstants.openai;
  }

  String getUserNames() {
    String ret = '';
    for (ApiState api in _apis) {
      if (ret.isNotEmpty) {
        ret += ', ';
      }
      ret += api.apiId!;
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      if (widget.chatId > 0 && topicId == 0) {
        topicId = widget.chatId;
      }
      if (homeController.topicId >= 0) {
        topicId = homeController.topicId;
      }
      String promtName = DB.promptsMap[DB.defaultPromptId]?.name ?? '';
      if (topicId != topicIdFromDB) {
        Log.log.fine('clear old messages: $topicIdFromDB');
        _messages.clear();
        _initApis();
        topicIdFromDB = topicId;
        if (topicId > 0) {
          // read chat history from db
          DB.getTopic(topicId).then((Topic topic) {
            _promptIdUsed = topic.promptId ?? 0;
            Log.log.fine(
                'building chat widget from db, get promptId: $_promptIdUsed');
            if (_promptIdUsed > 0) {
              promtName = DB.promptsMap[_promptIdUsed]?.name ?? '';
              DB.azureProxy.setVoiceParams(
                  DB.promptsMap[_promptIdUsed]?.voiceName ?? '');
            }
            MyApp.changeHomeTitle(promtName);
            if (topic.apiStates != null && topic.apiStates!.isNotEmpty) {
              _apis.clear();
              _apis.addAll(topic.apiStates!);
              _users.clear();
              for (var i = 0; i < topic.apiStates!.length; i++) {
                String id = topic.apiStates![i].apiId ?? '';
                _users[id] = types.User(id: id, lastName: id);
              }
              setState(() {
                _activeUser = topic.apiStates!.first.apiId!;
              });
            }
          });
          DB.getMessages(topicId: topicId, limit: 100).then((msgs) {
            Log.log.fine('building chat widget, get msgs: ${msgs.length}');
            setState(() {
              _messages.addAll(msgs);
            });
          });
        }
      }
      Log.log.info(
          'building chat widget, id: $topicId, name:$name, promtName: $promtName');
      return Stack(children: [
        //chat window
        Chat(
          theme: const DarkChatTheme(
            backgroundColor: Colors.transparent,
            primaryColor: Colors.transparent,
            secondaryColor: Colors.transparent,
          ),
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _me,
          showUserNames: true,
          showUserAvatars: false,
          onMessageDoubleTap: onMessageTap,
          onMessageTap: onMessageTap,
          textMessageOptions: TextMessageOptions(matchers: [
            MatchText(
              pattern: '```[^`]+```',
              style: PatternStyle.code.textStyle,
              renderText: ({required String str, required String pattern}) => {
                'display': str.replaceAll(
                  '```',
                  '',
                ),
              },
            ),
          ]),
        ),
        //close icon, click to close chat window
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey,
            iconSize: 36,
            onPressed: () {
              Log.log.fine('close chat widget');
              c.setTopicId(-1);
            },
          ),
        ),
      ]);
    });
  }

  @override
  void dispose() {
    disposed = true;
    Log.log.fine('$name chat widget dispose');
    super.dispose();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    late String text;
    bool firstMessage = _messages.isEmpty;
    if (firstMessage) {
      _promptIdUsed = DB.defaultPromptId;
      _newTopicName =
          '[${DB.promptsMap[_promptIdUsed]?.name ?? 'Assistant'}] ${message.text}';
      DB.azureProxy
          .setVoiceParams(DB.promptsMap[_promptIdUsed]?.voiceName ?? '');
      Log.log.fine('first message, got promptId: $_promptIdUsed');
    }
    text = message.text;
    final textMessage = types.TextMessage(
      author: _me,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DB.uuid.v4(),
      text: text,
    );
    Log.log.fine(
        'sending message: ${textMessage.text}, parent id: ${_apis[0].parentMessageId}, promptId: $_promptIdUsed');
    _addMessage(textMessage);

    await processMessage(textMessage);
    DB.chatGPTProxy
        .sendMessage(
            textMessage.text,
            _apis[0].parentMessageId ?? '',
            _apis[0].conversationId ?? '',
            // _apis[0].model ?? '', // only one api now ...
            DB.promptsMap[_promptIdUsed]?.model ?? '',
            DB.promptsMap[_promptIdUsed]?.text ?? '',
            firstMessage)
        .then((ChatGPTRes res) {
      Log.log.fine('got response: ${res.parentMessageId}');
      final resMessage = types.TextMessage(
        author: _users[_activeUser]!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DB.uuid.v4(),
        text: res.text,
      );
      if (!disposed) {
        _addMessage(resMessage);
      }
      processMessage(resMessage,
          parentMessageId: res.parentMessageId,
          conversationId: res.conversationId,
          speech: true);
    });
  }

  Future<int> processMessage(types.TextMessage message,
      {String parentMessageId = '',
      String conversationId = '',
      bool speech = false}) async {
    if (parentMessageId.isNotEmpty) {
      _apis[0].parentMessageId = parentMessageId;
    }
    if (conversationId.isNotEmpty) {
      _apis[0].conversationId = conversationId;
    }
    int ret = await DB.saveMessage(topicId, message, _apis,
        promptId: _promptIdUsed, topicName: _newTopicName);
    if (topicId == 0) {
      topicId = ret;
      await MyApp.latestTopics.refreshFromDB();
      await MyApp.allTopics.refreshFromDB();
      c.setTopicId(topicId);
    } else {
      await MyApp.latestTopics.refreshFromDB();
      MyApp.allTopics.update(topicId, message.text);
    }
    if (DB.setting.autoPlayVoice && speech) {
      playSpeech(message);
    }
    return ret;
  }

  void onMessageTap(context, types.Message message) async {
    Log.log.fine('onMessageTap / DoubleTap: ${message.id}');
    if (DB.setting.tapPlayVoice && message is types.TextMessage) {
      playSpeech(message);
    }
  }

  void playSpeech(types.TextMessage message) async {
    if (message.id.isNotEmpty && message.text.isNotEmpty) {
      var rt =
          await DB.azureProxy.textToWavAndVisemes(message.text, message.id);
      if (rt.status) {
        Log.log.fine(
            'start sending visemes to webview, ${rt.visemesText.length} visemes');
        MyApp.glbViewerStateKey.currentState!.sendVisemes(rt.visemesText);
        MyApp.homePageStateKey.currentState!.changeOpacity(false);
        VoiceAssistant.play(rt.wavFilePath);
      }
    }
  }
}
