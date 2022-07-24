import 'package:bloc/bloc.dart';
import 'package:pomodoro_timer_task_management/routes/main_navigation.dart';

part 'tab_navigator_state.dart';

class TabNavigatorCubit extends Cubit<TabNavigatorState> {
  TabNavigatorCubit() : super(TabNavigatorState.initial());

  void navigate(String routeName) {
    emit(
      state.copyWith(
        tabIndex: _getTabIndex(routeName),
      ),
    );
  }

  int _getTabIndex(String routeName) {
    switch (routeName) {
      case MainNavigationRoutes.timer:
        return 0;
      case MainNavigationRoutes.projects:
        return 1;
      case MainNavigationRoutes.statistics:
        return 2;
      case MainNavigationRoutes.settings:
        return 3;
      default:
        Exception('Unknown route name: $routeName');
        return -1;
    }
  }
}
