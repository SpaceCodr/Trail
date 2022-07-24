import 'package:hive_flutter/adapters.dart';
import 'package:pomodoro_timer_task_management/core/extensions/color.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';
import 'package:pomodoro_timer_task_management/models/pomodoro_timer.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';

final _projects = [
  {
    'title': 'Inbox',
    'color': kIndigoColor.toHex(),
  },
  {
    'title': 'Today',
    'color': kYellowColor.toHex(),
  },
  {
    'title': 'Next 7 days',
    'color': kGreenColor.toHex(),
  },
  {
    'title': 'Some days',
    'color': kGreyColor.toHex(),
  },
];

Future<void> insertDefaultData() async {
  await _insertDefaultProjects();
  await _insertDefaultPomodoroTimer();
  await _insertDefaultTheme();
  await _insertDefaultTimerTheme();
}

Future<void> _insertDefaultProjects() async {
  final box = await Hive.openBox<Project>(kMainProjectBox);
  if (box.isEmpty) {
    for (int i = 0; i < _projects.length; i++) {
      final project = Project(
        title: _projects[i]['title'] as String,
        color: _projects[i]['color'] as String,
        date: DateTime.now().toIso8601String(),
      );
      await box.add(project);
    }
  }
}

Future<void> _insertDefaultPomodoroTimer() async {
  final box = await Hive.openBox<PomodoroTimer>(kPomodoroTimerBox);

  if (box.isEmpty) {
    final pomodoroTimer = PomodoroTimer.initial();
    await box.put(kPomodoroTimerBox, pomodoroTimer);
  }
}

Future<void> _insertDefaultTheme() async {
  final box = await Hive.openBox<int>(kThemeBox);

  if (box.isEmpty) {
    await box.put(kThemeBox, 0);
  }
}

Future<void> _insertDefaultTimerTheme() async {
  final box = await Hive.openBox<int>(kTimerThemeBox);
  if (box.isEmpty) {
    await box.put(kTimerThemeBox, 0);
  }
}
