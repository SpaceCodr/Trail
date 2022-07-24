import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:pomodoro_timer_task_management/models/task.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String color;
  @HiveField(2)
  final List<Task>? tasks;
  @HiveField(3)
  final String date;

  Project({
    required this.title,
    required this.color,
    this.tasks,
    required this.date,
  });

  Project copyWith({
    String? title,
    String? color,
    List<Task>? tasks,
    String? date,
  }) {
    return Project(
      title: title ?? this.title,
      color: color ?? this.color,
      tasks: tasks ?? this.tasks,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Project &&
        other.title == title &&
        other.color == color &&
        listEquals(other.tasks, tasks) &&
        other.date == date;
  }

  @override
  int get hashCode =>
      title.hashCode ^ color.hashCode ^ tasks.hashCode ^ date.hashCode;
}
