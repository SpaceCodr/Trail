import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/routes/main_navigation.dart';
import 'package:pomodoro_timer_task_management/routes/settings_navigation.dart';
import 'package:pomodoro_timer_task_management/views/screens/project/project_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/settings/settings_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/statistics/statistics_page.dart';
import 'package:pomodoro_timer_task_management/views/screens/timer/timer_page.dart';

final _tabController = CupertinoTabController();

class TabNavigator extends StatefulWidget {
  const TabNavigator({
    Key? key,
    this.tabIndex,
  }) : super(key: key);

  final int? tabIndex;

  static int _getTabIndex(String route) {
    switch (route) {
      case MainNavigationRoutes.timer:
        return 0;
      case MainNavigationRoutes.projects:
        return 1;
      case MainNavigationRoutes.statistics:
        return 2;
      case MainNavigationRoutes.settings:
        return 3;
      default:
        return -1;
    }
  }

  static void navigate(BuildContext context, String route) async {
    Navigator.of(context).pop();
    _tabController.index = _getTabIndex(route);
  }

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _timerPageKey = GlobalKey<NavigatorState>();
  final _projectsPageKey = GlobalKey<NavigatorState>();
  final _statisticsPageKey = GlobalKey<NavigatorState>();
  final _settingsPageKey = GlobalKey<NavigatorState>();

  int _tabIndex = 0;
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        currentIndex: _tabIndex,
        backgroundColor: Colors.black,
        // activeColor: CupertinoTheme.of(context).primaryColor,
        inactiveColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Text('Timer',style: TextStyle(color: Colors.blue,fontSize: 15,)),
            icon: Icon(Icons.access_time_rounded,),
          ),
          BottomNavigationBarItem(
            activeIcon: Text('Projects',style: TextStyle(color: Colors.purple,fontSize: 15),),
            icon: Icon(Icons.format_list_bulleted_rounded),
          ),
          BottomNavigationBarItem(
            activeIcon: Text('Statistics',style: TextStyle(color: Colors.pink,fontSize: 15),),
            icon: Icon(Icons.bar_chart_rounded),
          ),
          BottomNavigationBarItem(
            activeIcon: Text('Settings',style: TextStyle(color: Colors.blueGrey,fontSize: 15),),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              navigatorKey: _timerPageKey,
              builder: (context) => const TimerPage(),
              routes: MainNavigation.routes,
              onGenerateRoute: MainNavigation.generateRoute,
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: _projectsPageKey,
              builder: (context) => const ProjectsPage(),
              routes: MainNavigation.routes,
              onGenerateRoute: MainNavigation.generateRoute,
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: _statisticsPageKey,
              builder: (context) => const StatisticsPage(),
              onGenerateRoute: MainNavigation.generateRoute,
            );
          case 3:
            return CupertinoTabView(
              navigatorKey: _settingsPageKey,
              builder: (context) => const SettingsPage(),
              onGenerateRoute: SettingsNavigation.generateRoute,
            );
          default:
            return const Center(
              child: Text('Error'),
            );
        }
      },
    );
  }
}
