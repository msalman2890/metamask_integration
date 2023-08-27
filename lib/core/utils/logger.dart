import 'dart:developer' as dev;

class Logger {
  static LogMode _logMode = LogMode.debug;

  static void init(LogMode mode) {
    Logger._logMode = mode;
  }

  static void log(dynamic data, {StackTrace? stackTrace, String? name}) {
    if (_logMode == LogMode.debug) {
      if (stackTrace == null) {
        dev.log("$data", name: name ?? "LOG");
      } else {
        dev.log("Error Occurred",
            stackTrace: stackTrace, name: name ?? "Error", error: data);
      }
    }
  }
}

enum LogMode { debug, live }
