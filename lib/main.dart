import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/core/hive_adapters.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pomodoro_timer_task_management/core/hive_default_data.dart';
import 'package:pomodoro_timer_task_management/cubit/task_work_logic/task_work_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';
import 'package:pomodoro_timer_task_management/services/notification_service.dart';
import 'package:pomodoro_timer_task_management/views/screens/tab_navigator/tab_navigator.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  registerAllHiveApadters();
  await insertDefaultData();
  await NotificationService.instance.init();
  FlutterNativeSplash.remove();
  runApp(Phoenix(child:StartApp()));
}

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TimerCubit>(
          create: (_) => TimerCubit()..init(),
        ),
        BlocProvider<TaskWorkCubit>(
          create: (_) => TaskWorkCubit()..init(),
        ),
      ],
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();

    final timerCubit = context.read<TimerCubit>();
    final taskWorkCubit = context.read<TaskWorkCubit>();

    taskWorkCubit.lisenStream(timerCubit.timerStream);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(

      title: kAppName,
      theme: null,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: AnimatedSplashScreen(
        splashIconSize: 500,
        backgroundColor: const Color(0xfffaa026),
        splash: 'assets/sand-clock.gif',
        nextScreen: const TabNavigator(),
        splashTransition: SplashTransition.rotationTransition,
        duration: 3000,
      ),
      //const TabNavigator(),
    );
  }
}
