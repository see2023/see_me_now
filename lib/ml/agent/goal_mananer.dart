import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/ml/agent/actions.dart';
import 'package:see_me_now/ml/agent/agent_prompts.dart';
import 'package:see_me_now/ui/agent/goal_widget.dart';
import 'package:see_me_now/ui/home_page.dart';

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
  TaskInfo(this.description, this.estimatedTimeInMinutes);
  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo(json['description'], json['estimatedTimeInMinutes']);
  }
}

class GoalStateIndex {
  String stateName = '';
  double valueNow = 0;
  double valueBefore = 0;
  bool positive = true;
}

class TaskScore {
  String taskDescription = '';
  int estimatedTime = 0;
  int timeSpent = 0;
  double score = 0;
}

class GoalState {
  String goalName = '';
  String goalDescription = '';
  List<TaskScore> taskScores = [];
  List<GoalStateIndex> envStates = [];
}

class GoalManager extends GetxController {
  static double maxCostPerTask = 1000;
  static int maxActionsPerTask = 20;
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

  late Timer _timer;
  bool running = false;
  int runningTaskId = 0;
  int runningActionId = 0;
  int runningGoalId = 0;
  List<int> orderedGoals = [];
  Map<int, SeeGoal> goalsMap = {};
  Map<int, SeeTask> tasksMap = {};
  final HomeController homeCon = Get.put(HomeController());
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
  updateGoal(int goalId) {
    SeeGoal? goal = goalsMap[goalId];
    if (goal == null) {
      Log.log.warning('addTask: goal not found $goalId');
      return;
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

  updateTaskStatus(int taskId, TaskStatus status, {int score = 0}) async {
    SeeTask? task = tasksMap[taskId];
    if (task == null) {
      Log.log.warning('updateTask: task not found $taskId');
      return;
    }
    await DB.isar?.writeTxn(() async {
      task.startTime ??= DateTime.now();
      task.status = status;
      if (score > 0) task.score = score;
      if (status == TaskStatus.done ||
          status == TaskStatus.cancelled ||
          status == TaskStatus.failed) {
        task.endTime = DateTime.now();
        if (runningTaskId == taskId) {
          runningTaskId = 0;
          runningActionId = 0;
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
      Log.log.fine('updateTask: task updated $taskId, $status');
      if (status == TaskStatus.done) {
        evaluateTaskByGpt(taskId, score);
      }
    });
  }

  showGoalsAndTasks() async {
    // Get.dialog(
    await showDialog(
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (_) => GoalWidget(
        orderedGoals: orderedGoals,
        goalsMap: goalsMap,
        tasksMap: tasksMap,
        changeTaskStatus: updateTaskStatus,
        onAddNewTask: onAddNewTask,
      ),
    );
  }

  Future<bool> saveTasks(GoalInfo simpleGoal) async {
    try {
      for (TaskInfo task in simpleGoal.tasks ?? []) {
        SeeTask seeTask = SeeTask()
          ..goalId = simpleGoal.goalId
          ..description = task.description
          ..estimatedTimeInMinutes = task.estimatedTimeInMinutes;
        await addTask(simpleGoal.goalId, seeTask, true);
      }
    } catch (e) {
      Log.log.warning('saveTasks error: $e');
      return false;
    }
    return true;
  }

  setInitGoals() {
    Log.log.info('no goals in db, initing goals');
    Log.log.fine('MathHomework'.tr);
    GoalManager.newGoal('MathHomework'.tr, 'Finish math homework every day', 3,
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
    GoalManager.newGoal('EnglishHomework'.tr,
        'Finish english homework every day', 2, GoalType.daily, [
      StatePattern()
        ..stateKey = StateKey.upright
        ..positive = true,
    ], [
      'The total time per day is less than 40 minutes.',
      'Read loudly to stay focused.',
      'Use English in daily life.',
    ]);
    GoalManager.newGoal('ChineseHomework'.tr,
        'Finish chinese homework every day', 2, GoalType.daily, [
      StatePattern()
        ..stateKey = StateKey.upright
        ..positive = true,
    ], [
      'The total time per day is less than 40 minutes.',
      'Write neatly to avoid rewriting.',
      'Note down the parts that are not understood as future tasks, and start these tasks on the principle of the memory curve.',
      'Read quickly first to get the main idea, then read Relevant part for specific issues.',
    ]);
    GoalManager.newGoal(
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

  initLoop() {
    // insert initial goals if no goals in db
    int goalCount = DB.isar?.seeGoals.where().countSync() ?? 0;
    if (goalCount == 0) {
      setInitGoals();
    }

    // start goal manager runner loop
    _timer =
        Timer.periodic(const Duration(milliseconds: 10 * 1000), (timer) async {
      if (running) {
        return;
      }
      if (homeCon.topicId >= 0 ||
          homeCon.inSubWindow ||
          Get.currentRoute != '/home') {
        return;
      }
      Log.log.fine(
          'goal manager running, topicId: ${homeCon.topicId}, currentRoute: ${Get.currentRoute}');
      running = true;
      await runOnce();
      running = false;
    });
  }

  close() {
    _timer.cancel();
  }

  runOnce() async {
    if (DB.isar == null) {
      return;
    }
    if (runningActionId > 0) {
      // check action timeout
      Log.log.fine('action $runningActionId pending');
      // execute next action
      await executeNextAction(runningTaskId);
      return;
    }
    if (runningTaskId > 0) {
      // todo
      // check any new task should cut in line

      //generate next action
      runningActionId = await generateNextAction(runningTaskId);

      return;
    }
    await checkGoals();
  }

  Future<int> checkGoals() async {
    List<GoalInfo> simpleGoals = [];
    List<SeeGoal> goals =
        DB.isar?.seeGoals.where().sortByPriorityDesc().findAllSync() ?? [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    for (SeeGoal goal in goals) {
      bool needCreateTask = false;
      if (goalsMap.containsKey(goal.id)) {
        continue;
      }
      // check if today is the first time to run this goal
      DateTime lastRunTime =
          goal.updateTime ?? DateTime.now().subtract(const Duration(days: 1));
      DateTime lastRunDay =
          DateTime(lastRunTime.year, lastRunTime.month, lastRunTime.day);
      if (goal.type == GoalType.daily) {
        if (today != lastRunDay) {
          needCreateTask = true;
        }
      } else if (goal.updateTime == null) {
        needCreateTask = true;
      }
      // clear goal's tasks, because it may be outdated
      goal.tasks = [];
      await addGoal(goal, false);
      // generate new tasks for this goal
      GoalInfo newTempGoal = GoalInfo()
        ..name = goal.name
        ..priority = goal.priority;
      if (needCreateTask) {
        newTempGoal.tasks = await generateTask(goal.id);
      }
      int unfinishedTaskCount = 0;
      // read today's tasks from db
      List<SeeTask>? tasksIndb = await DB.isar?.seeTasks
          .where()
          .taskDateEqualTo(today.toString().substring(0, 10))
          .filter()
          .goalIdEqualTo(goal.id)
          .findAll();
      for (SeeTask task in tasksIndb ?? []) {
        await addTask(goal.id, task, false);
        if (runningTaskId == 0 && task.status == TaskStatus.running) {
          runningTaskId = task.id;
        }
        newTempGoal.tasks!
            .add(TaskInfo(task.description, task.estimatedTimeInMinutes));
        if (task.status == TaskStatus.pending ||
            task.status == TaskStatus.running) {
          unfinishedTaskCount++;
        }
      }
      simpleGoals.add(newTempGoal);
      if (runningGoalId <= 0 && (needCreateTask || unfinishedTaskCount > 0)) {
        runningGoalId = goal.id;
      }
    }
    if (runningTaskId == 0) {
      runningTaskId = await reorderAndStartFirstTasks();
    }
    return simpleGoals.length;
  }

  Future<List<TaskInfo>?> generateTask(int goalId) async {
    SeeGoal goal = goalsMap[goalId]!;
    Log.log.info('new tasks generated for goal ${goal.name}, to be confirmed');
    String userInput = await askUserForTasks(goal);
    if (userInput.isEmpty) {
      updateGoal(goalId);
      return [];
    }
    List<TaskInfo> newTasks = await askGptForTasks(goal, userInput);
    GoalInfo tempGoal = GoalInfo()
      ..goalId = goal.id
      ..name = goal.name
      ..priority = goal.priority
      ..tasks = newTasks;
    await confirmNewTasks(tempGoal);
    return tempGoal.tasks;
  }

  Future<String> askUserForTasks(SeeGoal goal) async {
    String showText = 'askUserForTasks'.trParams({'name': goal.name});
    MyAction action =
        MyAction(goal.id, 0, ActionType.askUserForCreateTask, showText);

    homeCon.setInSubWindow(true);
    await action.excute();
    homeCon.setInSubWindow(false);
    Log.log.fine('askUserForTasks output: ${action.act?.output}');
    return action.act?.output ?? '';
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

  Future<List<TaskInfo>> askGptForTasks(SeeGoal goal, String userInput) async {
    List<String> experience = await getExperience(goal.id);
    List<String> lastTaskNames = await getTasksOfLastDay(goal.id);

    Map<String, dynamic> inputMap = {
      'goal': goal.name,
      'goalDescription': goal.description,
      'experience': experience,
      'lastTasks': lastTaskNames,
      'userInput': userInput,
      'constraints': '''
You should only respond in JSON format as described below:
an array containing 1-3 elements with description: string, the description of the task,
estimatedTimeInMinutes: number, the estimated time to live in minutes. Use 0 instead of null if you don't know.
Based on the userInput task description, you can divide the main task into 2-3 sub-tasks or add 1-2 additional sub-tasks based on past experience.
{
  "tasks":
[
  {
  "description": "string",
  "estimatedTimeInMinutes": "number"
  },
  {
  "description": "string",
  "estimatedTimeInMinutes": "number"
  }
]
}
Note that this refers to specific tasks, not experiences.
Ensure the response can be parsed by Python json.loads, without any Note.
''',
    };
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForCreateTask]!;
    // sysPromts += DB.promptsMap[DB.defaultPromptId]?.text ?? '';
    MyAction action = MyAction(goal.id, 0, ActionType.askGptForCreateTask, '',
        inMap: inputMap, sysPrompt: sysPromts);
    await action.excute();
    Log.log.fine('askGptForTasks output: ${action.act?.output}');
    try {
      List<dynamic> list = action.outputMap?['tasks'] ?? [];
      List<TaskInfo> tasks =
          List<TaskInfo>.from(list.map((e) => TaskInfo.fromJson(e)));
      return tasks;
    } catch (e) {
      Log.log.warning('askGptForTasks output is not valid json, $e');
    }
    return [];
  }

  Future<void> onAddNewTask(int goalId) async {
    Future.delayed(const Duration(milliseconds: 100), () async {
      List<TaskInfo>? newTasks = await generateTask(goalId);
      if (newTasks == null || newTasks.isEmpty) {
        return false;
      }
      return true;
    });
  }

  Future<bool> confirmNewTasks(GoalInfo goal) async {
    homeCon.setInSubWindow(true);
    bool rt = false;
    await showDialog(
        barrierColor: Colors.transparent,
        context: Get.context!,
        builder: (_) => SimpleGoalWidget(
              goal: goal,
              onSubmitted: (p0) {
                rt = p0;
              },
            ));

    homeCon.setInSubWindow(false);
    if (rt) {
      // save tasks to db
      await saveTasks(goal);
    } else {
      goal.tasks?.clear();
    }
    Log.log.info('confirmNewTasks result: $rt');
    updateGoal(goal.goalId);
    return rt;
  }

  Future<int> reorderAndStartFirstTasks() async {
    // reorder by user or gpt?

    // get the first task of today, change the status to doing
    int firstId = 0;
    String today = DateTime.now().toString().substring(0, 10);
    for (int i = 0; i < orderedGoals.length; i++) {
      SeeGoal goal = goalsMap[orderedGoals[i]]!;
      for (int j = 0; j < goal.tasks.length; j++) {
        SeeTask? task = tasksMap[goal.tasks[j]];
        if (task == null) {
          Log.log.warning(
              'reorderTasks task is null, goal: ${goal.name}, task: ${goal.tasks[j]}');
          continue;
        }
        if (task.taskDate == today && task.status == TaskStatus.pending) {
          firstId = task.id;
          break;
        }
      }
    }
    await updateTaskStatus(firstId, TaskStatus.running);
    Log.log.fine('reorderTasks got firstId: $firstId running');
    return firstId;
  }

  Future<int> generateNextAction(int taskId) async {
    // get action total count and cost from db
    int actionCount =
        DB.isar?.seeActions.where().taskIdEqualTo(taskId).countSync() ?? 0;
    0.0;
    double actionCost = DB.isar?.seeActions
            .where()
            .taskIdEqualTo(taskId)
            .costProperty()
            .sumSync() ??
        0.0;
    if (actionCost > maxCostPerTask || actionCount > maxActionsPerTask) {
      // task is too expensive, skip
      Log.log.info('task $taskId is too expensive, skip');
      return 0;
    }

    // Check progress and give advice if progress is slow

    return 0;
    // SeeAction action = SeeAction()
    //   ..taskId = taskId
    //   // ..actionType = ActionType.confirm
    //   ..cost = 0.0;
    // int newId = DB.isar?.seeActions.putSync(action) ?? 0;
    // return newId;
  }

  Future<int> executeNextAction(int taskId) async {
    return 0;
  }

  evaluateTaskByGpt(int taskId, int score) async {
    SeeGoal? goal = goalsMap[tasksMap[taskId]?.goalId];
    SeeTask? task = tasksMap[taskId];
    if (goal == null || task == null) {
      Log.log.warning(
          'evaluateTaskByGpt goal or task is null, goal: $goal, task: $task');
      return;
    }
    // check all tasks of this goal, if all tasks are done, then evaluate the goal
    for (int i = 0; i < goal.tasks.length; i++) {
      SeeTask? t = tasksMap[goal.tasks[i]];
      if (t == null) {
        Log.log.info(
            'evaluateTaskByGpt task is null, goal: ${goal.name}, task: ${goal.tasks[i]}');
        continue;
      }
      if (t.status != TaskStatus.done) {
        Log.log.info(
            'evaluateTaskByGpt task ${t.description} is not done, skip evaluate goal');
        return;
      }
    }

    // evaluate task
    GoalState? goalState = await readStateOfGoal(goal);
    if (goalState != null) {
      await askGptForNewExperience(goal, goalState);
    }
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
        taskState.estimatedTime = task.estimatedTimeInMinutes;
        if (task.startTime == null || task.endTime == null) {
          taskState.timeSpent = 0;
        } else {
          taskState.timeSpent =
              task.endTime!.difference(task.startTime!).inMinutes;
        }
        taskState.score = task.score as double;
        goalState.taskScores.add(taskState);
      }
      // read state of this goal before today
      if (goal.statePatterns.isNotEmpty) {
        GoalStateIndex goalStateIndex = GoalStateIndex();
        // query MeStateHistory [task.startTime - task.endTime] according to goal.statePatterns
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime startDay = today.subtract(const Duration(days: 3));
        for (int i = 0; i < goal.statePatterns.length; i++) {
          goalStateIndex.stateName =
              AgentPromts.agentPrompts[goal.statePatterns[i].stateKey] ?? '';
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
          goalStateIndex.valueBefore = v;
          // get average value of tasks of this statePattern
          double stateValue = 0.0;
          int stateCount = 0;
          for (int j = 0; j < goal.tasks.length; j++) {
            SeeTask? task = tasksMap[goal.tasks[j]];
            if (task == null) {
              continue;
            }
            if (task.startTime != null &&
                task.endTime != null &&
                goal.statePatterns.isNotEmpty) {
              // query MeStateHistory [task.startTime - task.endTime] according to goal.statePatterns
              double v = await DB.isar?.meStateHistorys
                      .where()
                      .insertTimeBetween(task.startTime!, task.endTime!)
                      .filter()
                      .stateKeyEqualTo(goal.statePatterns[i].stateKey)
                      .valueProperty()
                      .average() ??
                  0;
              stateValue += v;
              stateCount++;
            }
          }
          if (stateCount > 0) {
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

  Future<bool> askGptForNewExperience(SeeGoal goal, GoalState goalState) async {
    List<String> experiences = [];
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForNewExperience]!;
    List<String> experiencesUsed = await getExperience(goal.id);
    // ask gpt for new experience
    Map<String, dynamic> inputMap = {
      'goalState': goalState,
      'experienceUsed': experiencesUsed,
      'constraints': '''
You should only respond in JSON format as described below:
an array A similar experience after optimization:
{
  "experiences":[
    "experience 1", "experience 2", "experience 3"
  ]
}
Ensure the response can be parsed by Python json.loads, without any Note.
''',
    };
    MyAction action = MyAction(
        goal.id, 0, ActionType.askGptForNewExperience, '',
        inMap: inputMap, sysPrompt: sysPromts);
    action.excute();
    Log.log.fine('askGptForNewExperience output: ${action.act?.output}');
    try {
      List<dynamic> list = action.outputMap?['experiences'] ?? [];
      experiences = List<String>.from(list.map((e) => e));
    } catch (e) {
      Log.log.warning('askGptForNewExperience output is not valid json, $e');
      return false;
    }

    // update experience
    double averageScore = 0.0;
    int scoreCount = 0;
    for (int i = 0; i < goal.tasks.length; i++) {
      SeeTask? task = tasksMap[goal.tasks[i]];
      if (task == null) {
        continue;
      }
      averageScore += task.score;
      scoreCount++;
    }
    averageScore = averageScore / scoreCount;
    DB.isar?.seeGoalExperiences.putSync(SeeGoalExperiences()
      ..goalId = goal.id
      ..score = averageScore.round()
      ..experiences = experiences);
    return true;
  }
}
