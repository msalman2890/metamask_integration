import 'package:flutter/material.dart';
import 'package:metamask_wallet/core/utils/logger.dart';
import 'package:metamask_wallet/core/utils/periodic_task_manager.dart';

class AppLifeCycle {
  static final AppLifeCycle _instance = AppLifeCycle._internal();

  factory AppLifeCycle() {
    return _instance;
  }

  AppLifeCycle._internal();

  late final AppLifecycleListener _listener;

  void initializeListener() {
    _listener = AppLifecycleListener(
      onDetach: _onDetach,
      onHide: _onHide,
      onInactive: _onInactive,
      onPause: _onPause,
      onRestart: _onRestart,
      onResume: _onResume,
      onShow: _onShow,
      onStateChange: _onStateChanged,
    );
  }

  void dispose() {
    _listener.dispose();
  }

  void _onDetach() {
    Logger.log("app onDetach", name: "App Life Cycle");
    PeriodicTaskManager().stop();
  }

  void _onHide() => Logger.log("app onHide", name: "App Life Cycle");

  void _onInactive() => Logger.log("app onInactive", name: "App Life Cycle");

  void _onPause() => Logger.log("app onPause", name: "App Life Cycle");

  void _onRestart() => Logger.log("app onRestart", name: "App Life Cycle");

  void _onResume() => Logger.log("app onResume", name: "App Life Cycle");

  void _onShow() => Logger.log("app onShow", name: "App Life Cycle");

  void _onStateChanged(AppLifecycleState state) {
    // Track state changes
    Logger.log(state.name, name: "App Life Cycle");
  }
}
