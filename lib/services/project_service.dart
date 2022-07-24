import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';

class ProjectService {
  final String boxName;

  ProjectService({required this.boxName});

  late final Box<Project> _projectBox;

  Future<void> init() async {
    _projectBox = await Hive.openBox<Project>(boxName);
  }

  Future<bool> tryAddProject(Project project) async {
    if (_projectTitleIsContains(project)) {
      return false;
    }

    await _projectBox.add(project);

    return true;
  }

  Future<bool> tryUpadeProject(
      Project oldProject, Project newProject, int projectKey) async {
    if (_projectTitleIsContains(newProject) &&
        oldProject.title != newProject.title) {
      return false;
    }

    await _projectBox.put(projectKey, newProject);

    return true;
  }

  Future<void> deleteProject(int projectKey) async {
    await _projectBox.delete(projectKey);
  }

  bool _projectTitleIsContains(Project project) {
    return _projectBox.values.map((e) => e.title).contains(project.title);
  }
}
