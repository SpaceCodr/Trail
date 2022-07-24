import 'package:bloc/bloc.dart';
import 'package:pomodoro_timer_task_management/models/pomodoro_timer.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/task_priority.dart';
import 'package:pomodoro_timer_task_management/services/task_service.dart';

part 'project_detail_form_state.dart';

class ProjectDetailFormCubit extends Cubit<ProjectDetailFormState> {
  final String boxName;
  final int projectKey;
  final Task? task;

  ProjectDetailFormCubit({
    required this.boxName,
    required this.projectKey,
    this.task,
  }) : super(ProjectDetailFormState.initial());

  late final TaskService _taskService;

  void init() async {
    if (task != null) {
      emit(
        state.copyWith(
          taskTitle: task!.title,
          pomodoroTimer: task!.pomodoroTimer,
          isEditing: true,
        ),
      );
    }

    _taskService = TaskService(
      boxName: boxName,
      projectKey: projectKey,
    );
    await _taskService.init();
  }

  void changeState(ProjectDetailFormState state) {
    emit(state);
  }

  Future<bool> trySaveTask() async {
    final newTask = task!.copyWith(
      title: state.taskTitle,
      priority: state.taskPriority,
      pomodoroTimer: state.pomodoroTimer,
    );

    return await _taskService.tryUpdateTask(task!, newTask);
  }

  Future<bool> tryAddTask() async {
    final task = Task(
      title: state.taskTitle,
      priority: state.taskPriority,
      pomodoroTimer: state.pomodoroTimer,
      workedTime: 0,
      workedInterval: 0,
      isDone: false,
      date: DateTime.now().toIso8601String(),
    );

    return await _taskService.tryAddTask(task);
  }

  Future<void> deleteTask() async {
    await _taskService.deleteTask(task!);
  }
}
