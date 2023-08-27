import 'package:metamask_wallet/core/utils/logger.dart';

import '../../model/periodic_task.dart';

class PeriodicTaskManager {
  static final PeriodicTaskManager _instance = PeriodicTaskManager._internal();

  factory PeriodicTaskManager() => _instance;

  PeriodicTaskManager._internal();

  final List<PeriodicTask> _tasks = [];

  void addTask(PeriodicTask task) {
    _tasks.add(task);
    _tasks.last.start();
  }

  void removeTask(String name) {
    _tasks.removeWhere((element) => element.name == name);
  }

  void startTask(String name) {
    try {
      _tasks.firstWhere((element) => element.name == name).start();
    } catch (e) {
      Logger.log(e);
    }
  }

  void start() {
    for (var task in _tasks) {
      task.start();
    }
  }

  void stop() {
    for (var task in _tasks) {
      task.stop();
    }
  }
}
