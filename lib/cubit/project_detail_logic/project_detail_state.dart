part of 'project_detail_cubit.dart';

@immutable
abstract class ProjectDetailState {}

class ProjectDetailLoading extends ProjectDetailState {}

class ProjectDetailLoadedState extends ProjectDetailState {
  final String projectTitle;
  final List<Task> tasks;
  final int completedTaskCount;
  final int totalTaskCount;
  final double workedTime;
  final double totalWorkTime;

  ProjectDetailLoadedState({
    required this.projectTitle,
    required this.tasks,
    required this.completedTaskCount,
    required this.totalTaskCount,
    required this.workedTime,
    required this.totalWorkTime,
  });

  factory ProjectDetailLoadedState.inital() => ProjectDetailLoadedState(
        projectTitle: '',
        tasks: const [],
        completedTaskCount: 0,
        totalTaskCount: 0,
        workedTime: 0,
        totalWorkTime: 0,
      );

  ProjectDetailLoadedState copyWith({
    String? projectTitle,
    List<Task>? tasks,
    int? completedTaskCount,
    int? totalTaskCount,
    double? workedTime,
    double? totalWorkTime,
  }) {
    return ProjectDetailLoadedState(
      projectTitle: projectTitle ?? this.projectTitle,
      tasks: tasks ?? this.tasks,
      completedTaskCount: completedTaskCount ?? this.completedTaskCount,
      totalTaskCount: totalTaskCount ?? this.totalTaskCount,
      workedTime: workedTime ?? this.workedTime,
      totalWorkTime: totalWorkTime ?? this.totalWorkTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectDetailLoadedState &&
        other.projectTitle == projectTitle &&
        listEquals(other.tasks, tasks) &&
        other.completedTaskCount == completedTaskCount &&
        other.totalTaskCount == totalTaskCount &&
        other.workedTime == workedTime &&
        other.totalWorkTime == totalWorkTime;
  }

  @override
  int get hashCode {
    return projectTitle.hashCode ^
        tasks.hashCode ^
        completedTaskCount.hashCode ^
        totalTaskCount.hashCode ^
        workedTime.hashCode ^
        totalWorkTime.hashCode;
  }
}
