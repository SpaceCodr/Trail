import 'package:hive_flutter/hive_flutter.dart';
import 'package:TrailApp/models/pomodoro_timer.dart';
import 'package:TrailApp/models/task_priority.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final TaskPriority priority;
  @HiveField(2)
  final int? workedInterval;
  @HiveField(3)
  final int? workedTime;
  @HiveField(4)
  final PomodoroTimer pomodoroTimer;
  @HiveField(5)
  final bool? isDone;
  @HiveField(6)
  final String date;

  Task({
    required this.title,
    required this.priority,
    this.workedInterval,
    this.workedTime,
    required this.pomodoroTimer,
    this.isDone,
    required this.date,
  });

  Task copyWith({
    String? title,
    TaskPriority? priority,
    int? workedInterval,
    int? workedTime,
    PomodoroTimer? pomodoroTimer,
    bool? isDone,
    String? date,
  }) {
    return Task(
      title: title ?? this.title,
      priority: priority ?? this.priority,
      workedInterval: workedInterval ?? this.workedInterval,
      workedTime: workedTime ?? this.workedTime,
      pomodoroTimer: pomodoroTimer ?? this.pomodoroTimer,
      isDone: isDone ?? this.isDone,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.title == title &&
        other.priority == priority &&
        other.workedInterval == workedInterval &&
        other.workedTime == workedTime &&
        other.pomodoroTimer == pomodoroTimer &&
        other.isDone == isDone &&
        other.date == date;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        priority.hashCode ^
        workedInterval.hashCode ^
        workedTime.hashCode ^
        pomodoroTimer.hashCode ^
        isDone.hashCode ^
        date.hashCode;
  }
}
