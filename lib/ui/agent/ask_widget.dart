import 'package:flutter/material.dart';
import 'package:get/get.dart';

// AskWidget used for show some tips text, and get response text from user.
// there are two TextFields, one for show tips, another for get response text.
// and one button for submit response text.
class AskWidget extends StatefulWidget {
  final String tips;
  final String? response;
  final Function(String)? onSubmitted;
  const AskWidget(
      {Key? key, required this.tips, this.response, this.onSubmitted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AskWidgetState();
}

class _AskWidgetState extends State<AskWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.response ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 0.75,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.tips),
              TextField(
                maxLines: null,
                controller: _controller,
                onSubmitted: (value) {
                  widget.onSubmitted?.call(value);
                },
              ),
              Row(
                // OK and Cancel button
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 36,
                    onPressed: () {
                      widget.onSubmitted?.call(_controller.text);
                      Get.back();
                    },
                    icon: const Icon(Icons.check),
                  ),
                  IconButton(
                    iconSize: 36,
                    onPressed: () {
                      widget.onSubmitted?.call('');
                      Get.back();
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
