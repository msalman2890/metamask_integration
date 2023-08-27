import 'dart:async';

class PeriodicTask {
  final String name;
  final Duration interval;
  final Function callback;
  late Timer _timer;

  PeriodicTask(
      {required this.name, required this.interval, required this.callback});

  void start() {
    callback();
    _timer = Timer.periodic(interval, (timer) => callback());
  }

  void stop() {
    _timer.cancel();
  }
}
