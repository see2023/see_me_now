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
            itemCount: DB.promptsMap.length + 1,
            itemBuilder: (context, index) {
              if (index == DB.promptsMap.length) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            int newId = await DB.setPrompt(0);
                            if (newId > 0) {
                              DB.promptsMap[newId] = Prompt()..id = newId;
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.restore),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Reset all prompts?'),
                                    content: const Text(
                                        'This will reset all prompts to default values.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await DB.resetPrompts();
                                          setState(() {});
                                          Get.back();
                                          Get.back();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
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
                          Flexible(
                            flex: 3,
                            child: index == 0
                                ? Text(
                                    prompt.name ?? '',
                                  )
                                : TextFormField(
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
                          Flexible(
                            flex: 2,
                            child: index == 0
                                ? Text('ReservedPrompt'.tr,
                                    style: const TextStyle(
                                        color: Colors.white30, fontSize: 12))
                                : Checkbox(
                                    value: prompt.id == DB.defaultPromptId,
                                    onChanged: (value) {
                                      if (value == true) {
                                        Log.log.info(
                                            'set default prompt to ${prompt.name}(id: $id)');
                                        DB.setDefaultPromptId(prompt.id);
                                      }
                                      setState(() {});
                                      Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        Get.back();
                                      });
                                    }),
                          ),
                          // delete icon button
                          Flexible(
                            flex: 1,
                            child: index == 0
                                ? Container()
                                : IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete prompt?'),
                                              content: const Text(
                                                  'This will delete the prompt.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await DB.deletePrompt(
                                                        prompt.id);
                                                    setState(() {});
                                                    Get.back();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
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
              }
            }));
  }
}
