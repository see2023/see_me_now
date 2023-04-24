import 'package:isar/isar.dart';

part 'task.g.dart';

enum GoalType { once, daily, always }

enum TaskStatus { pending, running, done, failed, suspended, cancelled }

enum TaskEvaluationFrom { gpt, human }

enum ActionType {
  queryRawData,
  queryStatsData,
  search,
  askGptForNewTask,
  askGptForNextAction,
  askGptForTaskProgressEvaluation,
  askGptForTaskReorder,
  askGptForTaskReduce,
  askGptForNewPromtsOfTask,
  getNewPictureFromCamera,
  talkToPerson,
  askPersonForEvaluation,
  askPersonForTaskProgress,
  askPersonForTaskReduce,
}

@embedded
class StatePattern {
  // appear, upright, smile
  int stateKey = 0;
  bool positive = true;
}

@embedded
class TaskEvaluation {
  @enumerated
  TaskEvaluationFrom from = TaskEvaluationFrom.gpt;
  String description = '';
  int score = 0;
  int cost = 0;
}

@collection
class SeeGoal {
  Id id = Isar.autoIncrement;
  String name = '';
  String description = '';
  int priority = 0;
  DateTime insertTime = DateTime.now();
  DateTime updateTime = DateTime.now();
  @enumerated
  GoalType type = GoalType.daily;
  List<StatePattern> statePatterns = [];
  List<String> experiences = [];
  List<int> tasks = [];
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

  @enumerated
  TaskStatus status = TaskStatus.pending;

  @Index()
  DateTime startTimeExpected = DateTime.now();
  DateTime? endTimeExpected;
  DateTime? startTime;
  DateTime? endTime;

  TaskEvaluation evaluation = TaskEvaluation();
  String parentMessageId = '';
  List<int> actions = [];
}

@collection
class SeeAction {
  Id id = Isar.autoIncrement;

  @Index()
  int taskId = 0;
  @enumerated
  ActionType type = ActionType.queryRawData;
  DateTime startTime = DateTime.now();
  DateTime? endTime;
  String input = '';
  String output = '';
}

enum StateKey { none, appear, upright, smile }

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
