// show simple text content in String, List<String>, or Json format.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TxtShowWidget extends StatelessWidget {
  final String? text;
  final List<String>? texts;
  final Map<String, dynamic>? json;
  const TxtShowWidget({Key? key, this.text, this.texts, this.json})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 0.75,
        child: Stack(children: [
          Container(
            padding:
                const EdgeInsets.only(top: 90, left: 5, right: 5, bottom: 20),
            child: text != null
                ? Text(text!)
                : texts != null
                    ? Column(
                        children: texts!.map((e) => Text(e)).toList(),
                      )
                    : json != null
                        ? Text(json.toString())
                        : const Text(''),
          ),
          Positioned(
            top: 50,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white70,
              iconSize: 36,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
