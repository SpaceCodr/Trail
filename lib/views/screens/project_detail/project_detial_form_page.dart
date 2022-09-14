import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TrailApp/components/number_picker.dart';
import 'package:TrailApp/components/popup_modal.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/cubit/project_detail_form_logic/project_detail_form_cubit.dart';
import 'package:TrailApp/models/pomodoro_timer.dart';
import 'package:TrailApp/models/task.dart';
import 'package:TrailApp/models/task_priority.dart';
import 'package:TrailApp/views/widgets/action_button.dart';
import 'package:TrailApp/views/widgets/back_button.dart';
import 'package:TrailApp/views/widgets/card_title.dart';
import 'package:TrailApp/views/widgets/list_button.dart';
import 'package:TrailApp/views/widgets/page_title.dart';
import 'package:TrailApp/views/widgets/rounded_card.dart';

class ProjectDetailFormPage extends StatelessWidget {
  const ProjectDetailFormPage({
    Key? key,
    required this.boxName,
    required this.projectKey,
    this.task,
  }) : super(key: key);

  final String boxName;
  final int projectKey;
  final Task? task;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectDetailFormCubit(
        boxName: boxName,
        projectKey: projectKey,
        task: task,
      )..init(),
      child: CupertinoPageScaffold(
        backgroundColor: const Color(0xFF14162D),
        child: SafeArea(
          child: ListView(
            children: const [
              _Header(),
              _Title(),
              _TaskNameField(),
              _TaskPriorityTitle(),
              _TaskPriorityPicker(),
              _TaskTimerSettingsTitle(),
              _TaskTimerSettings(),
              _TaskSettings(),
              _TaskActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Back_Button(),
          _DeleteButton(),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({Key? key}) : super(key: key);

  void _openDeleteTaskModal(BuildContext context) async {
    final cubit = context.read<ProjectDetailFormCubit>();

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to delete this task?',
      onConiform: () async {
        await cubit.deleteTask();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectDetailFormCubit>();

    return cubit.state.isEditing
        ? CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash_circle,
              color: Colors.redAccent,
              size: 25,
            ),
            onPressed: () => _openDeleteTaskModal(context),
          )
        : const SizedBox();
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectDetailFormCubit>();

    return PageTitle.withHorizontalMargin(
        title: cubit.state.isEditing ? cubit.state.taskTitle : 'New Task');
  }
}

class _TaskNameField extends StatelessWidget {
  const _TaskNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectDetailFormCubit>();
    final state = cubit.state;

    return RoundedCard.withHorizontalMargin(
      child: CupertinoTextField(
        padding: EdgeInsets.zero,
        placeholder: 'Task name',
        style: const TextStyle(
          fontFamily: 'Papyrus',
          fontSize: 18,
          color: kTextColor,
        ),
        placeholderStyle: const TextStyle(
          fontSize: 18,
          color: kGreyColor,
        ),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        controller: TextEditingController(text: state.taskTitle),
        onChanged: (value) {
          cubit.changeState(state.copyWith(taskTitle: value));
        },
      ),
    );
  }
}

class _TaskPriorityTitle extends StatelessWidget {
  const _TaskPriorityTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTitle.withHorizontalMargin(title: 'Priority');
  }
}

class _TaskPriorityPicker extends StatelessWidget {
  const _TaskPriorityPicker({Key? key}) : super(key: key);

  void _changePriority(BuildContext context, TaskPriority value) {
    final cubit = context.read<ProjectDetailFormCubit>();
    cubit.changeState(cubit.state.copyWith(taskPriority: value));
  }

  @override
  Widget build(BuildContext context) {
    final priority = context.watch<ProjectDetailFormCubit>().state.taskPriority;

    return RoundedCard.withHorizontalMargin(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PrioritySegment(
            title: 'High',
            color: kRedColor,
            isSelected: priority == TaskPriority.high,
            onPressed: () => _changePriority(context, TaskPriority.high),
          ),
          const SizedBox(width: 8),
          _PrioritySegment(
            title: 'Medium',
            color: kYellowColor,
            isSelected: priority == TaskPriority.medium,
            onPressed: () => _changePriority(context, TaskPriority.medium),
          ),
          const SizedBox(width: 8),
          _PrioritySegment(
            title: 'Low',
            color: kGreenColor,
            isSelected: priority == TaskPriority.low,
            onPressed: () => _changePriority(context, TaskPriority.low),
          ),
        ],
      ),
    );
  }
}

class _PrioritySegment extends StatelessWidget {
  const _PrioritySegment({
    Key? key,
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Color color;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? this.color : kGreyColor;

    return Flexible(
      child: GestureDetector(
        onTap: onPressed.call,
        child: Container(
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.5),
            border: Border.all(
              color: color,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskTimerSettingsTitle extends StatelessWidget {
  const _TaskTimerSettingsTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTitle.withHorizontalMargin(title: 'Settings');
  }
}

class _TaskTimerSettings extends StatelessWidget {
  const _TaskTimerSettings({Key? key}) : super(key: key);

  void _changePomodoroTimer(BuildContext context, PomodoroTimer value) {
    final cubit = context.read<ProjectDetailFormCubit>();
    cubit.changeState(cubit.state.copyWith(pomodoroTimer: value));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectDetailFormCubit>();
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
    final cubit = context.watch<ProjectDetailFormCubit>();
    final state = cubit.state;
    final pomodoroTimer = state.pomodoroTimer;

    return RoundedCard.withHorizontalMargin(
      child: Column(
        children: [
          ListButton.withTrailingSwitch(
            context: context,
            iconData: Icons.notifications_none_rounded,
            iconColor: kTextColor,
            title: 'Notifications',
            value: pomodoroTimer.notify,
            onPressed: (value) {
              cubit.changeState(
                state.copyWith(
                  pomodoroTimer: pomodoroTimer.copyWith(
                    notify: value,
                  ),
                ),
              );
            },
          ),
          ListButton.withTrailingSwitch(
            context: context,
            iconData: Icons.play_circle_outline_rounded,
            iconColor: kTextColor,
            title: 'Auto start',
            value: pomodoroTimer.autoStart,
            onPressed: (value) {
              cubit.changeState(
                state.copyWith(
                  pomodoroTimer: pomodoroTimer.copyWith(
                    autoStart: value,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TaskActionButton extends StatelessWidget {
  const _TaskActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectDetailFormCubit>();
    final isEditing = cubit.state.isEditing;
    final action = isEditing ? cubit.trySaveTask : cubit.tryAddTask;

    return ActionButton.withChildText(
      context: context,
      color: kOrangeColor,
      title: isEditing ? 'Save' : 'Add Task',
      margin: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin,
      ),
      onPressed: () async {
        final canBack = await action.call();

        if (canBack) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
    );
  }
}
