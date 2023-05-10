import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/main.dart';
import 'package:see_me_now/ml/see_me.dart';
import 'package:see_me_now/tools/voice_assistant.dart';
import 'package:see_me_now/ui/camera_view.dart';

enum CameraDataType {
  face,
  label,
  pose,
}

class CameraData extends EventArgs {
  CameraDataType type = CameraDataType.face;
  bool firstPhase = false;
  bool lastPhase = false;
  bool hasPerson = false;
  List<Pose>? poses;
  List<Face>? faces;
  List<ImageLabel>? labels;
  CameraData(
      {this.type = CameraDataType.face,
      this.poses,
      this.faces,
      this.labels,
      this.lastPhase = false,
      this.firstPhase = false,
      this.hasPerson = false});
}

class StatData {
  DateTime insertTime = DateTime.now();
  MyStatus status = MyStatus.none;
  double isSmile = 0;
  Face? face;
}

class StatDataNotifier extends ChangeNotifier {
  MyStatus status = MyStatus.none;
  int nobodyCount = 0;
  int askewCount = 0;
  int uprightCount = 0;
  double isSmile = 0;
  String currentStatus = '';
  void notify() {
    notifyListeners();
  }
}

enum MyStatus {
  none,
  nobody,
  askew,
  upright,
}

class Me {
  static int maxCount = 60;
  static const int statusChangeCount = 10 * 1000 ~/ CameraView.detectInterval;
  static List<StatData> statList = <StatData>[];
  static var cameraDataBus = Event<CameraData>();
  static var defaultSpeaker = SeeMe();
  static void init() {
    cameraDataBus.subscribe(Me.handle);
    Log.log.info('init me');
  }

  // recieve data from camera(mlkit) and handle it
  static void handle(CameraData? data) async {
    if (data == null) return;
    Log.log.finest(
        'cameraDataBus recieveData, type: ${data.type}, lastPhase: ${data.lastPhase}');
    if (data.firstPhase) {
      statList.add(StatData());
    }
    int dataIndex = statList.length - 1;
    switch (data.type) {
      case CameraDataType.label:
        if (!data.hasPerson) {
          statList[dataIndex].status = MyStatus.nobody;
        }
        // Log.log.fine('checkHasPerson from labels, rt: $rt');
        break;
      case CameraDataType.face:
        // after label checked
        if (data.faces != null && data.faces!.isNotEmpty) {
          statList[dataIndex].face = data.faces![0];
          statList[dataIndex].isSmile =
              data.faces![0].smilingProbability == null
                  ? 0
                  : data.faces![0].smilingProbability!;
          statList[dataIndex].status = Me.checkHeadAskew(data.faces![0])
              ? MyStatus.askew
              : MyStatus.upright;
        } else if (statList[dataIndex].status != MyStatus.nobody) {
          statList[dataIndex].status = MyStatus.askew;
        }

        break;
      case CameraDataType.pose:
        break;
    }
    // stats ok
    if (data.lastPhase) {
      String angle = '';
      if (statList[dataIndex].face != null) {
        var f = statList[dataIndex].face!;
        if (f.headEulerAngleX != null &&
            f.headEulerAngleY != null &&
            f.headEulerAngleZ != null) {
          angle =
              "${f.headEulerAngleX!.toStringAsFixed(0)} ${f.headEulerAngleY!.toStringAsFixed(0)} ${f.headEulerAngleZ!.toStringAsFixed(0)}";
        }
      }
      MyApp.latestStat.currentStatus =
          "^_^: ${(statList[dataIndex].isSmile * 100).toStringAsFixed(0)}, ${statList[dataIndex].status.index}: $angle";

      MyApp.glbViewerStateKey.currentState!.sendMouthSmileMorphTargetInfluence(
          (statList[dataIndex].isSmile * 100).round());
      Log.log.finest(
          'latestStat from face and labels: ${MyApp.latestStat.currentStatus}');
      MyApp.latestStat.notify();
      if (DB.setting.enableAIReplyFromCamera) {
        defaultSpeaker.gotData(statList);
      } else {
        notifyByRule(dataIndex);
      }

      if (statList.length > maxCount) {
        saveToDB();
      }
    }
  }

