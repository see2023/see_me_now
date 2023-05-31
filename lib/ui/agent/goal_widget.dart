import 'package:flutter/material.dart';
import 'package:see_me_now/data/db_tools.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/ml/agent/agent_data.dart';
import 'package:get/get.dart';
import 'package:see_me_now/ui/agent/rating_widget.dart';

class SimpleGoalWidget extends StatefulWidget {
  final GoalInfo? goal;
  final Function(bool)? onSubmitted;
  const SimpleGoalWidget({Key? key, this.goal, this.onSubmitted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SimpleGoalWidgetState();
}

class _SimpleGoalWidgetState extends State<SimpleGoalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 0.75,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // show goal name
              Expanded(flex: 1, child: Text(widget.goal?.name ?? '')),

              // show SimpleGoal's List of SimpleTask, first line is table header, last line to add new task
              Expanded(
                flex: 10,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (widget.goal?.tasks?.length ?? 0) + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // table header
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Task',
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Time(min)',
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'X',
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // show SimpleTask
                      TaskInfo? taskInfo = widget.goal?.tasks?[index - 1];
                      if (taskInfo == null) {
                        return Container();
                      }
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  TextField(
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    controller: TextEditingController(
                                        text:
                                            '${taskInfo.description}(${taskInfo.keyword})'),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.goal?.tasks?[index - 1]
                                            .description = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                    text: widget.goal?.tasks?[index - 1]
                                            .estimatedTimeInMinutes
                                            .toString() ??
                                        ''),
                                onChanged: (value) {
                                  setState(() {
                                    int timeInMinutes = 0;
                                    try {
                                      timeInMinutes = int.parse(value);
                                    } catch (e) {
                                      timeInMinutes = 0;
                                    }
                                    widget.goal?.tasks?[index - 1]
                                        .estimatedTimeInMinutes = timeInMinutes;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                alignment: Alignment.centerRight,
                                onPressed: () {
                                  setState(() {
                                    widget.goal?.tasks?.removeAt(index - 1);
                                  });
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),

              Expanded(
                flex: 1,
                child: Row(
                  // OK and Cancel button
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.onSubmitted?.call(true);
                        Get.back();
                      },
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () {
                        widget.onSubmitted?.call(false);
                        Get.back();
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressWidget extends StatefulWidget {
  final SeeTask? task;
  const ProgressWidget({Key? key, this.task}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProgressWidgetState();
}

//just show progress bar of the running SeeTask by startTime, estimatedTimeInMinutes
class _ProgressWidgetState extends State<ProgressWidget> {
  bool rendering = false;
  @override
  void initState() {
    super.initState();
    rendering = true;
  }

  @override
  void dispose() {
    rendering = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // refresh progress per minute
    Future.delayed(const Duration(seconds: 10), () {
      if (rendering) {
        setState(() {});
      }
    });
    int estimatedTimeInMinutes = widget.task?.estimatedTimeInMinutes ?? 0;
    if (estimatedTimeInMinutes <= 0) {
      estimatedTimeInMinutes = 1;
    }
    int actualTimeInMinutes = 0;
    if (widget.task?.startTime != null) {
      actualTimeInMinutes = getTimeSpentInMinutes(widget.task!);
    }
    return Text(
      '${actualTimeInMinutes.toString()} / ${estimatedTimeInMinutes.toString()}',
      style: const TextStyle(fontSize: 15),
    );
    // double progress = actualTimeInMinutes / estimatedTimeInMinutes;
    // return Container(
    //   padding: const EdgeInsets.all(20.0),

    //   // show progress bar
    //   child: LinearProgressIndicator(
    //     value: actualTimeInMinutes / estimatedTimeInMinutes,
    //     backgroundColor: Colors.grey,
    //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    //   ),
    // );
  }
}

// show goals and tasks with finish and cancel button

// ignore: must_be_immutable
class GoalWidget extends StatefulWidget {
  List<int>? orderedGoals = [];
  Map<int, SeeGoal>? goalsMap;
  Map<int, SeeTask>? tasksMap;
  // async Funcion
  Future<void> Function(int, TaskStatus, {int score, String evaluation})?
      changeTaskStatus;
  Function(int)? onAddNewTask;
  GoalWidget(
      {Key? key,
      this.orderedGoals,
      this.goalsMap,
      this.tasksMap,
      this.changeTaskStatus,
      this.onAddNewTask})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.log.fine('building GoalWidget, route:${Get.currentRoute}');
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.75,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 90, left: 5, right: 5, bottom: 20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.orderedGoals?.length ?? 0,
                itemBuilder: (context, goalIndex) {
                  SeeGoal? goal =
                      widget.goalsMap?[widget.orderedGoals?[goalIndex]];
                  if (goal == null) {
                    return Container();
                  }
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    // show tasks of this goal
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: goal.tasks.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // show goal name
                          return Row(
                            children: [
                              Text(
                                goal.name,
                                textAlign: TextAlign.left,
                                softWrap: true,
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (widget.onAddNewTask != null) {
                                      widget.onAddNewTask?.call(goal.id);
                                    }
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.add)),
                              // button to modify goal
                              IconButton(
                                onPressed: () async {
                                  Get.back(result: goal.id);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          );
                        }
                        SeeTask? task = widget.tasksMap?[goal.tasks[index - 1]];
                        if (task == null) {
                          return Container();
                        }
                        bool notFinished = task.status != TaskStatus.done &&
                            task.status != TaskStatus.cancelled &&
                            task.status != TaskStatus.failed;
                        return Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // show text of task
                              Expanded(
                                flex: 5,
                                child: Text(
                                  style: TextStyle(
                                    color: task.status == TaskStatus.running
                                        ? Colors.yellow
                                        : notFinished
                                            ? Colors.white
                                            : Colors.grey,
                                  ),
                                  task.description,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ),

                              // show progress of task
                              Expanded(
                                flex: 1,
                                child: ProgressWidget(
                                  task: task,
                                ),
                              ),

                              // show cancel|suspend button
                              task.status == TaskStatus.done
                                  ? const Opacity(
                                      opacity: 0.5,
                                      child: Expanded(
                                        flex: 1,
                                        child: Icon(Icons.gpp_good),
                                      ),
                                    )
                                  : task.status == TaskStatus.cancelled ||
                                          task.status == TaskStatus.failed
                                      ? const Opacity(
                                          opacity: 0.5,
                                          child: Expanded(
                                            flex: 1,
                                            child: Icon(Icons.delete),
                                          ),
                                        )
                                      : task.status == TaskStatus.running
                                          ?
                                          // show suspend button
                                          Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                alignment:
                                                    Alignment.centerRight,
                                                onPressed: () async {
                                                  await widget.changeTaskStatus
                                                      ?.call(task.id,
                                                          TaskStatus.suspended);
                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons.stop),
                                              ),
                                            )
                                          // show cancel button
                                          : Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                alignment:
                                                    Alignment.centerRight,
                                                onPressed: () {
                                                  // show confirm cancel dialog
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Cancel task'),
                                                      content: const Text(
                                                          'Are you sure you want to cancel this task?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await widget
                                                                .changeTaskStatus
                                                                ?.call(
                                                                    task.id,
                                                                    TaskStatus
                                                                        .cancelled);
                                                            setState(() {});
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                    Icons.cancel_outlined),
                                              ),
                                            ),

                              // show finish|continue button
                              task.status == TaskStatus.running
                                  ? Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        alignment: Alignment.centerRight,
                                        onPressed: () {
                                          // show RatingWidget
                                          Get.dialog(RatingWidget(
                                            goal: goal,
                                            task: task,
                                            onRatingSubmit: (int rating,
                                                String evaluation) async {
                                              await widget.changeTaskStatus
                                                  ?.call(
                                                      task.id, TaskStatus.done,
                                                      score: rating,
                                                      evaluation: evaluation);
                                              setState(() {
                                                task.status = TaskStatus.done;
                                              });
                                            },
                                          ));
                                        },
                                        icon: const Icon(Icons.done),
                                      ),
                                    )
                                  : task.status == TaskStatus.pending ||
                                          task.status == TaskStatus.suspended
                                      ? // show continue button
                                      Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: () {
                                              widget.changeTaskStatus?.call(
                                                  task.id, TaskStatus.running);
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.play_arrow),
                                          ),
                                        )
                                      : Expanded(flex: 1, child: Container()),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white70,
              iconSize: 36,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// show and modify goal's experience
class GoalExperienceWidget extends StatefulWidget {
  final SeeGoal goal;
  final SeeGoalExperiences? experiences;
  final Function(SeeGoal, int, List<String>)? updateGoalAndExperiences;
  final Function(int) deleteExperience;
  final int experienceId;
  const GoalExperienceWidget(
      {Key? key,
      required this.goal,
      required this.experiences,
      required this.updateGoalAndExperiences,
      required this.experienceId,
      required this.deleteExperience})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GoalExperienceWidgetState();
}

class _GoalExperienceWidgetState extends State<GoalExperienceWidget> {
  SeeGoal? goal;
  SeeGoal tmpGoal = SeeGoal();
  List<String> experienceList = [];
  @override
  void initState() {
    super.initState();
    goal = widget.goal;
    // copy goal to tmpGoal
    tmpGoal.name = goal?.name ?? '';
    tmpGoal.description = goal?.description ?? '';
    tmpGoal.priority = goal?.priority ?? 0;
    if (widget.experiences != null) {
      for (int i = 0; i < widget.experiences!.experiences.length; i++) {
        experienceList.add(widget.experiences!.experiences[i]);
      }
    }
  }

// show goal's name, discrption,priority[1-10], GoalType, experience, and two buttons to modify/cancel them.
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.75,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 90, left: 5, right: 5, bottom: 20),
              //show goal name, discrption,priority[1-10], GoalType, experience, and two buttons to modify/cancel them.
              child: Column(
                  // space size between widgets
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'GoalName'.tr,
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            textAlign: TextAlign.left,
                            controller:
                                TextEditingController(text: goal?.name ?? ''),
                            onChanged: (String value) {
                              tmpGoal.name = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'GoalDescription'.tr,
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            maxLines: null,
                            textAlign: TextAlign.left,
                            controller: TextEditingController(
                                text: goal?.description ?? ''),
                            onChanged: (String value) {
                              tmpGoal.description = value;
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'GoalPriority'.tr,
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                                text: goal?.priority.toString() ?? ''),
                            onChanged: (String value) {
                              try {
                                tmpGoal.priority = int.parse(value);
                              } catch (e) {
                                Log.log.fine('parse priority error: $e');
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      child: Row(children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'GoalExperience'.tr,
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                        // delete button
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              // delete experience
                              widget.deleteExperience(widget.experienceId);
                              Get.back();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ]),
                    ),
                    experienceList.isNotEmpty
                        ? Expanded(
                            flex: 1,
                            // 按行显示experienceList， 每一行都可以编辑； 可以添加新行，删除某一行
                            child: ListView.builder(
                              itemCount: experienceList.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == experienceList.length) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: IconButton(
                                          onPressed: () {
                                            // add experience
                                            setState(() {
                                              experienceList.add('');
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          // 自动换行
                                          maxLines: null,
                                          textAlign: TextAlign.left,
                                          controller: TextEditingController(
                                              text: experienceList[index]),
                                          onChanged: (String value) {
                                            experienceList[index] = value;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            // delete experience
                                            setState(() {
                                              experienceList.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Expanded(
                            flex: 1,
                            child: Text(
                              'NoExperience'.tr,
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                          ),
                    // ok cancel button
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              // modify goal
                              Log.log
                                  .fine('saving goal and experience $tmpGoal');
                              if (goal == null ||
                                  widget.updateGoalAndExperiences == null) {
                                return;
                              }
                              goal!.name = tmpGoal.name.trim();
                              goal!.description = tmpGoal.description.trim();
                              goal!.priority = tmpGoal.priority;
                              await widget.updateGoalAndExperiences!(
                                  goal!, widget.experienceId, experienceList);
                              Get.back();
                            },
                            icon: const Icon(Icons.done),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white70,
              iconSize: 36,
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
