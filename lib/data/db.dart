import 'package:isar/isar.dart';
import 'package:see_me_now/api/azure/azure_proxy.dart';
import 'package:see_me_now/api/azure/bing.dart';
import 'package:see_me_now/api/see_proxy.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/message.dart';
import 'package:see_me_now/data/models/prompts.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/data/models/topic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:io' show Directory;
import 'dart:convert';
import 'dart:math';
import 'package:see_me_now/api/chatgpt/chatgpt_proxy.dart';
import 'package:see_me_now/data/setting.dart';
import 'package:uuid/uuid.dart';

class DB {
  static int nameLen = 30;
  static int previewLen = 50;
  static Isar? isar;
  static Setting setting = Setting();
  static SeeProxy seeProxy = SeeProxy();
  static ChatGPTProxy chatGPTProxy = ChatGPTProxy();
  static Bing bing = Bing();
  static AzureProxy azureProxy = AzureProxy();
  static bool status = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  static var uuid = const Uuid();
  static late String cacheDirPath;
  static Map<int, Prompt> promptsMap = {};
  static int defaultPromptId = 0;
  // firstPromptId: used for backgroud AI(SeeMe) chat
  static int firstPromptId = 0;
  static String getDefaultPromptName() {
    return promptsMap[DB.defaultPromptId]?.name ?? 'See';
  }

  static String getFirstPromt() {
    return promptsMap[DB.firstPromptId]?.text ?? '';
  }

  static setDefaultPromptId(int id) {
    DB.defaultPromptId = id;
    setting.putInt(SettingKeyConstants.defaultPromptId, id);
  }

  static Future<bool> init() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      Directory tempDir = await getTemporaryDirectory();
      cacheDirPath = '${tempDir.path}/cache';
      // make sure cache dir exists
      Directory(cacheDirPath).createSync(recursive: true);
      Log.log.info('got cacheDirPath: $cacheDirPath, appDocDir: $appDocPath');

      // initing setting
      await setting.init(appDocPath);

      // initing local db
      isar = await Isar.open([
        MessageSchema,
        TopicSchema,
        PromptSchema,
        SeeGoalSchema,
        SeeGoalExperiencesSchema,
        SeeTaskSchema,
        SeeActionSchema,
        MeStateHistorySchema,
        ConversationSchema
      ]);
      seeProxy.setParam(
          user: setting.getString(SettingKeyConstants.seeProxyUser),
          key: setting.getString(SettingKeyConstants.seeProxyKeyKey),
          urlPrefix: setting.getString(SettingKeyConstants.seeProxyUrlPrefix));
      Log.log.info('DB init() ok, isar opened');
      Log.log.fine(
          'DB init got user: ${seeProxy.user}, key: ${seeProxy.key}, url: ${seeProxy.urlPrefix}');

      // set default prompts
      firstPromptId = await refreshPromptMap();
      if (promptsMap.isEmpty) {
        firstPromptId = await initPrompsIfEmpty();
        await refreshPromptMap();
      }
      defaultPromptId = setting.getInt(SettingKeyConstants.defaultPromptId);
      if (defaultPromptId <= 0) {
        defaultPromptId = firstPromptId;
        Log.log.fine('set defaultPromptId to $defaultPromptId');
        await setting.putInt(
            SettingKeyConstants.defaultPromptId, defaultPromptId);
      } else {
        Log.log.fine('defaultPromptId is $defaultPromptId');
      }

