import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/models/task.dart';
import 'package:TrailApp/repositorys/project_repository.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsLoadingState());

  StatisticsType _statisticsType = StatisticsType.all;
  StatisticsType get statisticsType => _statisticsType;

  late final ProjectRepository _repository;

  void init() {
    _repository = ProjectRepository();
    fetchStatistics();
  }

  void fetchStatistics() async {
    emit(StatisticsLoadingState());

    final projects = await _repository.getAllProjects();
    final tasks = _repository.getAllTasks(projects);
    final selectedTasks = _getSelectedList<Task>(tasks);
    final selectedProject = _getSelectedList<Project>(projects);

    updateStatistics(selectedTasks, selectedProject);
  }

  void updateStatistics(List<Task> task, List<Project> projects) {
    final completedProjectCount = projects.fold<int>(
        0, (sum, project) => sum + (_projectIsDone(project) ? 1 : 0));
    final completedTaskCount =
        task.fold<int>(0, (sum, task) => sum + (task.isDone! ? 1 : 0));
    final totalWorkTime =
        task.fold<int>(0, (sum, task) => sum + task.pomodoroTimer.workTime*task.pomodoroTimer.workCycle) /
            60;
    print(totalWorkTime);
    final workedTime =
        task.fold<int>(0, (sum, task) => sum + (task.workedTime ?? 0)) / 60;

    emit(
      StatisticsLoadedState(
        topProjects: _getTop10Projects(projects),
        totalProjectCount: projects.length,
        completedProjectCount: completedProjectCount,
        totalTaskCount: task.length,
        completedTaskCount: completedTaskCount,
        totalWorkTime: totalWorkTime,
        workedTime: workedTime,
      ),
    );
  }

  void changeStatisticsType(StatisticsType statisticsType) {
    _statisticsType = statisticsType;
    fetchStatistics();
  }

  double getProjectWorkedTime(Project project) {
    final tasks = project.tasks;

    if (tasks == null) {
      return 0;
    }

    return tasks.fold<int>(0, (sum, task) => sum + ((task.workedTime ?? 0)/60).toInt() )/ 60;
  }

  int getProjectCompletedTaskCount(Project project) {
    final tasks = project.tasks;

    if (tasks == null) {
      return 0;
    }

    return tasks.fold<int>(0, (sum, task) => sum + (task.isDone! ? 1 : 0));
  }

  List<Project> _getTop10Projects(List<Project> projects) {
    final sortedProjects = projects.toList()
      ..sort(
          (a, b) => getProjectWorkedTime(b).compareTo(getProjectWorkedTime(a)));
    return sortedProjects.take(10).toList();
  }

  bool _isDateInRange(String data) {
    final now = DateTime.now();
    int days = 0;

    if (_statisticsType == StatisticsType.all) {
      return true;
    } else if (_statisticsType == StatisticsType.week) {
      days = 7;
    } else {
      days = 30;
    }

    now.subtract(Duration(days: days));
    return DateTime.parse(data).isBefore(now);
  }

  List<T> _getSelectedList<T>(List<T> list) {
    if (_statisticsType == StatisticsType.all) {
      return list;
    } else if (_statisticsType == StatisticsType.week) {
      return list
          .where((e) => _isDateInRange((e as dynamic).date as String))
          .toList();
    } else {
      return list
          .where((e) => _isDateInRange((e as dynamic).date as String))
          .toList();
    }
  }

  bool _projectIsDone(Project project) {
    if (project.tasks == null) {
      return false;
    }

    var tasks = project.tasks!;

    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].isDone == false) {
        return false;
      }
    }

    return true;
  }
}
