import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/main.dart';
import 'package:see_me_now/ui/chat_list_page.dart';
import 'package:see_me_now/ui/chat_widget.dart';

class HomeController extends GetxController {
  bool isInSubWindowOrSubPage() {
    return inSubWindow || topicId >= 0 || Get.currentRoute != '/home';
  }

  bool inSubWindow = false;
  void setInSubWindow(bool value) {
    inSubWindow = value;
    Log.log.fine('in HomeController, inSubWindow changed to $value');
    MyApp.refreshHome();
  }

  int topicId = -1;
  // -1: topic list; 0: new topic; >0 topic detail
  void setTopicId(int value) {
    topicId = value;
    if (topicId <= 0) {
      MyApp.changeHomeTitle(DB.getDefaultPromptName());
    }
    // update(); // not work ??
    Log.log.fine('in HomeController, topicId changed to $value');
    MyApp.refreshHome();
  }
  // change topicId to -1 when no input continuously for 120 seconds
  // when topicId is -1, and task is active, show task list for 30 seconds

  String reminderTxt = '';
  void setReminderTxt(String value) {
    Log.log.info('in HomeController, reminderTxt changed to $value');
    reminderTxt = value;
    MyApp.refreshHome();
    // update();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;
  DateTime _lastPressedAt =
      DateTime.now().subtract(const Duration(seconds: 10));
  final HomeController c = Get.put(HomeController());
  String appBarTitle = DB.getDefaultPromptName();
  float chatOpacity = 0.8;
  void changeOpacity(bool isOpacity) {
    chatOpacity = isOpacity ? 0.8 : 0.3;
    setState(() {});
  }

  void changeTitle(String title, {bool refresh = true}) {
    if (title != appBarTitle) {
      if (!refresh) {
        appBarTitle = title;
        return;
      }
      Future.delayed(Duration.zero, () {
        setState(() {
          appBarTitle = title;
          Log.log.fine('in HomePageState, title changed to $title');
        });
      });
    }
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // get global state
    super.build(context);
    Log.log.fine(
        'building home page, topicId: ${c.topicId}, AppName: $appBarTitle');
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  c.setInSubWindow(true);
                  await MyApp.goalManager.showGoalsAndTasks();
                  c.setInSubWindow(false);
                },
                child: const Icon(Icons.task),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  c.setTopicId(0);
                },
                child: const Icon(Icons.chat),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await Get.toNamed('/prompts');
                  c.setTopicId(0);
                  setState(() {
                    appBarTitle = DB.getDefaultPromptName();
                    Log.log.fine(
                        'back from prompts page, title changed to $appBarTitle');
                  });
                },
                child: const Icon(Icons.emoji_people),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    await Get.toNamed('/setting');
                    setState(() {});
                  },
                  child: const Icon(Icons.more_vert),
                )),
          ],
        ),
        body: GetBuilder<HomeController>(builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(0),
            child: Stack(children: [
              MyApp.glbViewer,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Opacity(
                        opacity: controller.topicId < 0 ? 0.33 : 0,
                        child: DB.setting.enableCamera
                            ? MyApp.cameraView
                            : const SizedBox(),
                      )
                    ],
                  ),
                ],
              ),
              c.inSubWindow
                  ? const SizedBox()
                  : Opacity(
                      opacity: chatOpacity,
                      child: controller.topicId < 0
                          ? const ExtensibleTopicList()
                          : ChatWidget(chatId: controller.topicId),
                    ),
              // show reminderTxt
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    controller.reminderTxt,
                    style: const TextStyle(
                        color: Color.fromARGB(204, 255, 255, 255)),
                  ),
                ),
              ),
            ]),
          );
        }),
      ),
      onWillPop: () async {
        if (c.topicId >= 0) {
          c.setTopicId(-1);
          return false;
        }
        if (DateTime.now().difference(_lastPressedAt) >
            const Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          // show tips
          Get.snackbar('Press again to exit', '',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black54,
              colorText: Colors.white,
              margin: const EdgeInsets.all(20),
              borderRadius: 20,
              duration: const Duration(seconds: 2));
          return false;
        }
        return true;
      },
    );
  }

  @override
  dispose() {
    Log.log.fine('dispose home page');
    super.dispose();
  }
}