      status = true;
      return true;
    } catch (e) {
      Log.log.shout('DB init() error: $e');
      return false;
    }
  }

  static void close() {
    isar?.close();
    setting.close();
  }

  static Future<List<Topic>> getTopics(int offset, int limit) async {
    Log.log.fine('getTopics() offset: $offset, limit: $limit');
    return isar?.topics
            .where()
            .sortByUpdatedAtDesc()
            .offset(offset)
            .limit(limit)
            .findAllSync() ??
        [];
  }

  static Future<Topic> getTopic(int topicId) async {
    Log.log.fine('getTopic $topicId');
    return isar?.topics.where().idEqualTo(topicId).findFirstSync() ?? Topic();
  }

  static Future<int> _setTopic(
      int topicId,
      String? name,
      String? lastMessagePreview,
      List<ApiState>? apiStates,
      int promptId) async {
    int? ret = -1;
    try {
      // topicId == 0 for insert
      if (topicId == 0) {
        Topic topic = Topic();
        topic.name = name;
        topic.lastMessagePreview = lastMessagePreview;
        topic.apiStates = apiStates;
        topic.createdAt = DateTime.now();
        topic.updatedAt = DateTime.now();
        topic.promptId = promptId;
        ret = await isar?.topics.put(topic);
      } else {
        Topic? topic = await isar?.topics.get(topicId);
        if (topic != null) {
          topic.name = name ?? topic.name;
          topic.lastMessagePreview =
              lastMessagePreview ?? topic.lastMessagePreview;
          topic.apiStates = apiStates ?? topic.apiStates;
          topic.updatedAt = DateTime.now();
          topic.promptId = promptId > 0 ? promptId : topic.promptId;
          ret = await isar?.topics.put(topic);
        } else {
          Log.log.warning('setTopic error: topic not found, topicId: $topicId');
        }
      }
    } catch (e) {
      Log.log.warning('setTopic error: $e');
      return ret ?? -1;
    }
    return ret ?? -1;
  }

  static Future<List<Prompt>> getAllPrompts() async {
    return isar?.prompts.where().findAllSync() ?? [];
  }

  static Future<Prompt> getPrompt(int promptId) async {
    return isar?.prompts.where().idEqualTo(promptId).findFirstSync() ??
        Prompt();
  }

  static Future<int> setPrompt(int promptId,
      {String? name, String? text, String? model, String? voiceName}) async {
    int? ret = -1;
    try {
      await isar?.writeTxn(() async {
        if (promptId == 0) {
          Prompt prompt = Prompt();
          prompt.name = name;
          prompt.text = text;
          prompt.model = model;
          prompt.voiceName = voiceName;
          ret = await isar?.prompts.put(prompt);
        } else {
          Prompt? prompt = await isar?.prompts.get(promptId);
          if (prompt != null) {
            prompt.name = name ?? prompt.name;
            prompt.text = text ?? prompt.text;
            prompt.model = model ?? prompt.model;
            prompt.voiceName = voiceName ?? prompt.voiceName;
            ret = await isar?.prompts.put(prompt);
          } else {
            Log.log.warning(
                'setPrompt error: prompt not found, promptId: $promptId');
          }
        }
      });
    } catch (e) {
      Log.log.warning('setPrompt error: $e');
      return ret ?? -1;
    }
    return ret ?? -1;
  }

  static Future<void> deletePrompt(int promptId) async {
    promptsMap.remove(promptId);
    try {
      await isar?.writeTxn(() async {
        await isar?.prompts.delete(promptId);
      });
    } catch (e) {
      Log.log.warning('deletePrompt error: $e');
    }
  }

  static Future<int> refreshPromptMap() async {
    int defaultPromptId = 0;
    try {
      List<Prompt> prompts = await getAllPrompts();
      promptsMap.clear();
      for (Prompt prompt in prompts) {
        promptsMap[prompt.id] = prompt;
        if (defaultPromptId <= 0) defaultPromptId = prompt.id;
      }
      return defaultPromptId;
    } catch (e) {
      Log.log.warning('refreshPromptMap error: $e');
      return defaultPromptId;
    }
  }

  static Future<int> initPrompsIfEmpty() async {
    int defaultPromptId = 0;
    Log.log.info('initPrompsIfEmpty() initing prompts');
    await setPrompt(0,
        name: 'SeeMe',
        text: 'Please reply in Chinese.',
        model: 'gpt-3.5-turbo',
        voiceName: 'zh-CN-YunxiNeural');
    defaultPromptId = await setPrompt(0,
        name: 'Friend',
        text:
            'I want you to act as my friend. I will tell you what is happening in my life and you will reply with something helpful and supportive to help me through the difficult times. Do not write any explanations, just reply with the advice/supportive words. ',
        model: 'gpt-3.5-turbo',
        voiceName: 'zh-CN-XiaoyiNeural');
    await setPrompt(0,
        name: '辅导老师',
        text: '我是一名小学生，可能问你小学语文、数学、或英语问题，请用100字以内的句子回复我，内容通俗易懂，语句通顺，语法正确，逻辑清晰。',
        model: 'gpt-3.5-turbo',
        voiceName: 'zh-CN-XiaomengNeural');
    await setPrompt(0,
        name: 'English teacher',
        text:
            'I want you to act as a spoken English teacher and improver. I will speak to you in English or other langue, but you will reply to me in English to practice my spoken English. I want you to keep your reply neat, limiting the reply to 100 words. I want you to strictly correct my grammar mistakes, typos, and factual errors.',
        model: 'gpt-3.5-turbo',
        voiceName: 'en-US-AriaNeural');
    await setPrompt(0,
        name: 'English translator',
        text:
            'I want you to act as an English translator, spelling corrector and improver. I will speak to you in any language and you will detect the language, translate it in Short, idiomatic spoken English. I want you to only reply the correction, the improvements and nothing else, do not write explanations.',
        model: 'gpt-3.5-turbo',
        voiceName: 'en-US-JaneNeural');
    await setPrompt(0,
        name: 'Math tearcher',
        text:
            'I want you to act like a math teacher. I input mathematical expressions or mathematical problems,you first analyze the known conditions of the problem, then explain the idea of solving the problem, then explaining the solution approach, then calculating step by step, and finally outputting the final result.',
        model: 'gpt-3.5-turbo',
        voiceName: 'zh-CN-YunhaoNeural');
    return defaultPromptId;
  }

  static Future<void> resetPrompts() async {
    promptsMap.clear();
    await DB.isar?.writeTxn(() async {
      await DB.isar?.prompts.clear();
      Log.log.info('resetPrompts() prompts cleared');
    });
    firstPromptId = await initPrompsIfEmpty();
    await refreshPromptMap();
  }

  //  how to query id > ? order by id desc?
  static Future<List<types.Message>> getMessages(
      {int topicId = 0, DateTime? createdAt, int limit = 10}) async {
    Log.log.fine(
        'getMessages() topicId: $topicId, createdAt: $createdAt, limit: $limit');
    List<Message> msgsDB;
    if (createdAt != null) {
      msgsDB = isar?.messages
              .filter()
              .topicIdEqualTo(topicId)
              .createdAtLessThan(createdAt)
              .sortByCreatedAtDesc()
              .limit(limit)
              .findAllSync() ??
          [];
    } else {
      msgsDB = isar?.messages
              .filter()
              .topicIdEqualTo(topicId)
              .sortByCreatedAtDesc()
              .limit(limit)
              .findAllSync() ??
          [];
    }
    List<types.Message> msgs = [];
    for (var i = 0; i < msgsDB.length; i++) {
      final textMessage = types.TextMessage(
        id: msgsDB[i].uuid!,
        author: types.User(id: msgsDB[i].author!, lastName: msgsDB[i].author!),
        text: msgsDB[i].text,
        showStatus: msgsDB[i].showStatus,
        status: types.Status.values[msgsDB[i].status.index],
        type: types.MessageType.values[msgsDB[i].type.index],
        createdAt: msgsDB[i].createdAt.millisecondsSinceEpoch,
        remoteId: msgsDB[i].remoteId,
        metadata: jsonDecode(msgsDB[i].metadata ?? "{}"),
      );
      msgs.add(textMessage);
    }
    return msgs;
  }

  static Future<int> saveMessage(
      int topocId, types.TextMessage msg, List<ApiState>? apiStates,
      {int promptId = 0, String topicName = ''}) async {
    try {
      Message msgDB = Message();
      msgDB.author = msg.author.id;
      msgDB.text = msg.text;
      msgDB.uuid = msg.id;
      msgDB.showStatus = msg.showStatus ?? false;
      final status = msg.status;
      if (status != null) {
        msgDB.status = Status.values[status.index];
      }
      msgDB.type = MessageType.values[msg.type.index];
      msgDB.createdAt = DateTime.now();
      msgDB.remoteId = msg.remoteId;
      if (msg.metadata != null) {
        msgDB.metadata = jsonEncode(msg.metadata);
      }
      int ret = -1;
      await isar?.writeTxn(() async {
        ret = await _setTopic(
            topocId,
            topocId == 0
                ? topicName.substring(0, min(nameLen, topicName.length))
                : null,
            msg.text.substring(0, min(previewLen, msg.text.length)),
            apiStates,
            promptId);
        Log.log.fine(
            'saveMessage ok topicIdIn: $topocId, topIdOut: $ret, msg: $msg');
        if (topocId == 0) {
          msgDB.topicId = ret;
        } else {
          msgDB.topicId = topocId;
        }
        await isar?.messages.put(msgDB);
      });
      return ret;
    } catch (e) {
      Log.log.warning('saveMessage error: $e');
      return -1;
    }
  }
}
