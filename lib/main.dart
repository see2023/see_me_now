import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:see_me_now/3d/glb_viewer.dart';
import 'package:see_me_now/data/topics_model.dart';
import 'package:see_me_now/messages.dart';
import 'package:see_me_now/ml/agent/goal_mananer.dart';
import 'package:see_me_now/ml/me.dart';
import 'package:see_me_now/tools/voice_assistant.dart';
import 'package:see_me_now/ui/camera_view.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/ui/home_page.dart';
import 'package:see_me_now/ui/prompts_page.dart';
import 'package:see_me_now/ui/setting_page.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

// APP
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static LatestTopics latestTopics = LatestTopics();
  static AllTopics allTopics = AllTopics();
  static StatDataNotifier latestStat = StatDataNotifier();
  static const cameraView = CameraView();
  static final glbViewerStateKey = GlobalKey<GlbViewerState>();
  static final glbViewer = GlbViewer(key: glbViewerStateKey);
  static final homePageStateKey = GlobalKey<HomePageState>();
  static final homePage = HomePage(key: homePageStateKey);
  static final goalManager = GoalManager();

  static void refreshHome() {
    homePageStateKey.currentState?.refresh();
  }

  static void changeHomeTitle(String titile) {
    homePageStateKey.currentState?.changeTitle(titile);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      MyApp.goalManager.initLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: const Locale('zh', 'CN'),
      // locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'See',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      // darkTheme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   brightness: Brightness.dark,
      // ),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => MyApp.homePage),
        GetPage(name: '/setting', page: () => const SettingPage()),
        GetPage(name: '/prompts', page: () => const PromptsPage()),
        // name: '/chats/:chatId',
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.setLevel(Level.FINE);
  await DB.init();
  if (DB.isRelease) {
    Log.setLevel(Level.INFO);
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Log.log.info('version: ${packageInfo.version}');

  Me.init();
  VoiceAssistant.setListener();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MyApp.latestTopics),
        ChangeNotifierProvider.value(value: MyApp.allTopics),
        ChangeNotifierProvider.value(value: MyApp.latestStat),
      ],
      child: const MyApp(
        key: Key('app'),
      )));
}
