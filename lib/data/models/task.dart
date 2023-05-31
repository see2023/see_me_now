import 'package:isar/isar.dart';

part 'task.g.dart';

enum GoalType { once, daily, always }

enum TaskStatus { pending, running, done, failed, suspended, cancelled }

enum ActionType {
  none,
  queryRawData,
  queryStatsData,
  search,
  askUserCommon,
  askUserForEvaluation,
  askUserForTaskProgress,
  askUserForTaskReduce,
  askGptForCreateTask,
  askGptForNextAction,
  askGptForTaskProgressEvaluation,
  askGptForTaskReorder,
  askGptForTaskReduce,
  askGptForNewExperience,
  talkToPerson,
  getNewPictureFromCamera,
}

enum StateKey { none, appear, upright, smile }

@embedded
class StatePattern {
  // appear, upright, smile
  @enumerated
  StateKey stateKey = StateKey.none;
  bool positive = true;
}

@embedded
class TaskEvaluation {}

@collection
class SeeGoal {
  Id id = Isar.autoIncrement;
  String name = '';
  String description = '';
  @Index()
  int priority = 0;
  @Index()
  DateTime insertTime = DateTime.now();
  DateTime? updateTime;
  @enumerated
  GoalType type = GoalType.daily;
  List<int> tasks = [];
  List<StatePattern> statePatterns = [];
}

@collection
class SeeGoalExperiences {
  Id id = Isar.autoIncrement;

  @Index()
  int goalId = 0;

  @Index()
  DateTime insertTime = DateTime.now();

  @Index()
  int score = 0;

  @Index()
  List<String> keywords = [];

  List<String> experiences = [];
}

@collection
class SeeTask {
  Id id = Isar.autoIncrement;

  @Index()
  int goalId = 0;
  // int parentTaskId = 0;
  // List<int> preConditionTasks = [];

  // 2023-01-01
  @Index()
  String taskDate = DateTime.now().toString().substring(0, 10);

  String description = '';

  @Index()
  String keyword = '';

  @enumerated
  TaskStatus status = TaskStatus.pending;

  @Index()
  DateTime insertTime = DateTime.now();
  DateTime? startTime;
  DateTime? endTime;
  int estimatedTimeInMinutes = 0;
  int? consumedSeconds;

  @enumerated
  String evaluation = '';
  int score = 0;

  String parentMessageId = '';
}

@collection
class SeeAction {
  Id id = Isar.autoIncrement;

  @Index()
  int goalId = 0;

  @Index()
  int taskId = 0;
  @enumerated
  ActionType type = ActionType.queryRawData;

  @Index()
  DateTime startTime = DateTime.now();
  DateTime? endTime;

  String input = '';
  String output = '';

  float cost = 0;
}

@collection
class MeStateHistory {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime insertTime = DateTime.now();

  @enumerated
  @Index()
  StateKey stateKey = StateKey.none;

  float value = 0.0;
}

@collection
class Conversation {
  Id id = Isar.autoIncrement;

  @Index()
  int goalId = 0;

  @Index()
  int taskId = 0;

  @Index()
  DateTime insertTime = DateTime.now();

  String from = 'AI';

  String text = '';
}
