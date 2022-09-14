// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:TrailApp/models/pomodoro_timer.dart';
import 'package:TrailApp/services/pomodoro_timer_storage_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  late final PomodoroTimerStorageService _pomodoroTimerStorageService;

  void init() async {
    _pomodoroTimerStorageService = PomodoroTimerStorageService();

    await _pomodoroTimerStorageService.init();

    emit(
      state.copyWith(
        pomodoroTimer: _pomodoroTimerStorageService.getPomodoroTimer(),
      ),
    );
  }

  void changePomodoroTimer(PomodoroTimer pomodoroTimer) async {
    emit(state.copyWith(pomodoroTimer: pomodoroTimer));
    await _pomodoroTimerStorageService.savePomodoroTimer(pomodoroTimer);
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
