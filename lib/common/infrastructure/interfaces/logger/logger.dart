abstract class LoggerInterface {
  void info(String message);
  void debug(String message);
  void error(String message, StackTrace? stackTrace);
  void warning(String message);
}
