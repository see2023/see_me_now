import 'package:see_me_now/data/constants.dart';
import 'package:hive/hive.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';

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
}

class Setting {
  bool autoPlayVoice = false;
  bool tapPlayVoice = true;
  bool enableCamera = true;
  bool enableAIReplyFromCamera = false;
  bool enablePoseReminder = true;
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
        _settingsBox?.get(SettingKeyConstants.enableAIReplyFromCamera) ?? false;
    DB.setting.enablePoseReminder =
        _settingsBox?.get(SettingKeyConstants.enablePoseReminder) ?? false;
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
    }
  }
}
