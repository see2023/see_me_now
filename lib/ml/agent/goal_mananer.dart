import 'dart:async';

import 'package:isar/isar.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';

class GoalManager {
  static Future<SeeGoal> newGoal(
      String name,
      String description,
      int priority,
      GoalType type,
      List<StatePattern> statePatterns,
      List<String> experiences) async {
    SeeGoal tmpGoal = SeeGoal();
    tmpGoal.name = name;
    tmpGoal.description = description;
    tmpGoal.priority = priority;
    tmpGoal.type = type;
    tmpGoal.statePatterns = statePatterns;
    tmpGoal.experiences = experiences;
    int? newId = await DB.isar?.seeGoals.put(tmpGoal);
    tmpGoal.id = newId ?? 0;
    Log.log.info('new goal saved: ${tmpGoal.id}, name: ${tmpGoal.name}');
    return tmpGoal;
  }

  late Timer _timer;
  bool running = false;

  runOnce() async {
    if (DB.isar == null) {
      return;
    }
    await checkGoals();
  }

  init() {
    // insert initial goals if no goals in db
    int goalCount = DB.isar?.seeGoals.where().countSync() ?? 0;
    if (goalCount == 0) {
      Log.log.info('no goals in db, initing goals');
      GoalManager.newGoal('Math homework', 'Finish math homework every day', 3,
          GoalType.daily, [
        StatePattern()
          ..stateKey = StateKey.upright
          ..positive = true,
      ], [
        'Stay focused and avoid discactions.',
        'Display Countdown timer on screen.',
        'Break down the homework into smaller, managable tasks.',
        'Ask for help when needed.',
        'Sort out wrong questions and practice repeatedly.'
      ]);
      GoalManager.newGoal('English homework',
          'Finish english homework every day', 2, GoalType.daily, [
        StatePattern()
          ..stateKey = StateKey.upright
          ..positive = true,
      ], [
        'Read loudly to stay focused.',
        'Display Countdown timer on screen.',
        'Ask for help when needed.',
        'Use English in daily life.',
      ]);
      GoalManager.newGoal('Chinese homework',
          'Finish chinese homework every day', 2, GoalType.daily, [
        StatePattern()
          ..stateKey = StateKey.upright
          ..positive = true,
      ], [
        'Write neatly to avoid rewriting.'
            'Display Countdown timer on screen.',
        'Ask for help when needed.',
        'Note down the parts that are not understood as future tasks, and start these tasks on the principle of the memory curve.',
        'Read quickly first to get the main idea, then read Relevant part for specific issues.',
      ]);
      GoalManager.newGoal(
          'Keep healthy',
          'Things that need attention in life such as homework',
          1,
          GoalType.always, [
        StatePattern()
          ..stateKey = StateKey.appear
          ..positive = false,
      ], [
        'Take a few minutes break every half an hour to drink some water and relax your eyes. ',
        'Sit up straight while doing homework.',
        'Keep smiling.',
      ]);
    }

    // start goal manager runner loop
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (running) {
        return;
      }
      running = true;
      await runOnce();
      running = false;
    });
  }

  close() {
    _timer.cancel();
  }

  Future<int> checkGoals() async {
    List<SeeGoal> goals = DB.isar?.seeGoals.where().findAllSync() ?? [];
    for (SeeGoal goal in goals) {
      if (goal.type == GoalType.daily) {
        // check if today is the first time to run this goal
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime lastRunTime = goal.updateTime;
        DateTime lastRunDay =
            DateTime(lastRunTime.year, lastRunTime.month, lastRunTime.day);
        if (today == lastRunDay) {
          // already run today
          continue;
        }
        // run goal
      }
    }
    return goals.length;
  }
}
