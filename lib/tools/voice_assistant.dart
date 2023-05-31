// import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/main.dart';
import 'package:see_me_now/ui/home_page.dart';

class VoiceAssistant {
  static bool sysPlaying = false;
  static final sysPlayer = AudioPlayer();
  static bool playing = false;
  static final player = AudioPlayer();
  static void notifyUpright(int times) async {
    if (times == 1) {
      if (sysPlaying) {
        await sysPlayer.stop();
      }
      sysPlaying = true;
      await sysPlayer.setUrl('asset:///assets/wav/goodjob.wav');
      await sysPlayer.play();
      sysPlaying = false;
    }
  }

  static void notifyAskew() async {
    if (sysPlaying) {
      await sysPlayer.stop();
    }
    sysPlaying = true;
    await sysPlayer.setUrl('asset:///assets/wav/hurryup.wav');
    await sysPlayer.play();
    sysPlaying = false;
  }

  static void setListener() {
    player.playerStateStream.listen((state) {
      Log.log.fine('player state: $state');
      if (state.processingState == ProcessingState.completed ||
          (playing && state.processingState == ProcessingState.idle)) {
        if (state.processingState == ProcessingState.completed) {
          MyApp.homePageStateKey.currentState!.changeOpacity(true);
        } else {
          MyApp.homePageStateKey.currentState!
              .changeOpacity(true, refresh: false);
        }
      }
    });
  }

  static void play(String url,
      {bool deleteFile = false, bool clearReminderTxt = false}) async {
    try {
      if (playing) {
        Log.log.fine('stop last play');
        await player.stop();
      }
      Log.log.fine('playing: $url');
      playing = true;
      await player.setUrl(url);
      await player.play();
      await player.stop();
      playing = false;
      Log.log.fine('await play finished: $url');
      if (clearReminderTxt) {
        final HomeController c = Get.put(HomeController());
        c.setReminderTxt('');
      }
      // MyApp.homePageStateKey.currentState!.changeOpacity(true);
      // if (deleteFile && url.startsWith('file://')) {
      //   // delete local temp file
      //   var file = File(url.substring(7));
      //   await file.delete();
      //   Log.log.fine('deleted file: ${file.path}');
      // }
    } catch (e) {
      Log.log.warning('play exception: $e');
    }
  }
}
