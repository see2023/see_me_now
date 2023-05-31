import 'package:see_me_now/data/models/task.dart';

int getTimeSpentInMinutes(SeeTask task) {
  task.consumedSeconds ??= 0;
  if (task.startTime == null) {
    return task.consumedSeconds! ~/ 60;
  }
  DateTime endTime = task.endTime ?? DateTime.now();
  if (task.status == TaskStatus.running) {
    endTime = DateTime.now();
  }
  if (endTime.isBefore(task.startTime!)) {
    return task.consumedSeconds! ~/ 60;
  }
  return (endTime.difference(task.startTime!).inSeconds +
          task.consumedSeconds!) ~/
      60;
}
