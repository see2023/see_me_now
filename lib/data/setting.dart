import 'package:see_me_now/data/constants.dart';
import 'package:hive/hive.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/ml/agent/agent_prompts.dart';

class SettingKeyConstants {
  static const String seeProxyUrlPrefix = 'seeProxyUrlPrefix';
  static const String seeProxyUser = 'seeProxyUser';
  static const String seeProxyKeyKey = 'seeProxyKey';
  static const String autoPlayVoice = 'autoPlayVoice';
  static const String tapPlayVoice = 'tapPlayVoice';
  static const String enableCamera = 'enableCamera';
  static const String enableAIReplyFromCamera = 'enableAIReplyFromCamera';
  static const String enablePoseReminder = 'enablePoseReminder';
  static const String defaultPromptId = 'defaultPromptId';
  static const String userNickname = 'userNickname';
  static const String userDescription = 'userDescription';
}

class Setting {
  bool autoPlayVoice = false;
  bool tapPlayVoice = true;
  bool enableCamera = true;
  bool enableAIReplyFromCamera = true;
  bool enablePoseReminder = true;
  String userNickname = '';
  String userDescription = '';
  Box? _settingsBox;
  init(String settingFilePath) async {
    Hive.init(settingFilePath);
    _settingsBox = await Hive.openBox('settings.db');
    var url = _settingsBox?.get(SettingKeyConstants.seeProxyUrlPrefix);
    if (url == null) {
      Log.log.info('DB initing for first time, setting default values');
      _settingsBox?.put(SettingKeyConstants.seeProxyUrlPrefix,
          SettingValueConstants.seeProxyUrlPrefix);
      _settingsBox?.put(
          SettingKeyConstants.seeProxyUser, SettingValueConstants.seeProxyUser);
      _settingsBox?.put(SettingKeyConstants.seeProxyKeyKey,
          SettingValueConstants.seeProxyKey);
    }
    DB.setting.autoPlayVoice =
        _settingsBox?.get(SettingKeyConstants.autoPlayVoice) ?? false;
    DB.setting.tapPlayVoice =
        _settingsBox?.get(SettingKeyConstants.tapPlayVoice) ?? true;
    DB.setting.enableCamera =
        _settingsBox?.get(SettingKeyConstants.enableCamera) ?? true;
    DB.setting.enableAIReplyFromCamera =
        _settingsBox?.get(SettingKeyConstants.enableAIReplyFromCamera) ?? true;
    DB.setting.enablePoseReminder =
        _settingsBox?.get(SettingKeyConstants.enablePoseReminder) ?? true;
    DB.setting.userNickname =
        _settingsBox?.get(SettingKeyConstants.userNickname) ?? '普罗米修斯';
    DB.setting.userDescription =
        _settingsBox?.get(SettingKeyConstants.userDescription) ?? 'a pupil';
    AgentPromts.changeGptPromptPrefix(
        DB.setting.userNickname, DB.setting.userDescription);
  }

  close() {
    _settingsBox?.close();
  }

  String getString(String key) {
    return _settingsBox?.get(key) ?? '';
  }

  Future<void> putString(String key, String value) async {
    await _settingsBox?.put(key, value);
  }

  int getInt(String key) {
    return _settingsBox?.get(key) ?? 0;
  }

  Future<void> putInt(String key, int value) async {
    await _settingsBox?.put(key, value);
  }

  void changeSetting(String key, String value) {
    switch (key) {
      case SettingKeyConstants.autoPlayVoice:
        DB.setting.autoPlayVoice = value == 'true';
        _settingsBox?.put(
            SettingKeyConstants.autoPlayVoice, DB.setting.autoPlayVoice);
        break;
      case SettingKeyConstants.tapPlayVoice:
        DB.setting.tapPlayVoice = value == 'true';
        _settingsBox?.put(
            SettingKeyConstants.tapPlayVoice, DB.setting.tapPlayVoice);
        break;
      case SettingKeyConstants.enableCamera:
        DB.setting.enableCamera = value == 'true';
        _settingsBox?.put(
            SettingKeyConstants.enableCamera, DB.setting.enableCamera);
        break;
      case SettingKeyConstants.enableAIReplyFromCamera:
        DB.setting.enableAIReplyFromCamera = value == 'true';
        _settingsBox?.put(SettingKeyConstants.enableAIReplyFromCamera,
            DB.setting.enableAIReplyFromCamera);
        break;
      case SettingKeyConstants.enablePoseReminder:
        DB.setting.enablePoseReminder = value == 'true';
        _settingsBox?.put(SettingKeyConstants.enablePoseReminder,
            DB.setting.enablePoseReminder);
        break;
      case SettingKeyConstants.userNickname:
        DB.setting.userNickname = value;
        _settingsBox?.put(
            SettingKeyConstants.userNickname, DB.setting.userNickname);
        AgentPromts.changeGptPromptPrefix(
            DB.setting.userNickname, DB.setting.userDescription);
        break;
      case SettingKeyConstants.userDescription:
        DB.setting.userDescription = value;
        _settingsBox?.put(
            SettingKeyConstants.userDescription, DB.setting.userDescription);
        AgentPromts.changeGptPromptPrefix(
            DB.setting.userNickname, DB.setting.userDescription);
        break;
    }
  }
}
