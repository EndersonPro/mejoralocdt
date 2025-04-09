import 'dart:developer' as developer;

import '../../infrastructure.dart';

class LoggerImpl implements LoggerInterface {
  @override
  void debug(String message) {
    developer.log(message, name: 'DEBUG');
  }

  @override
  void error(String message, StackTrace? stackTrace) {
    developer.log(message, name: 'ERROR', stackTrace: stackTrace);
  }

  @override
  void info(String message) {
    developer.log(message, name: 'INFO');
  }

  @override
  void warning(String message) {
    developer.log(message, name: 'WARNING');
  }
}
