import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class TheApp {
  TheApp() {
    Command.globalExceptionHandler = (error, stackTrace) {
      _log.severe('${error.commandName}: ${error.error}', error, stackTrace);
    };
  }
  final _log = Logger('LoginViewModel');
}
