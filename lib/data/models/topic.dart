import 'package:isar/isar.dart';

part 'topic.g.dart';

@collection
class Topic {
  Id id = Isar.autoIncrement;

  String? name;

  DateTime? createdAt;

  @Index()
  DateTime? updatedAt;

  String? lastMessagePreview;

  List<ApiState>? apiStates;

  int? promptId;
}

@embedded
class ApiState {
  String? apiId;
  bool? enabled;
  String? conversationId;
  String? parentMessageId;
  String? jsonStr;
  String? model;
}
