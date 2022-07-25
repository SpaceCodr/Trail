import 'package:hive_flutter/adapters.dart';
import 'package:TrailApp/models/pomodoro_timer.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/models/task.dart';
import 'package:TrailApp/models/task_priority.dart';
import 'package:TrailApp/models/timer_task.dart';

void registerAllHiveApadters() {
  Hive.registerAdapter(PomodoroTimerAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(TimerTaskAdapter());
}
