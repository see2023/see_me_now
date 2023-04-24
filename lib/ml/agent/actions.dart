import 'package:see_me_now/data/models/task.dart';

class MyAction {
  SeeAction? data;
  MyAction(int taskId, ActionType type) {
    data = SeeAction();
    data?.id = 0;
  }
}
