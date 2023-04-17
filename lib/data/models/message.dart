import 'package:isar/isar.dart';

part 'message.g.dart';
// flutter pub run build_runner build

enum MessageType {
  audio,
  custom,
  file,
  image,
  system,
  text,
  unsupported,
  video
}

enum Status { delivered, error, seen, sending, sent }

/*
chat ui type:
abstract class Message extends Equatable {
  const Message({
    required this.author,
    this.createdAt,
    required this.id,
    this.metadata,
    this.remoteId,
    this.repliedMessage,
    this.roomId,
    this.showStatus,
    this.status,
    required this.type,
    this.updatedAt,
  });
  }

*/

@collection
class Message {
  Id id = Isar.autoIncrement;

  String? author; //

  @Index()
  DateTime createdAt = DateTime.now();

  String? uuid; // (chat ui type).id

  String? metadata;

  String? remoteId;

  // @Index() // full text index ?
  String text = '';

  @Index()
  int topicId = 0; // (chat ui type).roomId

  bool showStatus = true;

  @enumerated
  late Status status = Status.sending;

  @enumerated
  MessageType type = MessageType.text;

  @Index()
  String? updateAt;
}
