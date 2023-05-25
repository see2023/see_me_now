import 'dart:async';
import 'dart:math';

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
import 'package:see_me_now/tools/string_tools.dart';
import 'package:see_me_now/ui/agent/goal_widget.dart';
import 'package:see_me_now/ui/agent/txt_show_widget.dart';
import 'package:see_me_now/ui/home_page.dart';

class GoalManager extends GetxController {
  static double maxCostPerTask = 1000;
  static int maxActionsPerTask = 200;
  static int minCheckProgressInterval = 10 * 60;
  static int maxCheckProgressInterval = 30 * 60;
  DateTime lastCheckProgressTime = DateTime.now();
  MyStatus lastStatus = MyStatus.none;

  late Timer _timer;
  bool running = false;
  DateTime lastRunTime = DateTime.now();
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
      if (running || DateTime.now().difference(lastRunTime).inSeconds < 10) {
        return;
      }
      if (homeCon.isInSubWindowOrSubPage()) {
        return;
      }
      Log.log.fine(
          'goal manager running, topicId: ${homeCon.topicId}, currentRoute: ${Get.currentRoute}');
      running = true;
      await runOnce();
      running = false;
      lastRunTime = DateTime.now();
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

  updateTaskStatus(int taskId, TaskStatus status,
      {int score = 0, String evaluation = ''}) async {
    await agentData.updateTask(taskId, status,
        score: score, evaluation: evaluation);
    if (status == TaskStatus.done) {
      evaluateTaskByGpt(taskId, score, evaluation);
    }
  }

  showGoalsAndTasks() async {
    int? goalId = await showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      context: Get.context!,
      builder: (_) => GoalWidget(
        orderedGoals: agentData.orderedGoals,
        goalsMap: agentData.goalsMap,
        tasksMap: agentData.tasksMap,
        changeTaskStatus: updateTaskStatus,
        onAddNewTask: onAddNewTask,
      ),
    );

