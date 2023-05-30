import 'dart:convert';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:see_me_now/data/constants.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/message.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/ml/agent/agent_prompts.dart';

class GoalInfo {
  int goalId = 0;
  String name = '';
  int priority = 0;
  List<TaskInfo>? tasks = [];
}

class TaskInfo {
  int taskId = 0;
  String description = '';
  int estimatedTimeInMinutes = 0;
  String keyword = '';
  TaskInfo(this.description, this.estimatedTimeInMinutes, {this.keyword = ''});
  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    // List<String> keywordsTmp = [];
    // if (json['keywords'] != null) {
    //   keywordsTmp = List<String>.from(json['keywords']);
    // }
    // // remove duplicates and keep at most 3 keywords, use lower case
    // keywordsTmp = keywordsTmp.map((e) => e.toLowerCase()).toList();
    // keywordsTmp = keywordsTmp.toSet().toList();
    // if (keywordsTmp.length > 3) {
    //   keywordsTmp = keywordsTmp.sublist(0, 3);
    // }
    return TaskInfo(json['description'], json['estimatedTimeInMinutes'],
        keyword: json['keyword']);
  }
}

class GoalStateIndex {
  String stateName = '';
  double valueNow = 0;
  double valueBefore = 0;
  bool positive = true;
  @override
  String toString() {
    return jsonEncode({
      'stateName': stateName,
      'valueNow': valueNow,
      'valueBefore': valueBefore,
      'positive': positive,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'stateName': stateName,
      'valueNow': valueNow,
      'valueBefore': valueBefore,
      'positive': positive,
    };
  }
}

class TaskScore {
  String taskDescription = '';
  int estimatedTimeInMinutes = 0;
  int timeSpentInMinutes = 0;
  double score = 0;
  String evaluation = '';
  @override
  String toString() {
    return jsonEncode({
      'taskDescription': taskDescription,
      'estimatedTimeInMinutes': estimatedTimeInMinutes,
      'timeSpentInMinutes': timeSpentInMinutes,
      'score': score,
      'evaluation': evaluation,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'taskDescription': taskDescription,
      'estimatedTimeInMinutes': estimatedTimeInMinutes,
      'timeSpentInMinutes': timeSpentInMinutes,
      'score': score,
      'evaluation': evaluation,
    };
  }
}

class GoalState {
  String goalName = '';
  String goalDescription = '';
  List<TaskScore> taskScores = [];
  List<GoalStateIndex> envStates = [];
  @override
  String toString() {
    return jsonEncode({
      'goalName': goalName,
      'goalDescription': goalDescription,
      'taskScores': taskScores.map((e) => e.toString()).toList(),
      'envStates': envStates.map((e) => e.toString()).toList(),
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
      'goalDescription': goalDescription,
      'taskScores': taskScores,
      'envStates': envStates,
    };
  }
}

class AgentData {
  static const String conversationIdUser = 'user';
  static const String conversationIdAssistant = 'assistant';
  int runningTaskId = 0;
  int runningGoalId = 0;
  bool runningAction = false;
  List<int> orderedGoals = [];
  Map<int, SeeGoal> goalsMap = {};
  Map<int, SeeTask> tasksMap = {};

  static Future<SeeGoal> newGoal(
      String name,
      String description,
      int priority,
      GoalType type,
      List<StatePattern> statePatterns,
      List<String> experiences) async {
    SeeGoal tmpGoal = SeeGoal();
    tmpGoal.tasks = [];
    tmpGoal.name = name;
    tmpGoal.description = description;
    tmpGoal.priority = priority;
    tmpGoal.type = type;
    tmpGoal.statePatterns = statePatterns;
    await DB.isar?.writeTxn(() async {
      int? newId = await DB.isar?.seeGoals.put(tmpGoal);
      tmpGoal.id = newId ?? 0;
      int experienceId =
          await DB.isar?.seeGoalExperiences.put(SeeGoalExperiences()
                ..goalId = tmpGoal.id
                ..experiences = experiences) ??
              0;
      Log.log.info(
          'new goal saved with id ${tmpGoal.id}, experienceId: $experienceId, name: ${tmpGoal.name}');
    });
    return tmpGoal;
  }

