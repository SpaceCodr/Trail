part of 'project_cubit.dart';

abstract class ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;
  final List<Project> mainProjects;

  ProjectLoaded({
    required this.projects,
    required this.mainProjects,
  });
}

class ProjectLoading extends ProjectState {}
