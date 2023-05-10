// show simple text content in String, List<String>, or Json format.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AwsomeText extends StatelessWidget {
  // make the text looks better
  final String? text;
  const AwsomeText({Key? key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
        height: 1.3,
        fontSize: 19,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
    );
  }
}

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
            // margin: const EdgeInsets.all(5),
            padding:
                const EdgeInsets.only(top: 95, left: 10, right: 5, bottom: 20),
            child: text != null
                ? AwsomeText(
                    text: text,
                  )
                : texts != null
                    ? Column(
                        children:
                            texts!.map((e) => AwsomeText(text: e)).toList(),
                      )
                    : json != null
                        ? AwsomeText(text: json.toString())
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
