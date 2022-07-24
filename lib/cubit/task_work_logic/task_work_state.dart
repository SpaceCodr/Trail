part of 'task_work_cubit.dart';

class TaskWorkState {
  final int workTime;
  final int workCycle;
  final Task? task;

  factory TaskWorkState.initial() => TaskWorkState(
        workTime: 0,
        workCycle: 0,
      );

  TaskWorkState({
    required this.workTime,
    required this.workCycle,
    this.task,
  });

  TaskWorkState copyWith({
    int? workTime,
    int? workCycle,
    Task? task,
  }) {
    return TaskWorkState(
      workTime: workTime ?? this.workTime,
      workCycle: workCycle ?? this.workCycle,
      task: task ?? this.task,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskWorkState &&
        other.workTime == workTime &&
        other.workCycle == workCycle &&
        other.task == task;
  }

  @override
  int get hashCode => workTime.hashCode ^ workCycle.hashCode ^ task.hashCode;
}
