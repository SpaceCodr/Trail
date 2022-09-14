import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TrailApp/components/number_picker.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/cubit/settings_logic/settings_cubit.dart';
import 'package:TrailApp/models/pomodoro_timer.dart';
import 'package:TrailApp/views/widgets/back_button.dart';
import 'package:TrailApp/views/widgets/list_button.dart';
import 'package:TrailApp/views/widgets/page_title.dart';
import 'package:TrailApp/views/widgets/rounded_card.dart';

class PomodoroTimerSettingsPage extends StatelessWidget {
  const PomodoroTimerSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit()..init(),
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: const [
              _BackButton(),
              _Title(),
              _TaskTimerSettings(),
              _TaskSettings(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Back_Button(),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTitle.withHorizontalMargin(title: 'Timer Settings');
  }
}

class _TaskTimerSettings extends StatelessWidget {
  const _TaskTimerSettings({Key? key}) : super(key: key);

  void _changePomodoroTimer(BuildContext context, PomodoroTimer value) {
    final cubit = context.read<SettingsCubit>();
    cubit.changePomodoroTimer(value);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final pomodoroTimer = cubit.state.pomodoroTimer;

    return RoundedCard.withHorizontalMargin(
      child: Column(
        children: [
          Row(
            children: [
              _NumberPickerCard(
                title: 'Work',
                value: pomodoroTimer.workCycle,
                subTitle: 'Interval',
                onNumberPicked: (value) {
                  _changePomodoroTimer(
                      context, pomodoroTimer.copyWith(workCycle: value));
                },
              ),
              const SizedBox(width: kDefaultMargin),
              _NumberPickerCard(
                title: 'Work',
                value: pomodoroTimer.workTime,
                subTitle: 'Minutes',
                onNumberPicked: (value) {
                  _changePomodoroTimer(
                      context, pomodoroTimer.copyWith(workTime: value));
                },
              ),
            ],
          ),
          const SizedBox(height: kDefaultMargin),
          Row(
            children: [
              _NumberPickerCard(
                title: 'Long',
                value: pomodoroTimer.longInterval,
                subTitle: 'Interval',
                onNumberPicked: (value) {
                  _changePomodoroTimer(
                      context, pomodoroTimer.copyWith(longInterval: value));
                },
              ),
            ],
          ),
          const SizedBox(height: kDefaultMargin),
          Row(
            children: [
              _NumberPickerCard(
                title: 'Short',
                value: pomodoroTimer.shortBreakTime,
                subTitle: 'Minutes',
                onNumberPicked: (value) {
                  _changePomodoroTimer(
                      context, pomodoroTimer.copyWith(shortBreakTime: value));
                },
              ),
              const SizedBox(width: kDefaultMargin),
              _NumberPickerCard(
                title: 'Long',
                value: pomodoroTimer.longBreakTime,
                subTitle: 'Minutes',
                onNumberPicked: (value) {
                  _changePomodoroTimer(
                      context, pomodoroTimer.copyWith(longBreakTime: value));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberPickerCard extends StatelessWidget {
  const _NumberPickerCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subTitle,
    required this.onNumberPicked,
  }) : super(key: key);

  final String title;
  final int value;
  final String subTitle;
  final void Function(int) onNumberPicked;

  void _openNumberPickerModal(BuildContext context) async {
    int result = await openNumberPickerDialog(
      context: context,
      minValue: 1,
      value: value,
      maxValue: 60,
    );

    onNumberPicked.call(result);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoButton(
        color: kCardColor,
        padding: const EdgeInsets.all(kDefaultMargin / 2),
        borderRadius: BorderRadius.circular(kDefaultRadius),
        onPressed: () => _openNumberPickerModal(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Papyrus',
                fontSize: 18,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: kDefaultMargin),
            Text(
              '$value',
              style: const TextStyle(
                fontFamily: 'Papyrus',
                fontSize: 55,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subTitle,
              style: const TextStyle(
                fontFamily: 'Papyrus',
                fontSize: 16,
                color: kGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskSettings extends StatelessWidget {
  const _TaskSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final pomodoroTimer = cubit.state.pomodoroTimer;

    return RoundedCard.withHorizontalMargin(
      child: Column(
        children: [
          ListButton.withTrailingSwitch(
            context: context,
            iconData: CupertinoIcons.play_circle,
            iconColor: kTextColor,
            title: 'Auto start',
            value: pomodoroTimer.autoStart,
            height: 45,
            onPressed: (value) {
              cubit.changePomodoroTimer(
                  pomodoroTimer.copyWith(autoStart: value));
            },
          ),
        ],
      ),
    );
  }
}
