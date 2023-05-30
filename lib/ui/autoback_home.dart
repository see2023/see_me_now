import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/ui/home_page.dart';

class AutoBackHome extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AutoBackHome(
      {required Key key,
      required this.child,
      this.duration = const Duration(minutes: 1)})
      : super(key: key);

  @override
  State<AutoBackHome> createState() => _AutoBackHomeState();
}

class _AutoBackHomeState extends State<AutoBackHome>
    with WidgetsBindingObserver {
  late DateTime _lastInputTime;
  late Timer _timer;
  bool _isKeyboardOpen = false;
  final HomeController c = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _lastInputTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isKeyboardOpen &&
          DateTime.now().difference(_lastInputTime) >= widget.duration &&
          c.isOpacity) {
        Log.log.fine('AutoBackHome: back to home page');
        c.setTopicId(-1);
        Get.back();
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Log.log.fine('AutoBackHome: onTap');
        _lastInputTime = DateTime.now();
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final value = bottomInset > 0.0;
    if (_isKeyboardOpen != value) {
      setState(() {
        _isKeyboardOpen = value;
        if (_isKeyboardOpen) {
          _lastInputTime = DateTime.now();
        }
      });
    }
  }
}
