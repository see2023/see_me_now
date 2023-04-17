// select and setting prompts from list, click more to https://prompts.chat/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/prompts.dart';

class PromptsPage extends StatefulWidget {
  const PromptsPage({Key? key}) : super(key: key);

  @override
  State<PromptsPage> createState() => _PromptsPageState();
}

class _PromptsPageState extends State<PromptsPage> {
  static final List<String> _models = ['gpt-3.5-turbo', 'gpt-4'];
  static final List<String> _voicesNames = [
    'zh-CN-XiaohanNeural',
    'zh-CN-XiaomengNeural',
    'zh-CN-XiaomoNeural',
    'zh-CN-XiaoruiNeural',
    'zh-CN-XiaoshuangNeural',
    'zh-CN-XiaoxiaoNeural',
    'zh-CN-XiaoxuanNeural',
    'zh-CN-XiaoyiNeural',
    'zh-CN-XiaozhenNeural',
    'zh-CN-YunfengNeural',
    'zh-CN-YunhaoNeural',
    'zh-CN-YunjianNeural',
    'zh-CN-YunxiaNeural',
    'zh-CN-YunxiNeural',
    'zh-CN-YunyangNeural',
    'zh-CN-YunyeNeural',
    'zh-CN-YunzeNeural',
    'en-US-AriaNeural',
    'en-US-DavisNeural',
    'en-US-GuyNeural',
    'en-US-JaneNeural',
    'en-US-JasonNeural',
    'en-US-JennyNeural',
    'en-US-NancyNeural',
    'en-US-SaraNeural',
    'en-US-TonyNeural',
  ];
  @override
  Widget build(BuildContext context) {
    Log.log.fine('building prompts page, count: ${DB.promptsMap.length}');
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text('Prompts'),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: DB.promptsMap.length,
            itemBuilder: (context, index) {
              int id = DB.promptsMap.keys.elementAt(index);
              Prompt prompt = DB.promptsMap[id]!;
              String modelName = prompt.model ?? '';
              if (modelName.isEmpty) {
                modelName = _models[0];
              }
              String voiceName = prompt.voiceName ?? '';
              if (voiceName.isEmpty) {
                voiceName = _voicesNames[0];
              }
              Log.log.fine(
                  'building prompt: ${prompt.name}, id: $id, promtModel: $modelName, voiceName: $voiceName');

              return Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(133, 190, 93, 93),
                        width: 3),
                    color: const Color.fromARGB(255, 33, 31, 31),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 56, 55, 55),
                        offset: Offset(2, 1.0),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            initialValue: prompt.name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                DB.promptsMap[id]!.name = value;
                                DB.setPrompt(prompt.id, name: value);
                              });
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Checkbox(
                              value: prompt.id == DB.defaultPromptId,
                              onChanged: (value) {
                                if (value == true) {
                                  Log.log.info(
                                      'set default prompt to ${prompt.name}(id: $id)');
                                  DB.defaultPromptId = id;
                                }
                                setState(() {});
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  Get.back();
                                });
                              }),
                        ),
                      ],
                    ),
                    // edit prompt fields: name, text, model,  voiceName
                    TextFormField(
                      maxLines: null,
                      initialValue: prompt.text,
                      decoration: const InputDecoration(
                        labelText: 'Text',
                      ),
                      onChanged: (value) {
                        setState(() {
                          DB.promptsMap[id]!.text = value;
                          DB.setPrompt(prompt.id, text: value);
                        });
                      },
                    ),
                    SizedBox(
                      // height: 50,
                      // width: 200,
                      child: DropdownButtonFormField<String>(
                        key: Key('model_${prompt.id}'),
                        value: modelName,
                        items: _models
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            DB.promptsMap[id]!.model = value;
                            DB.setPrompt(prompt.id, model: value);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      // height: 200,
                      // width: 300,
                      child: DropdownButtonFormField<String>(
                        key: Key('voice_${prompt.id}'),
                        value: voiceName,
                        items: _voicesNames
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            DB.promptsMap[id]!.voiceName = value;
                            DB.setPrompt(prompt.id, voiceName: value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
