import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';

part 'timer_task.g.dart';

@HiveType(typeId: 4)
class TimerTask {
  @HiveField(0)
  final String boxName;
  @HiveField(1)
  final int projectKey;
  @HiveField(2)
  final Task task;

  TimerTask({
    required this.boxName,
    required this.projectKey,
    required this.task,
  });

  TimerTask copyWith({
    String? boxName,
    int? projectKey,
    Task? task,
  }) {
    return TimerTask(
      boxName: boxName ?? this.boxName,
      projectKey: projectKey ?? this.projectKey,
      task: task ?? this.task,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimerTask &&
        other.boxName == boxName &&
        other.projectKey == projectKey &&
        other.task == task;
  }

  @override
  int get hashCode => boxName.hashCode ^ projectKey.hashCode ^ task.hashCode;
}