  static setInitGoals() async {
    Log.log.info('no goals in db, initing goals');
    Log.log.fine('MathHomework'.tr);
    AgentData.newGoal('MathHomework'.tr, 'Finish math homework every day', 3,
        GoalType.daily, [
      StatePattern()
        ..stateKey = StateKey.upright
        ..positive = true,
    ], [
      'The total time per day is less than 40 minutes.',
      'Break down the homework into smaller, managable tasks.',
      'Ask for help when needed.',
      'Sort out wrong questions and practice repeatedly.',
      'Stay focused and avoid discactions.',
      // 'Display Countdown timer on screen.',
    ]);
    AgentData.newGoal('EnglishHomework'.tr, 'Finish english homework every day',
        2, GoalType.daily, [
      StatePattern()
        ..stateKey = StateKey.upright
        ..positive = true,
    ], [
      'The total time per day is less than 40 minutes.',
      'Read loudly to stay focused.',
      'Use English in daily life.',
    ]);
    AgentData.newGoal('ChineseHomework'.tr, 'Finish chinese homework every day',
        2, GoalType.daily, [
      StatePattern()
        ..stateKey = StateKey.upright
        ..positive = true,
    ], [
      'The total time per day is less than 40 minutes.',
      'Write neatly to avoid rewriting.',
      'Note down the parts that are not understood as future tasks, and start these tasks on the principle of the memory curve.',
      'Read quickly first to get the main idea, then read Relevant part for specific issues.',
    ]);
    AgentData.newGoal(
        'SportAndRelax'.tr,
        'Things that need attention in life such as homework',
        1,
        GoalType.daily, [
      StatePattern()
        ..stateKey = StateKey.smile
        ..positive = true,
      StatePattern()
        ..stateKey = StateKey.appear
        ..positive = false,
    ], [
      'Take a few minutes break every half an hour to drink some water and relax your eyes. ',
      'Sit up straight while doing homework.',
      'Keep smiling.',
    ]);
  }

  addGoal(SeeGoal goal, bool saveToDB) async {
    if (goal.id > 0 && goalsMap.containsKey(goal.id)) {
      return;
    }

    if (saveToDB) {
      await DB.isar?.writeTxn(() async {
        goal.id = await DB.isar?.seeGoals.put(goal) ?? 0;
      });
    }
    goalsMap[goal.id] = goal;
    // add to ordered goals by priority desc
    int i = 0;
    for (; i < orderedGoals.length; i++) {
      if (goal.priority > goalsMap[orderedGoals[i]]!.priority) {
        break;
      }
    }
    orderedGoals.insert(i, goal.id);
  }

  // update goal's update time and tasks by addTask
  updateGoal(int goalId,
      {String name = '',
      String description = '',
      int priority = 0,
      GoalType? goalType}) {
    SeeGoal? goal = goalsMap[goalId];
    if (goal == null) {
      Log.log.warning('updateGoal, id not found: $goalId');
      return;
    }
    if (name != '') {
      goal.name = name;
    }
    if (description != '') {
      goal.description = description;
    }
    if (priority > 0) {
      goal.priority = priority;
    }
    if (goalType != null) {
      goal.type = goalType;
    }
    DB.isar?.writeTxn(() async {
      goal.updateTime = DateTime.now();
      await DB.isar?.seeGoals.put(goal);
    });
  }

  addTask(int goalId, SeeTask task, bool saveToDB) async {
    SeeGoal? goal = goalsMap[goalId];
    if (goal == null) {
      Log.log.warning('addTask: goal not found $goalId');
      return;
    }
    if (task.id > 0 && tasksMap.containsKey(task.id)) {
      return;
    }
    if (saveToDB) {
      await DB.isar?.writeTxn(() async {
        task.id = await DB.isar?.seeTasks.put(task) ?? 0;
        Log.log.info('addTask: task saved with id ${task.id}');
      });
    }
    tasksMap[task.id] = task;
    // add to goal.tasks (unique)
    for (int i = 0; i < goal.tasks.length; i++) {
      if (goal.tasks[i] == task.id) {
        return;
      }
    }
    goal.tasks = [...goal.tasks, task.id];
  }