  static notifyByRule(int dataIndex) {
    if (statList[dataIndex].status == MyStatus.askew) {
      MyApp.latestStat.askewCount++;
      if (MyApp.latestStat.askewCount == statusChangeCount) {
        Log.log.info('change status to askew');
        MyApp.latestStat.status = MyStatus.askew;
      }
      if (MyApp.latestStat.askewCount % statusChangeCount == 0) {
        MyApp.latestStat.nobodyCount = 0;
        MyApp.latestStat.uprightCount = 0;
        if (DB.setting.enablePoseReminder) {
          VoiceAssistant.notifyAskew(
              MyApp.latestStat.askewCount ~/ statusChangeCount);
        }
      }
    } else if (statList[dataIndex].status == MyStatus.upright) {
      MyApp.latestStat.uprightCount++;
      if (MyApp.latestStat.uprightCount == statusChangeCount) {
        Log.log.info('change status to upright');
        MyApp.latestStat.status = MyStatus.upright;
      }
      if (MyApp.latestStat.uprightCount % statusChangeCount == 0) {
        MyApp.latestStat.nobodyCount = 0;
        MyApp.latestStat.askewCount = 0;
        if (DB.setting.enablePoseReminder) {
          VoiceAssistant.notifyUpright(
              MyApp.latestStat.uprightCount ~/ statusChangeCount);
        }
      }
    } else if (statList[dataIndex].status == MyStatus.nobody) {
      MyApp.latestStat.nobodyCount++;
      if (MyApp.latestStat.nobodyCount == statusChangeCount) {
        Log.log.info('change status to nobody');
        MyApp.latestStat.status = MyStatus.nobody;
      }
      if (MyApp.latestStat.nobodyCount % statusChangeCount == 0) {
        MyApp.latestStat.askewCount = 0;
        MyApp.latestStat.uprightCount = 0;
      }
    }
  }

  static Set<int> personSet = <int>{
    // https://developers.google.com/ml-kit/vision/image-labeling/label-map
    16, // Sitting
    17, // beard
    46, // Smile
    118, // Cat
    132, // Nail
    155, // Goggles
    161, // Hat
    197, // Jacket
    204, // Ear
    209, // Eyelash
    218, // Crowd
    289, // Dog
    303, // Cool
    356, // moustache
    386, // Fun
    422, // Glasses
    425, // Hand
    439, // Selfie
    446, // Helmet
  };
  static bool checkHasPerson(List<ImageLabel>? labels) {
    // check if there is a person in one ImageLabel
    int hit = 0;
    if (labels == null || labels.isEmpty) return false;
    for (var label in labels) {
      if (personSet.contains(label.index)) ++hit;
    }
    return hit >= 2;
  }

  static bool checkHeadAskew(Face? face) {
    if (face == null ||
        face.headEulerAngleX!.abs() > 20 ||
        face.headEulerAngleY!.abs() > 45 ||
        face.headEulerAngleZ!.abs() > 20) return true;
    return false;
  }

  static bool checkFaceDistracted(Face face) {
    // check if the face is distracted
    return false;
  }

  static saveToDB() async {
    if (statList.isEmpty) return;
    int total = statList.length;
    double appearCount = 0;
    double uprightCount = 0;
    double smileTotal = 0;
    for (var stat in statList) {
      if (stat.status != MyStatus.nobody) {
        ++appearCount;
        if (stat.status == MyStatus.upright) ++uprightCount;
        smileTotal += stat.isSmile;
      }
    }
    appearCount /= total;
    uprightCount /= total;
    smileTotal /= total;
    Log.log.info(
        'MeState saveToDB : $total, $appearCount, $uprightCount, $smileTotal');
    await DB.isar?.writeTxn(() async {
      await DB.isar?.meStateHistorys.put(MeStateHistory()
        ..stateKey = StateKey.appear
        ..value = appearCount);
      await DB.isar?.meStateHistorys.put(MeStateHistory()
        ..stateKey = StateKey.upright
        ..value = uprightCount);
      await DB.isar?.meStateHistorys.put(MeStateHistory()
        ..stateKey = StateKey.smile
        ..value = smileTotal);
    });

    statList.clear();
  }
}
