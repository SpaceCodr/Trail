part of 'statistics_cubit.dart';

enum StatisticsType {
  all,
  week,
  month,
}

@immutable
abstract class StatisticsState {}

class StatisticsLoadingState extends StatisticsState {}

class StatisticsLoadedState extends StatisticsState {
  final List<Project> topProjects;
  final int totalProjectCount;
  final int completedProjectCount;
  final int totalTaskCount;
  final int completedTaskCount;
  final double totalWorkTime;
  final double workedTime;

  StatisticsLoadedState({
    required this.topProjects,
    required this.totalProjectCount,
    required this.completedProjectCount,
    required this.totalTaskCount,
    required this.completedTaskCount,
    required this.totalWorkTime,
    required this.workedTime,
  });

  StatisticsLoadedState copyWith({
    List<Project>? topProjects,
    int? totalProjectCount,
    int? completedProjectCount,
    int? totalTaskCount,
    int? completedTaskCount,
    double? totalWorkTime,
    double? workedTime,
  }) {
    return StatisticsLoadedState(
      topProjects: topProjects ?? this.topProjects,
      totalProjectCount: totalProjectCount ?? this.totalProjectCount,
      completedProjectCount:
          completedProjectCount ?? this.completedProjectCount,
      totalTaskCount: totalTaskCount ?? this.totalTaskCount,
      completedTaskCount: completedTaskCount ?? this.completedTaskCount,
      totalWorkTime: totalWorkTime ?? this.totalWorkTime,
      workedTime: workedTime ?? this.workedTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatisticsLoadedState &&
        listEquals(other.topProjects, topProjects) &&
        other.totalProjectCount == totalProjectCount &&
        other.completedProjectCount == completedProjectCount &&
        other.totalTaskCount == totalTaskCount &&
        other.completedTaskCount == completedTaskCount &&
        other.totalWorkTime == totalWorkTime &&
        other.workedTime == workedTime;
  }

  @override
  int get hashCode {
    return topProjects.hashCode ^
        totalProjectCount.hashCode ^
        completedProjectCount.hashCode ^
        totalTaskCount.hashCode ^
        completedTaskCount.hashCode ^
        totalWorkTime.hashCode ^
        workedTime.hashCode;
  }
}