  updateTask(int taskId, TaskStatus status,
      {int score = 0, String evaluation = ''}) async {
    SeeTask? task = tasksMap[taskId];
    if (task == null) {
      Log.log.warning('updateTask: task not found $taskId');
      return;
    }
    await DB.isar?.writeTxn(() async {
      if (status == TaskStatus.running) {
        task.startTime = DateTime.now();
      } else {
        task.startTime ??= DateTime.now();
      }
      task.status = status;
      if (score > 0) task.score = score;
      if (evaluation != '') task.evaluation = evaluation;
      if (status == TaskStatus.done ||
          status == TaskStatus.cancelled ||
          status == TaskStatus.failed) {
        task.endTime = DateTime.now();
        if (runningTaskId == taskId) {
          runningTaskId = 0;
          runningAction = false;
        }
        // check if goal is done
        SeeGoal? goal = goalsMap[task.goalId];
        if (goal != null) {
          bool isDone = true;
          for (int taskId in goal.tasks) {
            SeeTask? task = tasksMap[taskId];
            if (task == null ||
                (task.status != TaskStatus.done &&
                    task.status != TaskStatus.cancelled &&
                    task.status != TaskStatus.failed)) {
              isDone = false;
              break;
            }
          }
          if (isDone) {
            if (runningGoalId == goal.id) {
              runningGoalId = 0;
            }
          }
        }
      }
      await DB.isar?.seeTasks.put(task);
      Log.log.info('updateTask: task updated $taskId, $status');
    });
  }

  Future<bool> saveTasks(GoalInfo simpleGoal) async {
    try {
      for (TaskInfo task in simpleGoal.tasks ?? []) {
        SeeTask seeTask = SeeTask()
          ..goalId = simpleGoal.goalId
          ..description = task.description
          ..keyword = task.keyword
          ..estimatedTimeInMinutes = task.estimatedTimeInMinutes;
        await addTask(simpleGoal.goalId, seeTask, true);
      }
    } catch (e) {
      Log.log.warning('saveTasks error: $e');
      return false;
    }
    return true;
  }

  Future<List<String>> getExperience(int goalId) async {
    // get the latest and the one has highest score
    List<String> experience = [];
    int lastId = 0;
    SeeGoalExperiences? lastExperience = DB.isar?.seeGoalExperiences
        .where()
        .goalIdEqualTo(goalId)
        .sortByInsertTimeDesc()
        .findFirstSync();
    if (lastExperience != null) {
      experience.addAll(lastExperience.experiences);
      lastId = lastExperience.id;
    }
    SeeGoalExperiences? bestExperience = DB.isar?.seeGoalExperiences
        .where()
        .goalIdEqualTo(goalId)
        .sortByScoreDesc()
        .findFirstSync();
    if (bestExperience != null && bestExperience.id != lastId) {
      for (String exp in bestExperience.experiences) {
        if (!experience.contains(exp)) {
          experience.add(exp);
        }
      }
    }
    return experience;
  }

  Future<List<String>> getExperienceWithKeywords(
      int goalId, List<String> keywords) async {
    List<String> experience = [];
    // search by keywords
    for (String keyword in keywords) {
      keyword = keyword.toLowerCase();
      List<List<String>> experiences = await DB.isar?.seeGoalExperiences
              .where()
              .goalIdEqualTo(goalId)
              .filter()
              .keywordsElementEqualTo(keyword, caseSensitive: true)
              .sortByScoreDesc()
              .thenByInsertTimeDesc()
              .limit(10)
              .experiencesProperty()
              .findAll() ??
          [];
      for (List<String> exps in experiences) {
        experience.addAll(exps);
      }
    }
    experience = experience.toSet().toList();
    // select random 5 experiences
    if (experience.length > 5) {
      experience.shuffle();
      experience = experience.sublist(0, 5);
    }
    if (experience.isNotEmpty) {
      return experience;
    }
    return await getExperience(goalId);
  }

