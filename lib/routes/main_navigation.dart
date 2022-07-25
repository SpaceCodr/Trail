import 'package:flutter/cupertino.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/models/task.dart';
import 'package:TrailApp/views/screens/project/project_form_page.dart';
import 'package:TrailApp/views/screens/project/project_page.dart';
import 'package:TrailApp/views/screens/project_detail/project_detail_page.dart';
import 'package:TrailApp/views/screens/project_detail/project_detial_form_page.dart';
import 'package:TrailApp/views/screens/settings/settings_page.dart';
import 'package:TrailApp/views/screens/statistics/statistics_page.dart';
import 'package:TrailApp/views/screens/timer/timer_page.dart';

abstract class MainNavigationRoutes {
  MainNavigationRoutes._();

  static const String timer = '/';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  static const String projects = '/projects';
  static const String projectForm = '/project/form';
  static const String projectDetail = '/projects/detail';
  static const String projectDetailForm = '/projects/detail/form';
}

abstract class MainNavigation {
  MainNavigation._();

  static const String initialRoute = MainNavigationRoutes.projects;

  static final routes = {
    MainNavigationRoutes.timer: (context) => const TimerPage(),
    MainNavigationRoutes.projects: (context) => const ProjectsPage(),
    MainNavigationRoutes.statistics: (context) => const StatisticsPage(),
    MainNavigationRoutes.settings: (context) => const SettingsPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRoutes.projects:
        return CupertinoPageRoute(
          builder: (_) => const ProjectsPage(),
        );
      case MainNavigationRoutes.projectForm:
        final boxName =
            (settings.arguments as Map<String, Object>)['boxName'] as String;
        final project =
            (settings.arguments as Map<String, Object>)['project'] as Project?;
        final projectKey =
            (settings.arguments as Map<String, Object>)['projectKey'] as int?;

        return CupertinoPageRoute(
          fullscreenDialog: project == null,
          builder: (_) => ProjectFormPage(
            boxName: boxName,
            project: project,
            projectKey: projectKey,
          ),
        );
      case MainNavigationRoutes.projectDetail:
        final boxName =
            (settings.arguments as Map<String, Object>)['boxName'] as String;
        final project =
            (settings.arguments as Map<String, Object>)['project'] as Project;
        final projectKey =
            (settings.arguments as Map<String, Object>)['projectKey'] as int;

        return CupertinoPageRoute(
          builder: (_) => ProjectDetailPage(
            boxName: boxName,
            project: project,
            projectKey: projectKey,
          ),
        );
      case MainNavigationRoutes.projectDetailForm:
        final boxName =
            (settings.arguments as Map<String, Object>)['boxName'] as String;
        final projectKey =
            (settings.arguments as Map<String, Object>)['projectKey'] as int;
        final task =
            (settings.arguments as Map<String, Object>)['task'] as Task?;

        return CupertinoPageRoute(
          fullscreenDialog: task == null,
          builder: (_) => ProjectDetailFormPage(
            boxName: boxName,
            projectKey: projectKey,
            task: task,
          ),
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => CupertinoPageScaffold(
            child: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
