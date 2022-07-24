import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';
import 'package:pomodoro_timer_task_management/cubit/settings_logic/settings_cubit.dart';
import 'package:pomodoro_timer_task_management/routes/settings_navigation.dart';
import 'package:pomodoro_timer_task_management/views/widgets/card_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/list_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rounded_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsCubit()..init(),
        ),
      ],
      child: CupertinoPageScaffold(
        backgroundColor: Color(0xFF14162D),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
            children: const [
              _Title(),
              _GeneralCard(),
              _AboutCardTitle(),
              _AboutCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTitle(title: 'Settings');
  }
}

class _GeneralCard extends StatelessWidget {
  const _GeneralCard({Key? key}) : super(key: key);

  void _changeNotificationState(BuildContext context, bool newValue) {
    final cubit = context.read<SettingsCubit>();
    final pomodoroTimer = cubit.state.pomodoroTimer;

    cubit.changePomodoroTimer(pomodoroTimer.copyWith(
      notify: newValue,
    ));
  }

  void _notificationSamplePickerPage(BuildContext context, String sampleKey) {
    Navigator.of(context).pushNamed(
      SettingsNavigationRoutes.notificationSamplePicker,
      arguments: {
        'sampleKey': sampleKey,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    const double itemHeight = 45;

    return RoundedCard(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: Column(
        children: [
          ListButton.withTrailingChevronIcon(
            iconData: CupertinoIcons.alarm,
            title: 'Timer settings',
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(SettingsNavigationRoutes.timerSettings);
            },
            height: itemHeight,
          ),
          ListButton.withTrailingChevronIcon(
            iconData: CupertinoIcons.music_note_2,
            title: 'Sound of break end',
            onPressed: () =>
                _notificationSamplePickerPage(context, kBreakEndKey),
            height: itemHeight,
          ),
          ListButton.withTrailingChevronIcon(
            iconData: CupertinoIcons.music_note_2,
            title: 'Sound of work end',
            onPressed: () =>
                _notificationSamplePickerPage(context, kWorkEndKey),
            height: itemHeight,
          ),
          ListButton.withTrailingSwitch(
            context: context,
            iconData: CupertinoIcons.bell,
            title: 'Notifications',
            value: cubit.state.pomodoroTimer.notify,
            onPressed: (value) {
              _changeNotificationState(context, value);
            },
            height: itemHeight,
          ),
        ],
      ),
    );
  }
}

class _AboutCardTitle extends StatelessWidget {
  const _AboutCardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CardTitle(title: 'About Us');
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const double itemHeight = 45;

    return RoundedCard(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: Column(
        children: [
          Row(
            children: [
              Text('Help and Feedback',
              style: TextStyle(fontFamily: 'Titlefont3',fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('umerbinshah2001@gmail.com',style: TextStyle(color: kBlueColor,fontFamily: 'Titlefont5',fontSize: 20),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text('Github',
                style: TextStyle(fontFamily: 'Titlefont3',fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text('https://github.com/SpaceCodr/TrailBloc/blob/master/README.md',style: TextStyle(color: kBlueColor,fontFamily: 'Titlefont5',fontSize: 20),),
          SizedBox(height: 10,),
          // ListButton.withTrailingChevronIcon(
          //   iconData: CupertinoIcons.circle_grid_hex_fill,
          //   title: 'Theme',
          //   onPressed: () {
          //     Navigator.of(context)
          //         .pushNamed(SettingsNavigationRoutes.themePicker);
          //   },
          //   height: itemHeight,
          // ),
          // ListButton.withTrailingChevronIcon(
          //   iconData: CupertinoIcons.alarm,
          //   title: 'Timer',
          //   onPressed: () {
          //     Navigator.of(context)
          //         .pushNamed(SettingsNavigationRoutes.timerThemePicker);
          //   },
          //   height: itemHeight,
          // ),
        ],
      ),
    );
  }
}
