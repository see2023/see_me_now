import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:see_me_now/data/constants.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:card_settings/card_settings.dart';
import 'package:see_me_now/data/setting.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    Log.log.fine('building setting page');
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('See Settings'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: const SettingWidget(),
        ));
  }
}

class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _customUrlVisible = false;
  bool _cameraEnabled = false;
  bool _aiReplyEnabled = false;
  String _proxyUrl = '';

  @override
  Widget build(BuildContext context) {
    _proxyUrl = DB.seeProxy.urlPrefix;
    String initItem = SettingValueConstants.proxyUrls
        .firstWhere((element) => element == _proxyUrl, orElse: () => 'custom');
    if (initItem == 'custom') {
      _customUrlVisible = true;
    }
    if (DB.setting.enableCamera) {
      _cameraEnabled = true;
    }
    if (DB.setting.enableAIReplyFromCamera) {
      _aiReplyEnabled = true;
    }
    String userAndKey = '${DB.seeProxy.user}-';
    userAndKey +=
        DB.seeProxy.key.replaceAll(RegExp(r'.', multiLine: true), '*');
    Log.log.fine('building setting widget: $_proxyUrl, $userAndKey');
    return Form(
      key: _formKey,
      child: CardSettings(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        children: <CardSettingsSection>[
          CardSettingsSection(
              header: CardSettingsHeader(
                label: 'CameraObserver'.tr,
              ),
              children: <CardSettingsWidget>[
                CardSettingsSwitch(
                  key: const Key('enableCamera'),
                  label: 'Camera'.tr,
                  initialValue: DB.setting.enableCamera,
                  onChanged: (value) {
                    Log.log.fine('changing enableCamera: $value');
                    DB.setting.changeSetting(SettingKeyConstants.enableCamera,
                        value ? 'true' : 'false');
                    if (!value) {
                      // disable AI reply button below when camera is disabled
                      // disable enableAIReplyFromCamera button
                      setState(() {
                        _cameraEnabled = false;
                      });

                      // save related settings
                      DB.setting.changeSetting(
                          SettingKeyConstants.enablePoseReminder, 'false');
                      DB.setting.changeSetting(
                          SettingKeyConstants.enableAIReplyFromCamera, 'false');
                    } else {
                      setState(() {
                        _cameraEnabled = true;
                      });
                      DB.setting.changeSetting(
                          SettingKeyConstants.enablePoseReminder, 'true');
                      DB.setting.changeSetting(
                          SettingKeyConstants.enableAIReplyFromCamera, 'true');
                    }
                  },
                ),
                CardSettingsSwitch(
                  key: const Key('enablePoseReminder'),
                  label: 'PoseReminder'.tr,
                  initialValue: DB.setting.enablePoseReminder,
                  visible: _cameraEnabled,
                  onChanged: (value) {
                    Log.log.fine('changing enableCameraReply: $value');
                    DB.setting.changeSetting(
                        SettingKeyConstants.enablePoseReminder,
                        value ? 'true' : 'false');
                    if (!value) {
                      setState(() {
                        _aiReplyEnabled = false;
                      });
                      DB.setting.changeSetting(
                          SettingKeyConstants.enableAIReplyFromCamera, 'false');
                    } else {
                      setState(() {
                        _aiReplyEnabled = true;
                      });
                      DB.setting.changeSetting(
                          SettingKeyConstants.enableAIReplyFromCamera, 'true');
                    }
                  },
                ),
                CardSettingsSwitch(
                  key: const Key('enableAIReplyFromCamera'),
                  label: 'PoseAIReply'.tr,
                  initialValue: DB.setting.enableAIReplyFromCamera,
                  visible: _cameraEnabled,
                  enabled: _aiReplyEnabled,
                  onChanged: (value) {
                    Log.log.fine('changing enableAIReplyFromCamera: $value');
                    DB.setting.changeSetting(
                        SettingKeyConstants.enableAIReplyFromCamera,
                        value ? 'true' : 'false');
                  },
                ),
              ]),
          CardSettingsSection(
              header: CardSettingsHeader(
                label: 'VoiceReply'.tr,
              ),
              children: <CardSettingsWidget>[
                CardSettingsSwitch(
                  key: const Key('autoPlayVoice'),
                  label: 'AutoPlay'.tr,
                  initialValue: DB.setting.autoPlayVoice,
                  onChanged: (value) {
                    Log.log.fine('changing auto play: $value');
                    DB.setting.changeSetting(SettingKeyConstants.autoPlayVoice,
                        value ? 'true' : 'false');
                  },
                ),
                CardSettingsSwitch(
                  key: const Key('tapPlaySpeech'),
                  label: 'TaptoPlay'.tr,
                  initialValue: DB.setting.tapPlayVoice,
                  onChanged: (value) {
                    Log.log.fine('changing tap play: $value');
                    DB.setting.changeSetting(SettingKeyConstants.tapPlayVoice,
                        value ? 'true' : 'false');
                  },
                ),
              ]),
          // set user nickname and description
          CardSettingsSection(
              header: CardSettingsHeader(
                label: 'UserProfile'.tr,
              ),
              children: <CardSettingsWidget>[
                CardSettingsText(
                  key: const Key('userNickname'),
                  label: 'UserNickname'.tr,
                  maxLength: 256,
                  initialValue: DB.setting.userNickname,
                  validator: (newNickname) {
                    if (newNickname == null || newNickname.isEmpty) {
                      return 'Must be a valid nickname.';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    Log.log.fine('changing nickname: $value');
                    DB.setting
                        .changeSetting(SettingKeyConstants.userNickname, value);
                  },
                ),
                CardSettingsParagraph(
                  key: const Key('userDescription'),
                  label: 'UserDescription'.tr,
                  maxLength: 256,
                  initialValue: DB.setting.userDescription,
                  onChanged: (value) {
                    Log.log.fine('changing user description: $value');
                    DB.setting.changeSetting(
                        SettingKeyConstants.userDescription, value);
                  },
                ),
              ]),
          CardSettingsSection(
            header: CardSettingsHeader(
              label: 'See Proxy',
            ),
            children: <CardSettingsWidget>[
              CardSettingsListPicker(
                key: const Key('URL'),
                label: 'URL',
                items: SettingValueConstants.proxyUrls,
                initialItem: initItem,
                onChanged: (value) {
                  Log.log.fine('changing url: $value');
                  if (value == 'custom') {
                    setState(() {
                      _customUrlVisible = true;
                      _proxyUrl = value ?? '';
                    });
                  } else {
                    setState(() {
                      _customUrlVisible = false;
                    });
                    DB.seeProxy.setParam(urlPrefix: value ?? '', saveDB: true);
                  }
                },
              ),
              CardSettingsText(
                  key: const Key('customUrl'),
                  label: 'My URL',
                  maxLength: 256,
                  initialValue: _proxyUrl,
                  visible: _customUrlVisible,
                  validator: (newUrl) {
                    if (newUrl == null || !newUrl.startsWith('http')) {
                      return 'Must be a valid url.';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (newUrl) {
                    Log.log.fine('saving url: $newUrl');
                    DB.seeProxy.setParam(urlPrefix: newUrl, saveDB: true);
                  }),
              CardSettingsText(
                  key: const Key('userAndKey'),
                  label: 'Key',
                  initialValue: userAndKey,
                  maxLength: 200,
                  // '${DB.seeProxy.user}-${DB.seeProxy.key}',
                  validator: (newKey) {
                    if (newKey == null ||
                        newKey.isEmpty ||
                        !newKey.contains('-')) {
                      return 'key is required.';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (newKey) {
                    Log.log.fine('changing key: $newKey');
                    if (newKey.isNotEmpty) {
                      DB.seeProxy.setParam(userAndKey: newKey, saveDB: true);
                    }
                  },
                  onSaved: (newKey) {
                    Log.log.fine('saving key: $newKey');
                    DB.seeProxy
                        .setParam(userAndKey: newKey ?? '', saveDB: true);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
