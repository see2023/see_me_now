import 'package:isar/isar.dart';

part 'prompts.g.dart';

@collection
class Prompt {
  Id id = Isar.autoIncrement;

  String? name;

  String? text;

  String? model; // gpt-3.5-turbo, gpt-4

  String? voiceName;
}