  Future<bool> saveExperience(SeeGoal goal, int score, List<String> experiences,
      List<String> keywords) async {
    await DB.isar?.writeTxn(() async {
      int? newId = await DB.isar?.seeGoalExperiences.put(SeeGoalExperiences()
        ..goalId = goal.id
        ..score = score
        ..experiences = experiences
        ..keywords = keywords);
      Log.log.fine('saveExperience: newId $newId');
    });
    List<SeeGoalExperiences> experiencesList = DB.isar?.seeGoalExperiences
            .where()
            .goalIdEqualTo(goal.id)
            .sortByScoreDesc()
            .thenByInsertTimeDesc()
            .findAllSync() ??
        [];
    if (experiencesList.length > 100) {
      await DB.isar?.writeTxn(() async {
        await DB.isar?.seeGoalExperiences
            .delete(experiencesList[experiencesList.length - 1].id);
        Log.log.fine('saveExperience: lastExperience deleted');
      });
    }
    return true;
  }

  Future<bool> updateExperience(int experienceId, List<String> experiences,
      {int score = -1}) async {
    SeeGoalExperiences? experience = DB.isar?.seeGoalExperiences
        .where()
        .idEqualTo(experienceId)
        .findFirstSync();
    if (experience != null) {
      if (score > 0) {
        experience.score = score;
      }
      experience.experiences = experiences;
      await DB.isar?.writeTxn(() async {
        await DB.isar?.seeGoalExperiences.put(experience);
        Log.log.fine('updateExperience: lastExperience updated');
      });
    }
    return true;
  }

  Future<bool> deleteExperience(int experienceId) async {
    bool? rt;
    await DB.isar?.writeTxn(() async {
      rt = await DB.isar?.seeGoalExperiences.delete(experienceId);
      Log.log.fine('deleteExperience id($experienceId) deleted');
    });
    return rt ?? false;
  }

  Future<List<String>> getTasksOfLastDay(int goalId) async {
    String yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toString()
        .substring(0, 10);
    List<String> tasks = await DB.isar?.seeTasks
            .where()
            .taskDateEqualTo(yesterday)
            .filter()
            .goalIdEqualTo(goalId)
            .descriptionProperty()
            .findAll() ??
        [];
    return tasks;
  }

  int getTimeSpentInMinutes(SeeTask task) {
    if (task.startTime == null) {
      return 0;
    }
    DateTime endTime = task.endTime ?? DateTime.now();
    return endTime.difference(task.startTime!).inMinutes;
  }

  double getTimeSpentRatio(SeeTask task) {
    if (task.estimatedTimeInMinutes == 0) {
      return 0;
    }
    int timeSpentInMinutes = getTimeSpentInMinutes(task);
    if (timeSpentInMinutes == 0) {
      return 0;
    }
    return timeSpentInMinutes / task.estimatedTimeInMinutes;
  }

