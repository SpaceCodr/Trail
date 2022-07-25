import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:TrailApp/core/values/keys.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/repositorys/project_repository.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectLoading());

  final ProjectRepository _projectRepository = ProjectRepository();

  void init() {
    _setupBox(kProjectBox);
    _setupBox(kMainProjectBox);
    loadProjects();
  }

  void loadProjects() async {
    emit(ProjectLoading());

    final projects = await _projectRepository.getProjects(kProjectBox);
    final mainProjects = await _projectRepository.getProjects(kMainProjectBox);

    emit(ProjectLoaded(projects: projects, mainProjects: mainProjects));
  }

  int? getCompletedTaskCount(Project project) {
    if (project.tasks == null) {
      return null;
    }

    int length =
        project.tasks!.where((element) => element.isDone == false).length;

    return length == 0 ? null : length;
  }

  void _setupBox(String boxName) async {
    final box = await Hive.openBox<Project>(boxName);
    box.listenable().addListener(loadProjects);
  }
}
