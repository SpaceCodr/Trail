part of 'settings_cubit.dart';

class SettingsState {
  final PomodoroTimer pomodoroTimer;

  SettingsState({
    required this.pomodoroTimer,
  });

  factory SettingsState.initial() => SettingsState(
        pomodoroTimer: PomodoroTimer.initial(),
      );

  SettingsState copyWith({
    PomodoroTimer? pomodoroTimer,
  }) {
    return SettingsState(
      pomodoroTimer: pomodoroTimer ?? this.pomodoroTimer,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsState && other.pomodoroTimer == pomodoroTimer;
  }

  @override
  int get hashCode => pomodoroTimer.hashCode;
}