    if (goalId != null && goalId > 0) {
      SeeGoal? goal = agentData.goalsMap[goalId];
      if (goal != null) {
        SeeGoalExperiences? experiences = await DB.isar!.seeGoalExperiences
            .where()
            .goalIdEqualTo(goalId)
            .sortByInsertTimeDesc()
            .findFirst();
        await showDialog(
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          context: Get.context!,
          builder: (_) => GoalExperienceWidget(
            goal: goal,
            experiences: experiences,
            experienceId: experiences?.id ?? 0,
            updateGoalAndExperiences: updateGoalAndExperiences,
            deleteExperience: deleteExperience,
          ),
        );
      }
    }
  }

  Future<bool> updateGoalAndExperiences(
      SeeGoal goal, int experienceId, List<String> experiences) async {
    await agentData.updateGoal(goal.id,
        name: goal.name,
        description: goal.description,
        priority: goal.priority);
    if (experienceId > 0) {
      await agentData.updateExperience(experienceId, experiences);
    }
    return true;
  }

  Future<bool> deleteExperience(int experienceId) async {
    return await agentData.deleteExperience(experienceId);
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
    if (newTasks.isEmpty) {
      agentData.updateGoal(goalId);
      return [];
    }

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
    return await askUserCommon(goal, showText, showAvatar: true);
  }

  Future<String> askUserCommon(
    SeeGoal goal,
    String inputText, {
    int taskId = 0,
    bool showAvatar = false,
  }) async {
    MyAction action = MyAction(goal.id, 0, ActionType.askUserCommon, inputText);
    if (showAvatar) {
      Me.defaultSpeaker.talk(inputText);
    }
    homeCon.setInSubWindow(true);
    await action.excute();
    homeCon.setInSubWindow(false);
    Log.log
        .fine('askUserCommon input:$inputText, output: ${action.act?.output}');
    if (taskId > 0 && action.act != null && action.act!.output.isNotEmpty) {
      await agentData.saveConversation(goal.id, taskId, inputText,
          from: AgentData.conversationIdAssistant);
      await agentData.saveConversation(goal.id, taskId, action.act!.output,
          from: AgentData.conversationIdUser);
    }
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
Returns a set of tasks that can be executed step by step, with the following structure:
an array containing 1-3 elements with description: string, the description of the task, 
estimatedTimeInMinutes: the estimated time to live in minutes. Use 0 instead of null if you don't know, only one number is allowed.
Based on the task description: userInput, you can organize it into separate tasks that can be performed sequentially.
If the user doesn't have a plan, you can assign him a reasonable task based on experience.
Don't create tiny tasks of less than 10 minutes.
Note that this refers to specific tasks, not experiences. 
''',
      'outputJsonFormat': '''
{
  "reason": "...",
  "tasks":
[
  {
  "description": "string",
  "estimatedTimeInMinutes": "integer",
  "keyword": "string"
  }
]
}
''',
    };
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForCreateTask]!;
    // sysPromts += DB.promptsMap[DB.defaultPromptId]?.text ?? '';
    MyAction action = MyAction(goal.id, 0, ActionType.askGptForCreateTask, '',
        inMap: inputMap,
        sysPrompt: sysPromts,
        outputJsonFormat:
            '{"reason":"...", "tasks": [{ "description": "string", "estimatedTimeInMinutes": "number", "keyword": "string"}]}');
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
        barrierDismissible: false,
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
    lastCheckProgressTime = DateTime.now();
    return firstId;
  }

  evaluateTaskByGpt(int taskId, int score, String evaluate) async {
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

    List<String> experiences = [];
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForNewExperience]!;
    List<String> conversations = await agentData.getConversationOfGoal(goal.id);
    List<String> experiencesUsed = await agentData.getExperience(goal.id);
    // ask gpt for new experience
    Map<String, dynamic> inputMap = {
      'goalState': goalState.toString(),
      'conversations': conversations,
      'experienceUsed': experiencesUsed,
      'constraints': '''
Please reply an array containing similar experience after optimization;
Every experience should be short, less than 100 words;
''',
      'outputJsonFormat': '''
{
  "reason": "...",
  "experiences":[
    "experience 1", "experience 2", "experience 3"
  ]
}
''',
    };
    MyAction action = MyAction(
        goal.id, 0, ActionType.askGptForNewExperience, '',
        inMap: inputMap,
        sysPrompt: sysPromts,
        outputJsonFormat: '{"reason":"...", "experiences": []}');
    if (averageScore < 7) {
      action.temperature = 0.9;
    }
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
    // if new experience is the same as the old one, then return false
    if (compareList(experiences, experiencesUsed)) {
      Log.log
          .warning('askGptForNewExperience output is the same as the old one');
      return false;
    }

    // update experience

    List<String> keywords = [];
    // get all keywords from goal.tasks
    for (int i = 0; i < goal.tasks.length; i++) {
      SeeTask? task = agentData.tasksMap[goal.tasks[i]];
      if (task == null) {
        continue;
      }
      keywords.add(task.keyword);
    }
    keywords = keywords.toSet().toList();

    await agentData.saveExperience(
        goal, averageScore.round(), experiences, keywords);
    return true;
  }

  bool isNearProgressCheckTime() {
    DateTime now = DateTime.now();
    if (now.difference(lastCheckProgressTime).inSeconds >
        minCheckProgressInterval * 0.9) {
      return true;
    }
    return false;
  }

  setNeedRemindSitting(MyStatus flag) {
    Log.log.fine('setNeedRemindSitting $flag');
    lastStatus = flag;
  }

  Future<int> generateNextAction(int taskId) async {
    SeeGoal? goal = agentData.goalsMap[agentData.tasksMap[taskId]?.goalId];
    SeeTask? task = agentData.tasksMap[taskId];
    MyStatus needRemindSittingThisTime = MyStatus.none;
    if (goal == null || task == null) {
      Log.log.warning(
          'generateNextAction goal or task is null, goal: $goal, task: $task');
      return 0;
    }
    DateTime now = DateTime.now();

    // get last action from db
    SeeAction? lastAction = await DB.isar?.seeActions
        .where()
        .taskIdEqualTo(taskId)
        .sortByStartTimeDesc()
        .findFirst();
    if (task.startTime != null && lastAction != null) {
      lastCheckProgressTime = task.startTime!.isBefore(lastAction.startTime)
          ? lastAction.startTime
          : task.startTime!;
    } else if (task.startTime != null) {
      lastCheckProgressTime = task.startTime!;
    } else if (lastAction != null) {
      lastCheckProgressTime = lastAction.startTime;
    }
    // make sure task.startTime is before minCheckProgressInterval seconds ago and before minCheckProgressInterval seconds ago
    int span = now.difference(lastCheckProgressTime).inSeconds;
    if (span < minCheckProgressInterval) {
      Log.log.fine(
          'generateNextAction lastCheckProgressTime is too close, skip, lastCheckProgressTime: $lastCheckProgressTime');
      return 0;
    } else if (span < maxCheckProgressInterval &&
        DB.setting.enableCamera &&
        now.difference(task.startTime!).inMinutes <
            task.estimatedTimeInMinutes) {
      // check if user is not here or askew
      if (lastStatus != MyStatus.askew && lastStatus != MyStatus.nobody) {
        Log.log.fine(
            'generateNextAction lastCheckProgressTime is too close, skip, lastCheckProgressTime: $lastCheckProgressTime, needRemindSitting: $lastStatus');
        return 0;
      }
    }
    if (lastStatus == MyStatus.askew || lastStatus == MyStatus.nobody) {
      needRemindSittingThisTime = lastStatus;
      setNeedRemindSitting(MyStatus.none);
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

    await askGptForTaskProgressEvaluation(
        goal, task, needRemindSittingThisTime);

    return 0;
  }

  String generateProgressEvaluationReactions(
      int questionCount, double timeRatio, MyStatus needRemindSittingThisTime) {
    // sample progressEvaluationMap keys and values according to current questions and times
    List<String> keys =
        AgentPromts.progressEvaluationOutputFormatMap.keys.toList();
    String values = '';
    Map<String, String> addtionMap = {};
    for (int i = 0; i < keys.length; i++) {
      addtionMap[keys[i]] = '';
    }
    const String notRecommendKey = ' (Not recommended)';
    const String recommendKey = ' (recommended)';
    if (needRemindSittingThisTime == MyStatus.askew ||
        needRemindSittingThisTime == MyStatus.nobody) {
      // addtionMap[AgentPromts.progressActTipsToUser] = recommendKey;
      addtionMap[AgentPromts.progressActTipsToUser] =
          ' (recommended because he is not sitting upright or disappeared)';
    } else if (questionCount < 1) {
      addtionMap[AgentPromts.progressActNeedSearch] = notRecommendKey;
    } else {
      if (Random().nextDouble() < 0.3) {
        addtionMap[AgentPromts.progressActNeedSearch] = recommendKey;
      }
    }
    for (int i = 0; i < keys.length; i++) {
      if (values.isNotEmpty) {
        values += ',';
      }
      values += AgentPromts.progressEvaluationOutputFormatMap[keys[i]]! +
          (addtionMap[keys[i]] ?? '');
    }
    return values;
  }

  Future<bool> askGptForTaskProgressEvaluation(
      SeeGoal goal, SeeTask task, MyStatus needRemindSittingThisTime) async {
    GoalState? goalState = await agentData.readStateOfGoal(goal);
    if (goalState == null) {
      Log.log
          .warning('generateNextAction goalState is null, goal: ${goal.name}');
      return false;
    }
    List<String> questions = await agentData
        .getLatestQuestionAskByUser(task.startTime ?? task.insertTime);
    List<String> conversations =
        await agentData.getConversation(goal.id, task.id);
    String sysPromts =
        AgentPromts.agentPrompts[ActionType.askGptForTaskProgressEvaluation]!;
    List<String> experiencesUsed =
        await agentData.getExperienceWithKeywords(goal.id, [task.keyword]);
    String reactions = generateProgressEvaluationReactions(
        questions.length + conversations.length,
        agentData.getTimeSpentRatio(task),
        needRemindSittingThisTime);
    if (reactions.isEmpty) {
      Log.log.info(
          'askGptForTaskProgressEvaluation reactions is empty, goal: ${goal.name}, task: ${task.description}');
      return false;
    }
    // ask gpt for new experience
    Map<String, dynamic> inputMap = {
      'goalName': goalState.goalName,
      'goalDiscription': goalState.goalDescription,
      'taskDiscription': task.description,
      'estimatedTimeInMinutes': task.estimatedTimeInMinutes,
      'timeSpentInMinutes': DateTime.now()
          .difference(task.startTime ?? task.insertTime)
          .inMinutes,
      'conversations': conversations,
      'minorConversations': questions,
      'experienceUsed': experiencesUsed,
      'envStates': goalState.envStates.map((e) => e.toString()).toList(),
      'outputJsonFormat': reactions,
      'constraints':
          '''The answer should be brief and output like outputJsonFormat with required "act".
''',
    };
    if (needRemindSittingThisTime == MyStatus.askew) {
      inputMap['extralInfo'] =
          'In addition to the progress check of the task, he needs to be reminded to sit upright, now he is not sitting well.';
    } else if (needRemindSittingThisTime == MyStatus.nobody) {
      inputMap['extralInfo'] =
          'In addition to the progress check of the task, he needs to be reminded to sit upright, now he is not here.';
    }
    MyAction action = MyAction(
        goal.id, task.id, ActionType.askGptForTaskProgressEvaluation, '',
        inMap: inputMap, sysPrompt: sysPromts, outputJsonFormat: reactions);
    await action.excute();
    Log.log
        .fine('askGptForTaskProgressEvaluation output: ${action.act?.output}');
    String gptReplyText = '';
    String reason = '';
    String question = '';
    String answer = '';
    bool replyOk = false;
    bool isQuiz = false;
    String parentMessageId = action.parentMessageId;
    // Perform up to 3 user inquiries or search operations based on the last return, then give the user a prompt
    try {
      String nextInput = '';
      for (int i = 0; i < 5; i++) {
        gptReplyText = action.outputMap?['text'] ?? '';
        reason = action.outputMap?['reason'] ?? '';
        switch (action.outputMap?['act']) {
          case AgentPromts.progressActNeedMoreInfo:
            if (gptReplyText.length < 20) {
              gptReplyText = '$reason\n$gptReplyText';
            }
            nextInput = await askUserCommon(goal, gptReplyText,
                taskId: task.id, showAvatar: true);
            if (nextInput.isEmpty) {
              Log.log.warning(
                  'try time $i, askGptForTaskProgressEvaluation userFeedback is empty');
              return false;
            }
            Log.log.info(
                'try time $i, askGptForTaskProgressEvaluation userFeedback: $nextInput');
            break;
          case AgentPromts.progressActNeedSearch:
            MyAction subAction = MyAction(
              goal.id,
              task.id,
              ActionType.search,
              gptReplyText,
              sysPrompt: sysPromts,
              parentMessageIdIn: parentMessageId,
            );
            await subAction.excute();
            Log.log.info(
                'try time $i, askGptForTaskProgressEvaluation search output: ${subAction.act?.output}');
            nextInput = subAction.act?.output ?? '';
            if (nextInput.isEmpty) {
              Log.log.warning(
                  'try time $i, askGptForTaskProgressEvaluation search output is empty, ${subAction.act?.output}');
              return false;
            }
            break;
          case AgentPromts.progressActQuiz:
            isQuiz = true;
            question = action.outputMap?['question'] ?? '';
            answer = action.outputMap?['answer'] ?? '';
            if (question.isEmpty) {
              Log.log.warning(
                  'try time $i, askGptForTaskProgressEvaluation question is empty, ${action.act?.output}');
              return false;
            }
            replyOk = true;
            break;
          case AgentPromts.progressActTipsToUser:
            if (gptReplyText.length < 20) {
              gptReplyText = '$reason\n$gptReplyText';
            }
            if (gptReplyText.isEmpty) {
              Log.log.warning(
                  'try time $i, askGptForTaskProgressEvaluation gptReplyText is empty, ${action.act?.output}');
              return false;
            }
            replyOk = true;
            break;
          default:
            Log.log.warning(
                'try time $i, askGptForTaskProgressEvaluation act is wrong, ${action.act?.output}');
            return false;
        }
        if (replyOk) {
          break;
        }
        nextInput = '''{"reply":"$nextInput" }''';
        action = MyAction(goal.id, task.id,
            ActionType.askGptForTaskProgressEvaluation, nextInput,
            sysPrompt: sysPromts,
            parentMessageIdIn: parentMessageId,
            outputJsonFormat: reactions);
        await action.excute();
        parentMessageId = action.parentMessageId;
        Log.log.fine(
            'try time $i, askGptForTaskProgressEvaluation gpt output: ${action.act?.output}');
      }
    } catch (e) {
      Log.log.warning('askGptForTaskProgressEvaluation error, $e');
      return false;
    }

    // show text to user
    if (!replyOk) {
      Log.log.warning(
          'askGptForTaskProgressEvaluation replyOk is false, ${action.act?.output}');
      return false;
    }
    await showTextToUser(
        text: gptReplyText,
        messageId: parentMessageId,
        goalId: goal.id,
        taskId: task.id,
        isQuiz: isQuiz,
        question: question,
        answer: answer);
    return true;
  }

  Future<bool> showTextToUser({
    bool showAvatar = true,
    String text = '',
    String messageId = '',
    List<String> strings = const [],
    Map<String, dynamic> map = const {},
    int goalId = 0,
    int taskId = 0,
    bool isQuiz = false,
    String question = '',
    String answer = '',
  }) async {
    if (showAvatar) {
      if (isQuiz) {
        text = question;
      }
      Me.defaultSpeaker.talk(text, messageId: messageId);
    }
    if (isQuiz) {
      text = 'question: $question\n answer: $answer';
    }
    if (goalId > 0 && taskId > 0) {
      await agentData.saveConversation(goalId, taskId, text);
    }
    homeCon.setInSubWindow(true);
    if (isQuiz) {
      await showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: Get.context!,
        builder: (_) => QuizWidget(
          question: question,
          answer: answer,
        ),
      );
    } else {
      await showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: Get.context!,
        builder: (_) => TxtShowWidget(text: text),
      );
    }
    homeCon.setInSubWindow(false);
    return true;
  }
}
