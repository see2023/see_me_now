import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';

class GoalManager {
  SeeGoal? goal;
  saveToDB() async {
    if (goal == null || DB.isar == null) {
      return;
    }
    await DB.isar?.writeTxn(() async {
      goal?.updateTime = DateTime.now();
      if (goal?.id == 0) {
        // add
        int? newId = await DB.isar?.seeGoals.put(goal!);
        goal?.id = newId ?? 0;
        Log.log.info('goal inserted, id: ${goal?.id}, name: ${goal?.name}');
      } else {
        // update
        DB.isar?.seeGoals.put(goal!);
        Log.log.info('goal updated, id: ${goal?.id}');
      }
    });
  }

  newGoal(String name, String description, int priority, GoalType type,
      List<StatePattern> statePatterns, List<String> experiences) {
    goal = SeeGoal();
    goal?.name = name;
    goal?.description = description;
    goal?.priority = priority;
    goal?.type = type;
    goal?.statePatterns = statePatterns;
    goal?.experiences = experiences;
    saveToDB();
  }

  newGoalFromDB(SeeGoal tmpGoal) {
    goal = tmpGoal;
  }

  // loop run
}
