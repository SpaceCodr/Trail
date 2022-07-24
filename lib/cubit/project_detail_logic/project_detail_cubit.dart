import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/services/task_service.dart';

part 'project_detail_state.dart';

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  final String boxName;
  Project project;
  final int projectKey;

  ProjectDetailCubit({
    required this.boxName,
    required this.project,
    required this.projectKey,
  }) : super(ProjectDetailLoading());

  late final Box<Project> _projectBox;
  late final TaskService _taskService;

  void init() async {
    emit(ProjectDetailLoading());

    _projectBox = await Hive.openBox<Project>(boxName);
    _projectBox.listenable().addListener(updateProject);

    _taskService = TaskService(
      boxName: boxName,
      projectKey: projectKey,
      onUpdated: updateState,
    );
    await _taskService.init();

    updateState();
  }

  void updateState() {
    final tasks = _taskService.getTasks();

    final projectTitle = project.title;
    final totalWorkTime =
        tasks.fold<int>(0, (sum, task) => sum + task.pomodoroTimer.workTime*task.pomodoroTimer.workCycle) /
            60;
    print(totalWorkTime);
    final workedTime =
        tasks.fold<int>(0, (sum, task) => sum + (task.workedTime ?? 0)) / 60;
    final completedTaskCount =
        tasks.fold<int>(0, (sum, task) => sum + (task.isDone! ? 1 : 0));
    final totalTaskCount = tasks.length;

    emit(
      ProjectDetailLoadedState(
        projectTitle: projectTitle,
        tasks: tasks,
        totalTaskCount: totalTaskCount,
        completedTaskCount: completedTaskCount,
        workedTime: workedTime,
        totalWorkTime: totalWorkTime,
      ),
    );
  }

  void deleteTask(Task task) async {
    await _taskService.deleteTask(task);
  }

  void toggleTask(Task task) async {
    final oldTask = task;
    final newTask = task.copyWith(
      isDone: !task.isDone!,
    );

    await _taskService.tryUpdateTask(oldTask, newTask);
  }

  void updateProject() {
    final newProject = _projectBox.get(projectKey);
    if (newProject == null) {
      return;
    }

    project = newProject;
    updateState();
  }

  @override
  Future<void> close() async {
    await super.close();
    _projectBox.listenable().removeListener(updateProject);
  }
}
