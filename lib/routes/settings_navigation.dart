import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/views/screens/settings/notification_sample_picker_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/settings/pomodoro_timer_settings_page.dart';

abstract class SettingsNavigationRoutes {
  SettingsNavigationRoutes._();

  static const String timerSettings = 'timer_settings';
  static const String themePicker = 'theme_picker';
  static const String notificationSamplePicker = 'notification_sample_picker';
}

abstract class SettingsNavigation {
  SettingsNavigation._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SettingsNavigationRoutes.timerSettings:
        return CupertinoPageRoute(
          builder: (_) => const PomodoroTimerSettingsPage(),
        );
      case SettingsNavigationRoutes.notificationSamplePicker:
        final sampleKey =
            (settings.arguments as Map<String, Object>)['sampleKey'] as String;

        return CupertinoPageRoute(
          builder: (_) => NotificationSamplePickerPage(sampleKey: sampleKey),
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        );
    }
  }
}
