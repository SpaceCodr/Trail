import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';

abstract class TimerEvent {}

class TimerStartedEvent extends TimerEvent {}

class TimerPausedEvent extends TimerEvent {}

class TimerResumedEvent extends TimerEvent {}

class TimerStoppedEvent extends TimerEvent {}

class TimerCycleCompletedEvent extends TimerEvent {
  final TimerMode mode;
  final int duration;

  TimerCycleCompletedEvent({
    required this.mode,
    required this.duration,
  });
}

class TimerCompletedEvent extends TimerEvent {}
