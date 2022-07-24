part of 'tab_navigator_cubit.dart';

class TabNavigatorState {
  final int tabIndex;

  TabNavigatorState({
    required this.tabIndex,
  });

  factory TabNavigatorState.initial() {
    return TabNavigatorState(
      tabIndex: 0,
    );
  }

  TabNavigatorState copyWith({
    int? tabIndex,
  }) {
    return TabNavigatorState(
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TabNavigatorState && other.tabIndex == tabIndex;
  }

  @override
  int get hashCode => tabIndex.hashCode;
}
