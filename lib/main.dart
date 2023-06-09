import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:see_me_now/3d/glb_viewer.dart';
import 'package:see_me_now/data/setting.dart';
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
import 'package:wakelock/wakelock.dart';

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
  static bool appPaused = false;

  static void refreshHome() {
    homePageStateKey.currentState?.refresh();
  }

  static void changeHomeTitle(String titile) {
    homePageStateKey.currentState?.changeTitle(titile);
  }

  static void updateLocale(String userLanguage) {
    if (userLanguage.isEmpty) return;
    if (userLanguage == DB.setting.userLanguage) return;
    DB.setting.changeSetting(SettingKeyConstants.userLanguage, userLanguage);
    LangInfo langInfo = LangMap.langMap[DB.setting.userLanguage] ?? LangInfo();
    Locale locale = Locale(langInfo.langCode, langInfo.langCode);
    Get.updateLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      MyApp.goalManager.initLoop();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // changing appPaused to true when app is in background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.log.fine('In _MyAppState didChangeAppLifecycleState, state: $state');
    if (state == AppLifecycleState.paused) {
      MyApp.appPaused = true;
    } else if (state == AppLifecycleState.resumed) {
      MyApp.appPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    LangInfo langInfo = LangMap.langMap[DB.setting.userLanguage] ?? LangInfo();
    return GetMaterialApp(
      translations: Messages(),
      locale: Locale(langInfo.langCode, langInfo.countryCode),
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
  Wakelock.enable();
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
