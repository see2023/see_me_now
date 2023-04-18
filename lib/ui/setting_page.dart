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
  bool _aiReplyVisible = false;
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
      _aiReplyVisible = true;
    }
    String userAndKey = '${DB.seeProxy.user}-';
    userAndKey +=
        DB.seeProxy.key.replaceAll(RegExp(r'.', multiLine: true), '*');
    Log.log.fine('building setting widget: $_proxyUrl, $userAndKey');
    return Form(
      key: _formKey,
      child: CardSettings(
        children: <CardSettingsSection>[
          CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Camera Observer',
              ),
              children: <CardSettingsWidget>[
                CardSettingsSwitch(
                  key: const Key('enableCamera'),
                  label: 'Camera',
                  initialValue: DB.setting.enableCamera,
                  onChanged: (value) {
                    Log.log.fine('changing enableCamera: $value');
                    DB.setting.changeSetting(SettingKeyConstants.enableCamera,
                        value ? 'true' : 'false');
                    if (!value) {
                      // disable AI reply button below when camera is disabled
                      // disable enableAIReplyFromCamera button
                      setState(() {
                        _aiReplyVisible = false;
                      });

                      // save setting
                      DB.setting.changeSetting(
                          SettingKeyConstants.enableAIReplyFromCamera, 'false');
                    } else {
                      setState(() {
                        _aiReplyVisible = true;
                      });
                    }
                  },
                ),
                CardSettingsSwitch(
                  key: const Key('enableAIReplyFromCamera'),
                  label: 'AI Reply',
                  initialValue: DB.setting.enableAIReplyFromCamera,
                  visible: _aiReplyVisible,
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
                label: 'Voice Reply',
              ),
              children: <CardSettingsWidget>[
                CardSettingsSwitch(
                  key: const Key('autoPlayVoice'),
                  label: 'Auto Play',
                  initialValue: DB.setting.autoPlayVoice,
                  onChanged: (value) {
                    Log.log.fine('changing auto play: $value');
                    DB.setting.changeSetting(SettingKeyConstants.autoPlayVoice,
                        value ? 'true' : 'false');
                  },
                ),
                CardSettingsSwitch(
                  key: const Key('tabPlaySpeech'),
                  label: 'Tab to Play',
                  initialValue: DB.setting.tapPlayVoice,
                  onChanged: (value) {
                    Log.log.fine('changing tap play: $value');
                    DB.setting.changeSetting(SettingKeyConstants.tapPlayVoice,
                        value ? 'true' : 'false');
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