  Future<GoalState?> readStateOfGoal(SeeGoal goal) async {
    try {
      GoalState goalState = GoalState();
      goalState.goalName = goal.name;
      goalState.goalDescription = goal.description;
      for (int i = 0; i < goal.tasks.length; i++) {
        SeeTask? task = tasksMap[goal.tasks[i]];
        if (task == null) {
          Log.log.warning(
              'readStateOfGoal task is null, goal: ${goal.name}, task: ${goal.tasks[i]}');
          continue;
        }
        TaskScore taskState = TaskScore();
        taskState.taskDescription = task.description;
        taskState.estimatedTimeInMinutes = task.estimatedTimeInMinutes;
        taskState.timeSpentInMinutes = getTimeSpentInMinutes(task);
        taskState.score = task.score.toDouble();
        taskState.evaluation = task.evaluation;
        goalState.taskScores.add(taskState);
      }
      // read state of this goal before today
      if (goal.statePatterns.isNotEmpty) {
        // query MeStateHistory [task.startTime - task.endTime] according to goal.statePatterns
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime startDay = today.subtract(const Duration(days: 3));
        for (int i = 0; i < goal.statePatterns.length; i++) {
          GoalStateIndex goalStateIndex = GoalStateIndex();
          goalStateIndex.stateName =
              AgentPromts.stateKeyInfo[goal.statePatterns[i].stateKey] ?? '';
          goalStateIndex.positive = goal.statePatterns[i].positive;
          double v = await DB.isar?.meStateHistorys
                  .where()
                  .insertTimeGreaterThan(startDay)
                  .filter()
                  .insertTimeLessThan(today)
                  .and()
                  .stateKeyEqualTo(goal.statePatterns[i].stateKey)
                  .valueProperty()
                  .average() ??
              0;
          if (!v.isNaN) {
            goalStateIndex.valueBefore = v;
          }
          // get average value of tasks of this statePattern
          double stateValue = 0.0;
          int stateCount = 0;
          for (int j = 0; j < goal.tasks.length; j++) {
            SeeTask? task = tasksMap[goal.tasks[j]];
            if (task == null ||
                goalState.taskScores[j].timeSpentInMinutes == 0) {
              continue;
            }
            DateTime endTime = task.endTime ?? DateTime.now();
            if (task.startTime != null && goal.statePatterns.isNotEmpty) {
              // query MeStateHistory [task.startTime - endTime] according to goal.statePatterns
              double v2 = await DB.isar?.meStateHistorys
                      .where()
                      .insertTimeBetween(task.startTime!, endTime)
                      .filter()
                      .stateKeyEqualTo(goal.statePatterns[i].stateKey)
                      .valueProperty()
                      .average() ??
                  0;
              stateValue += v2;
              stateCount++;
            }
          }
          if (stateCount > 0 && !stateValue.isNaN) {
            goalStateIndex.valueNow = stateValue / stateCount;
          }
          goalState.envStates.add(goalStateIndex);
        }
      }
      return goalState;
    } catch (e) {
      Log.log.warning('readStateOfGoal error: $e');
      return null;
    }
  }

  Future<List<String>> getLatestQuestionAskByUser(DateTime startTime,
      {int num = 4}) async {
    // It's from messages, unlike conversion
    List<String> questions = [];
    List<Message> messages = await DB.isar?.messages
            .where()
            .createdAtGreaterThan(startTime)
            .filter()
            .textIsNotEmpty()
            .sortByCreatedAtDesc()
            .limit(num)
            .findAll() ??
        [];

    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].author == SettingValueConstants.me) {
        questions.add('${AgentData.conversationIdUser}: ${messages[i].text}');
      } else {
        // Only the full question is returned, the answer cut to 32 characters
        String msg = messages[i].text;
        if (msg.length > 32) {
          msg = '${msg.substring(0, 32)}...';
        }
        questions.add('${AgentData.conversationIdAssistant}: $msg');
      }
    }

    return questions;
  }

  Future<bool> saveConversation(int goalId, int taskId, String text,
      {String from = conversationIdAssistant}) async {
    if (text.length > 150) {
      text = text.substring(0, 150);
    }
    try {
      await DB.isar?.writeTxn(() async {
        await DB.isar?.conversations.put(Conversation()
          ..goalId = goalId
          ..taskId = taskId
          ..text = text
          ..from = from);
      });
      return true;
    } catch (e) {
      Log.log.warning('saveConversation error: $e');
      return false;
    }
  }

  // get tips of this goal and this task
  Future<List<String>> getConversation(int goalId, int taskId,
      {int num = 6}) async {
    List<Conversation> tips = await DB.isar?.conversations
            .where()
            .goalIdEqualTo(goalId)
            .filter()
            .taskIdEqualTo(taskId)
            .sortByInsertTime()
            .limit(num)
            .findAll() ??
        [];

    List<String> texts = [];
    for (Conversation tip in tips) {
      texts.add('${tip.from}: ${tip.text}');
    }
    return texts;
  }

  Future<List<String>> getConversationOfGoal(int goalId, {int num = 6}) async {
    List<Conversation> tips = await DB.isar?.conversations
            .where()
            .goalIdEqualTo(goalId)
            .sortByInsertTimeDesc()
            .limit(num)
            .findAll() ??
        [];

    List<String> texts = [];
    for (Conversation tip in tips) {
      texts.add('${tip.from}: ${tip.text}');
    }
    //reverse
    texts = texts.reversed.toList();
    return texts;
  }
}
