import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';

part 'task_priority.g.dart';

@HiveType(typeId: 2)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

extension TaskPriorityExtension on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return kGreenColor;
      case TaskPriority.medium:
        return kYellowColor;
      case TaskPriority.high:
        return kRedColor;
      default:
        return CupertinoColors.black;
    }
  }
}
