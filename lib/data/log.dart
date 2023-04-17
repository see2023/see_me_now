import 'package:simple_logger/simple_logger.dart';

class Log {
  static final SimpleLogger log = SimpleLogger();

  static void setLevel(Level level, {bool includeCallerInfo = true}) {
    log.setLevel(level, includeCallerInfo: includeCallerInfo);
  }
}
