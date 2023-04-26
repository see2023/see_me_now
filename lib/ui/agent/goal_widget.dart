import 'package:flutter/material.dart';
import 'package:see_me_now/data/log.dart';
import 'package:see_me_now/data/models/task.dart';
import 'package:see_me_now/ml/agent/goal_mananer.dart';
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // show goal name
              Text(widget.goal?.name ?? ''),

              // show SimpleGoal's List of SimpleTask, first line is table header, last line to add new task
              ListView.builder(
                shrinkWrap: true,
                itemCount: (widget.goal?.tasks?.length ?? 0) + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // table header
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          flex: 3,
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
                            flex: 3,
                            child: Text(
                              widget.goal?.tasks?[index - 1].description ?? '',
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                  text: widget.goal?.tasks?[index - 1]
                                          .estimatedTimeInMinutes
                                          .toString() ??
                                      ''),
                              onChanged: (value) {
                                setState(() {
                                  widget.goal?.tasks?[index - 1]
                                          .estimatedTimeInMinutes =
                                      int.parse(value);
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

              Row(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

// show goals and tasks with finish and cancel button

// ignore: must_be_immutable
class GoalWidget extends StatefulWidget {
  List<int>? orderedGoals = [];
  Map<int, SeeGoal>? goalsMap;
  Map<int, SeeTask>? tasksMap;
  Function(int, TaskStatus, {int score})? changeTaskStatus;
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
              padding: const EdgeInsets.only(
                  top: 100, left: 10, right: 10, bottom: 30),
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
                    padding: const EdgeInsets.all(5.0),
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
                                  icon: const Icon(Icons.add))
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
                                child: Text(
                                  style: TextStyle(
                                    color: notFinished
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                  task.description,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  task.estimatedTimeInMinutes.toString(),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                ),
                              ),
                              task.status == TaskStatus.done
                                  ? const Opacity(
                                      opacity: 0.5,
                                      child: Expanded(
                                        flex: 1,
                                        child: Icon(Icons.gpp_good),
                                      ),
                                    )
                                  : task.status == TaskStatus.cancelled
                                      ? const Opacity(
                                          opacity: 0.5,
                                          child: Expanded(
                                            flex: 1,
                                            child: Icon(Icons.delete),
                                          ),
                                        )
                                      : Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            alignment: Alignment.centerRight,
                                            onPressed: () {
                                              widget.changeTaskStatus?.call(
                                                  task.id,
                                                  TaskStatus.cancelled);
                                              setState(() {
                                                task.status =
                                                    TaskStatus.cancelled;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.cancel_outlined),
                                          ),
                                        ),
                              notFinished
                                  ? Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        alignment: Alignment.centerRight,
                                        onPressed: () {
                                          // show RatingWidget
                                          Get.dialog(RatingWidget(
                                            goal: goal,
                                            task: task,
                                            onRatingSubmit: (int rating) {
                                              widget.changeTaskStatus?.call(
                                                  task.id, TaskStatus.done,
                                                  score: rating);
                                              setState(() {
                                                task.status = TaskStatus.done;
                                              });
                                            },
                                          ));
                                        },
                                        icon: const Icon(Icons.done),
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
