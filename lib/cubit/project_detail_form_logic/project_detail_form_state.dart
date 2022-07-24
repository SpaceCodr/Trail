part of 'project_detail_form_cubit.dart';

class ProjectDetailFormState {
  final String taskTitle;
  final TaskPriority taskPriority;
  final PomodoroTimer pomodoroTimer;
  final bool isEditing;

  ProjectDetailFormState({
    required this.taskTitle,
    required this.taskPriority,
    required this.pomodoroTimer,
    required this.isEditing,
  });

  factory ProjectDetailFormState.initial() {
    return ProjectDetailFormState(
      taskTitle: '',
      taskPriority: TaskPriority.medium,
      pomodoroTimer: PomodoroTimer.initial(),
      isEditing: false,
    );
  }

  ProjectDetailFormState copyWith({
    String? taskTitle,
    TaskPriority? taskPriority,
    PomodoroTimer? pomodoroTimer,
    bool? isEditing,
  }) {
    return ProjectDetailFormState(
      taskTitle: taskTitle ?? this.taskTitle,
      taskPriority: taskPriority ?? this.taskPriority,
      pomodoroTimer: pomodoroTimer ?? this.pomodoroTimer,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectDetailFormState &&
        other.taskTitle == taskTitle &&
        other.taskPriority == taskPriority &&
        other.pomodoroTimer == pomodoroTimer &&
        other.isEditing == isEditing;
  }

  @override
  int get hashCode {
    return taskTitle.hashCode ^
        taskPriority.hashCode ^
        pomodoroTimer.hashCode ^
        isEditing.hashCode;
  }
}
