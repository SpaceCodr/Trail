// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:TrailApp/core/extensions/color.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/services/project_service.dart';

part 'project_form_state.dart';

class ProjectformCubit extends Cubit<ProjectformState> {
  final String boxName;
  final Project? project;
  final int? projectKey;

  ProjectformCubit({
    required this.boxName,
    this.project,
    this.projectKey,
  }) : super(ProjectformState.initial()) {
    _init();
  }

  late final ProjectService _projectService;

  void _init() async {
    if (project != null && projectKey != null) {
      emit(
        state.copyWith(
          projectTitle: project!.title,
          projectColor: HexColor.fromHex(project!.color),
          isEditMode: true,
        ),
      );
    }

    _projectService = ProjectService(
      boxName: boxName,
    );
    await _projectService.init();
  }

  void changeState(ProjectformState state) {
    emit(state);
  }

  Future<bool> tryUpdateProject() async {
    Project newProject = project!.copyWith(
      title: state.projectTitle,
      color: state.projectColor.toHex(),
    );

    return await _projectService.tryUpadeProject(
        project!, newProject, projectKey!);
  }

  Future<bool> tryAddProject() async {
    Project project = Project(
      title: state.projectTitle,
      color: state.projectColor.toHex(),
      date: DateTime.now().toIso8601String(),
    );

    return await _projectService.tryAddProject(project);
  }

  Future<void> deleteProject() async {
    await _projectService.deleteProject(projectKey!);
  }
}
