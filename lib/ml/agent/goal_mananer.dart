import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:see_me_now/data/db.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/ml/agent/agent_data.dart';
import 'package:see_me_now/ml/agent/actions.dart';
import 'package:see_me_now/ml/agent/agent_prompts.dart';
import 'package:see_me_now/ml/me.dart';
import 'package:see_me_now/ui/agent/goal_widget.dart';
import 'package:see_me_now/ui/agent/txt_show_widget.dart';
import 'package:see_me_now/ui/home_page.dart';

class GoalManager extends GetxController {
  static double maxCostPerTask = 1000;
  static int maxActionsPerTask = 20;
  static int minCheckProgressInterval = 10 * 60;

  late Timer _timer;
  bool running = false;
  AgentData agentData = AgentData();
  final HomeController homeCon = Get.put(HomeController());

  initLoop() {
    // insert initial goals if no goals in db
    int goalCount = DB.isar?.seeGoals.where().countSync() ?? 0;
    if (goalCount == 0) {
      AgentData.setInitGoals();
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
    if (agentData.runningAction) {
      // check action timeout
      Log.log.fine('action pending');
      return;
    }
    if (agentData.runningTaskId > 0) {
      // todo
      // check any new task should cut in line

      //generate next action
      await generateNextAction(agentData.runningTaskId);

      return;
    }
    await checkGoals();
  }

  updateTaskStatus(int taskId, TaskStatus status, {int score = 0}) async {
    await agentData.updateTask(taskId, status, score: score);
    if (status == TaskStatus.done) {
      evaluateTaskByGpt(taskId, score);
    }
  }

  showGoalsAndTasks() async {
    // Get.dialog(
    await showDialog(
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (_) => GoalWidget(
        orderedGoals: agentData.orderedGoals,
        goalsMap: agentData.goalsMap,
        tasksMap: agentData.tasksMap,
        changeTaskStatus: updateTaskStatus,
        onAddNewTask: onAddNewTask,
      ),
    );
  }

  Future<int> checkGoals() async {
    List<GoalInfo> simpleGoals = [];
    List<SeeGoal> goals =
        DB.isar?.seeGoals.where().sortByPriorityDesc().findAllSync() ?? [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    for (SeeGoal goal in goals) {
      bool needCreateTask = false;
      if (agentData.goalsMap.containsKey(goal.id)) {
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
      await agentData.addGoal(goal, false);
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
        await agentData.addTask(goal.id, task, false);
        if (agentData.runningTaskId == 0 && task.status == TaskStatus.running) {
          agentData.runningTaskId = task.id;
        }
        newTempGoal.tasks!
            .add(TaskInfo(task.description, task.estimatedTimeInMinutes));
        if (task.status == TaskStatus.pending ||
            task.status == TaskStatus.running) {
          unfinishedTaskCount++;
        }
      }
      simpleGoals.add(newTempGoal);
      if (agentData.runningGoalId <= 0 &&
          (needCreateTask || unfinishedTaskCount > 0)) {
        agentData.runningGoalId = goal.id;
      }
    }
    if (agentData.runningTaskId == 0) {
      agentData.runningTaskId = await reorderAndStartFirstTasks();
    }
    return simpleGoals.length;
  }

  Future<List<TaskInfo>?> generateTask(int goalId) async {
    SeeGoal goal = agentData.goalsMap[goalId]!;
    Log.log.info('new tasks generated for goal ${goal.name}, to be confirmed');
    String userInput = await askUserForTasks(goal);
    if (userInput.isEmpty) {
      agentData.updateGoal(goalId);
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
    return await askUserCommon(goal, showText);
  }

  Future<String> askUserCommon(SeeGoal goal, String inputText) async {
    MyAction action = MyAction(goal.id, 0, ActionType.askUserCommon, inputText);
    homeCon.setInSubWindow(true);
    await action.excute();
    homeCon.setInSubWindow(false);
    Log.log
        .fine('askUserCommon input:$inputText, output: ${action.act?.output}');
    return action.act?.output ?? '';
  }

  Future<List<TaskInfo>> askGptForTasks(SeeGoal goal, String userInput) async {
    List<String> experience = await agentData.getExperience(goal.id);
    List<String> lastTaskNames = await agentData.getTasksOfLastDay(goal.id);

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
      await agentData.saveTasks(goal);
    } else {
      goal.tasks?.clear();
    }
    Log.log.info('confirmNewTasks result: $rt');
    agentData.updateGoal(goal.goalId);
    return rt;
  }

  Future<int> reorderAndStartFirstTasks() async {
    // reorder by user or gpt?

    // get the first task of today, change the status to doing
    int firstId = 0;
    String today = DateTime.now().toString().substring(0, 10);
    for (int i = 0; i < agentData.orderedGoals.length; i++) {
      SeeGoal goal = agentData.goalsMap[agentData.orderedGoals[i]]!;
      for (int j = 0; j < goal.tasks.length; j++) {
        SeeTask? task = agentData.tasksMap[goal.tasks[j]];
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
      if (firstId > 0) {
        break;
      }
    }
    await updateTaskStatus(firstId, TaskStatus.running);
    Log.log.info('reorderTasks got firstId: $firstId running');
    return firstId;
  }

  evaluateTaskByGpt(int taskId, int score) async {
    SeeGoal? goal = agentData.goalsMap[agentData.tasksMap[taskId]?.goalId];
    SeeTask? task = agentData.tasksMap[taskId];
    if (goal == null || task == null) {
      Log.log.warning(
          'evaluateTaskByGpt goal or task is null, goal: $goal, task: $task');
      return;
    }
    // check all tasks of this goal, if all tasks are done, then evaluate the goal
    for (int i = 0; i < goal.tasks.length; i++) {
      SeeTask? t = agentData.tasksMap[goal.tasks[i]];
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
    GoalState? goalState = await agentData.readStateOfGoal(goal);
    if (goalState != null) {
      await askGptForNewExperience(goal, goalState);
    }
  }

  Future<bool> askGptForNewExperience(SeeGoal goal, GoalState goalState) async {
    List<String> experiences = [];
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForNewExperience]!;
    List<String> experiencesUsed = await agentData.getExperience(goal.id);
    // ask gpt for new experience
    Map<String, dynamic> inputMap = {
      'goalState': goalState.toString(),
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
    await action.excute();
    Log.log.fine('askGptForNewExperience output: ${action.act?.output}');
    try {
      List<dynamic> list = action.outputMap?['experiences'] ?? [];
      experiences = List<String>.from(list.map((e) => e));
      if (experiences.isEmpty) {
        Log.log.warning('askGptForNewExperience output is empty');
        return false;
      }
    } catch (e) {
      Log.log.warning('askGptForNewExperience output is not valid json, $e');
      return false;
    }

    // update experience
    double averageScore = 0.0;
    int scoreCount = 0;
    for (int i = 0; i < goal.tasks.length; i++) {
      SeeTask? task = agentData.tasksMap[goal.tasks[i]];
      if (task == null) {
        continue;
      }
      averageScore += task.score;
      scoreCount++;
    }
    averageScore = averageScore / scoreCount;
    await DB.isar?.writeTxn(() async {
      int? newId = await DB.isar?.seeGoalExperiences.put(SeeGoalExperiences()
        ..goalId = goal.id
        ..score = averageScore.round()
        ..experiences = experiences);
      Log.log.fine('askGptForNewExperience newId: $newId');
    });
    return true;
  }

  Future<int> generateNextAction(int taskId) async {
    SeeGoal? goal = agentData.goalsMap[agentData.tasksMap[taskId]?.goalId];
    SeeTask? task = agentData.tasksMap[taskId];
    if (goal == null || task == null) {
      Log.log.warning(
          'generateNextAction goal or task is null, goal: $goal, task: $task');
      return 0;
    }

    // get last action from db
    SeeAction? lastAction = await DB.isar?.seeActions
        .where()
        .taskIdEqualTo(taskId)
        .sortByStartTimeDesc()
        .findFirst();
    // make sure task.startTime is before minCheckProgressInterval seconds ago
    if (task.startTime != null &&
        DateTime.now().difference(task.startTime!).inSeconds <
            minCheckProgressInterval) {
      Log.log.fine(
          'generateNextAction task is too close from task.startTime, skip, task: $task, lastAction: $lastAction');
      return 0;
    }
    // make sure last action is before minCheckProgressInterval seconds ago
    if (lastAction != null &&
        DateTime.now().difference(lastAction.startTime).inSeconds <
            minCheckProgressInterval) {
      Log.log.fine(
          'generateNextAction last action is too close, skip, lastAction: $lastAction');
      return 0;
    }

    // get action total count and cost from db
    int actionCount =
        DB.isar?.seeActions.where().taskIdEqualTo(taskId).countSync() ?? 0;
    0.0;
    double actionCost = DB.isar?.seeActions
            .where()
            .taskIdEqualTo(taskId)
            .filter()
            .typeEqualTo(ActionType.askGptForTaskProgressEvaluation)
            .costProperty()
            .sumSync() ??
        0.0;
    if (actionCost > maxCostPerTask || actionCount > maxActionsPerTask) {
      // task is too expensive, skip
      Log.log.info('task $taskId is too expensive, skip');
      return 0;
    }

    // Check progress and give advice if progress is slow

    await askGptForTaskProgressEvaluation(goal, task);

    return 0;
  }

  Future<bool> askGptForTaskProgressEvaluation(
      SeeGoal goal, SeeTask task) async {
    GoalState? goalState = await agentData.readStateOfGoal(goal);
    if (goalState == null) {
      Log.log
          .warning('generateNextAction goalState is null, goal: ${goal.name}');
      return false;
    }
    List<String> questions = await agentData
        .getLatestQuestionAskByUser(task.startTime ?? task.insertTime);
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForTaskProgressEvaluation]!;
    List<String> experiencesUsed = await agentData.getExperience(goal.id);
    // ask gpt for new experience
    Map<String, dynamic> inputMap = {
      'goalName': goalState.goalName,
      'goalDiscription': goalState.goalDescription,
      'taskDiscription': task.description,
      'estimatedTime': task.estimatedTimeInMinutes,
      'timeSpent': DateTime.now()
          .difference(task.startTime ?? task.insertTime)
          .inMinutes,
      'questions': questions,
      'experienceUsed': experiencesUsed,
      'envStates': goalState.envStates.map((e) => e.toString()).toList(),
      'constraints': '''
You should only respond in JSON format as described below:
needMoreInfo is a bool, if true, I will ask user to provide more information, if false, I will use the text to remind user,
text should be a string, if taskDiscription is Chinese, please reply in Chinese; Otherwise, please use English.
{
  "needMoreInfo": bool,
  "text": "...."
}
Responses should be short, less than 100 words, and can be parsed by Python json.loads, without any Note.
''',
    };
    MyAction action = MyAction(
        goal.id, task.id, ActionType.askGptForTaskProgressEvaluation, '',
        inMap: inputMap, sysPrompt: sysPromts);
    await action.excute();
    Log.log.fine('askGptForNewExperience output: ${action.act?.output}');
    String text = '';
    String parentMessageId = '';
    try {
      bool needMoreInfo = action.outputMap?['needMoreInfo'] ?? false;
      text = action.outputMap?['text'] ?? '';
      if (needMoreInfo && text.isNotEmpty) {
        // ask user for more information
        String userFeedback = await askUserCommon(goal, text);
        if (userFeedback.isEmpty) {
          Log.log.warning(
              'askGptForNewExperience userFeedback is empty, ${action.act?.output}');
          return false;
        }
        parentMessageId = action.parentMessageId;
        MyAction action2 = MyAction(goal.id, task.id,
            ActionType.askGptForTaskProgressEvaluation, userFeedback,
            sysPrompt: sysPromts, parentMessageId: parentMessageId);
        await action2.excute();
        needMoreInfo = action.outputMap?['needMoreInfo'] ?? false;
        text = action.outputMap?['text'] ?? '';
        if (!needMoreInfo && text.isNotEmpty) {
          // use text to remind user
        } else {
          Log.log.warning(
              'askGptForNewExperience (needMoreInfo) output error, ${action.act?.output}');
          return false;
        }
      } else if (!needMoreInfo && text.isNotEmpty) {
        // use text to remind user
      } else {
        Log.log.warning(
            'askGptForNewExperience output error, ${action.act?.output}');
        return false;
      }
    } catch (e) {
      Log.log.warning('askGptForNewExperience output is not valid json, $e');
      return false;
    }

    // show text to user
    await showTextToUser(text: text, messageId: parentMessageId);
    return true;
  }

  Future<bool> showTextToUser(
      {bool showAvatar = true,
      String text = '',
      String messageId = '',
      List<String> strings = const [],
      Map<String, dynamic> map = const {}}) async {
    if (showAvatar) {
      Me.defaultSpeaker.talk(text, messageId: messageId);
    }
    homeCon.setInSubWindow(true);
    await showDialog(
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (_) => TxtShowWidget(text: text),
    );
    homeCon.setInSubWindow(false);
    return true;
  }
}
