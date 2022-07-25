import 'package:hive/hive.dart';
import 'package:TrailApp/core/values/keys.dart';
import 'package:TrailApp/models/pomodoro_timer.dart';

class PomodoroTimerStorageService {
  late final Box<PomodoroTimer> _box;

  Future<void> init() async {
    _box = await Hive.openBox<PomodoroTimer>(kPomodoroTimerBox);
  }

  PomodoroTimer getPomodoroTimer() {
    return _box.get(kPomodoroTimerBox)!;
  }

  Future<void> savePomodoroTimer(PomodoroTimer pomodoroTimer) async {
    await _box.put(kPomodoroTimerBox, pomodoroTimer);
  }
}
