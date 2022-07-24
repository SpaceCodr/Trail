import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';

class TaskService {
  final String boxName;
  final int projectKey;
  final void Function()? onUpdated;

  TaskService({
    required this.boxName,
    required this.projectKey,
    this.onUpdated,
  });

  late final Box<Project> _projectBox;

  Future<void> init() async {
    _projectBox = await Hive.openBox<Project>(boxName);
  }

  Future<bool> tryUpdateTask(Task oldTask, Task newTask) async {
    if (oldTask.title != newTask.title && _taskTitleIsContains(newTask)) {
      return false;
    }

    final tasks = getTasks();
    final index = tasks.indexOf(oldTask);

    tasks.removeAt(index);
    tasks.insert(index, newTask);

    await _updateTasks(tasks);

    return true;
  }

  Future<bool> tryAddTask(Task task) async {
    if (_taskTitleIsContains(task)) {
      return false;
    }

    final tasks = getTasks();
    tasks.add(task);

    await _updateTasks(tasks);

    return true;
  }

  Future<void> deleteTask(Task task) async {
    final tasks = getTasks();

    tasks.remove(task);

    await _updateTasks(tasks);
  }

  List<Task> getTasks() {
    final project = _projectBox.get(projectKey)!;
    return project.tasks ?? [];
  }

  bool _taskTitleIsContains(Task title) {
    final tasks = getTasks();
    return tasks.map((e) => e.title).contains(title.title);
  }

  Future<void> _updateTasks(List<Task> tasks) async {
    final project = _projectBox.get(projectKey)!;
    await _projectBox.put(projectKey, project.copyWith(tasks: tasks));
    onUpdated?.call();
  }
}
