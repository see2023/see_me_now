// show simple text content in String, List<String>, or Json format.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:see_me_now/ml/agent/agent_data.dart';

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

// show quiz (question and answer)
// with a button click to show answer
class QuizWidget extends StatefulWidget {
  final QuizInfo? quizInfo;
  final Future<bool> Function(QuizInfo, String, bool) markingQuizCallback;
  const QuizWidget(
      {Key? key, required this.quizInfo, required this.markingQuizCallback})
      : super(key: key);

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  bool showAnswer = false;
  String userAnswer = '';
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
            child: Column(
              children: [
                AwsomeText(text: widget.quizInfo!.question),
                const SizedBox(height: 20),
                TextField(
                  maxLines: null,
                  enabled: !showAnswer,
                  onChanged: (value) {
                    userAnswer = value;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'MyAnswer'.tr,
                  ),
                ),

                // show answer
                showAnswer
                    ? AwsomeText(text: widget.quizInfo!.answer)
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAnswer = true;
                          });
                        },
                        child: Text('ShowAnswer'.tr),
                      ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            child: showAnswer
                ? IconButton(
                    icon: const Icon(Icons.done),
                    color: Colors.white70,
                    iconSize: 36,
                    onPressed: () {
                      widget.markingQuizCallback(
                          widget.quizInfo!, userAnswer, false);
                      Get.back();
                    },
                  )
                : // show an delete button with text, not iconbutton
                TextButton(
                    onPressed: () {
                      widget.markingQuizCallback(widget.quizInfo!, '', true);
                      Get.back();
                    },
                    child: Text('Discard'.tr),
                  ),
          ),
        ]),
      ),
    );
  }
}
