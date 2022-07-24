part of 'project_form_cubit.dart';

class ProjectformState {
  final String projectTitle;
  final Color projectColor;
  final bool isEditMode;

  ProjectformState({
    required this.projectTitle,
    required this.projectColor,
    required this.isEditMode,
  });

  factory ProjectformState.initial() {
    return ProjectformState(
      projectTitle: '',
      projectColor: projectColors.first,
      isEditMode: false,
    );
  }

  ProjectformState copyWith({
    String? projectTitle,
    Color? projectColor,
    bool? isEditMode,
  }) {
    return ProjectformState(
      projectTitle: projectTitle ?? this.projectTitle,
      projectColor: projectColor ?? this.projectColor,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectformState &&
        other.projectTitle == projectTitle &&
        other.projectColor == projectColor &&
        other.isEditMode == isEditMode;
  }

  @override
  int get hashCode =>
      projectTitle.hashCode ^ projectColor.hashCode ^ isEditMode.hashCode;
}
