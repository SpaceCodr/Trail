import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/components/popup_modal.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/core/values/keys.dart';
import 'package:pomodoro_timer_task_management/cubit/project_detail_logic/project_detail_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/task_work_logic/task_work_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/task_priority.dart';
import 'package:pomodoro_timer_task_management/models/timer_task.dart';
import 'package:pomodoro_timer_task_management/routes/main_navigation.dart';
import 'package:pomodoro_timer_task_management/views/screens/tab_navigator/tab_navigator.dart';
import 'package:pomodoro_timer_task_management/views/widgets/action_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/back_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/card_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rounded_card.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({
    Key? key,
    required this.boxName,
    required this.project,
    required this.projectKey,
  }) : super(key: key);

  final String boxName;
  final Project project;
  final int projectKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectDetailCubit>(
      create: (_) => ProjectDetailCubit(
        boxName: boxName,
        project: project,
        projectKey: projectKey,
      )..init(),
      child: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
        builder: (context, state) {
          return CupertinoPageScaffold(
            backgroundColor: Color(0xFF14162D),
            child: SafeArea(
              child: state is ProjectDetailLoadedState
                  ? const _Body()
                  : const _Loading(),
            ),
          );
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectDetailCubit>();
    final state = cubit.state as ProjectDetailLoadedState;
    final tasksIsEmpty = state.tasks.isEmpty;

    return tasksIsEmpty ? const _EmptyBody() : const _TasksBody();
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        shrinkWrap: true,
        children: const [
          _Header(),
          _Title(),
        ],
      ),
      const _TaskAddButton(),
    ]);
  }
}

class _TasksBody extends StatelessWidget {
  const _TasksBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        shrinkWrap: true,
        children: const [
          _Header(),
          _Title(),
          _ProjectInformation(),
          _TaskList(),
          _CompletedTaskList(),
        ],
      ),
      const _TaskAddButton(),
    ]);
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Back_Button(),
          _MoreButton(),
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({Key? key}) : super(key: key);

  void _openProjectEditPage(BuildContext context) async {
    final cubit = context.read<ProjectDetailCubit>();

    await Navigator.of(context).pushNamed(
      MainNavigationRoutes.projectForm,
      arguments: {
        'boxName': cubit.boxName,
        'project': cubit.project,
        'projectKey': cubit.projectKey,
      },
    );
    cubit.updateProject();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectDetailCubit>();

    return cubit.boxName == kMainProjectBox
        ? const SizedBox()
        : CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            child: const Icon(
              Icons.build_circle_outlined,
              color: kGreenColor,
              size: 25,
            ),
            onPressed: () => _openProjectEditPage(context),
          );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectDetailCubit>();
    final state = cubit.state as ProjectDetailLoadedState;
    return PageTitle.withHorizontalMargin(title: state.projectTitle);
  }
}

class _ProjectInformation extends StatelessWidget {
  const _ProjectInformation({Key? key}) : super(key: key);

  String _numberFormat(double number) {
    return number.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectDetailCubit>();
    final state = cubit.state as ProjectDetailLoadedState;

    final fristCard = _TaskStatisticsCard(
      fristTitle: _numberFormat(state.totalWorkTime),
      fristSubTitle: 'Work time(h)',
      secondTitle: state.totalTaskCount.toString(),
      secondSubTitle: 'All tasks in project',
    );

    final secondCard = _TaskStatisticsCard(
      fristTitle: _numberFormat(state.workedTime/60),
      fristSubTitle: 'Worked time(h)',
      secondTitle: state.completedTaskCount.toString(),
      secondSubTitle: 'Completed tasks',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: IntrinsicHeight(
        child: MediaQuery.of(context).size.width < 700
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    fristCard,
                    const SizedBox(width: kDefaultMargin),
                    secondCard,
                  ],
                ),
              )
            : Row(
                children: [
                  Flexible(child: fristCard),
                  const SizedBox(width: kDefaultMargin),
                  Flexible(child: secondCard),
                ],
              ),
      ),
    );
  }
}

class _TaskStatisticsCard extends StatelessWidget {
  const _TaskStatisticsCard({
    Key? key,
    required this.fristTitle,
    required this.fristSubTitle,
    required this.secondTitle,
    required this.secondSubTitle,
  }) : super(key: key);

  final String fristTitle;
  final String fristSubTitle;
  final String secondTitle;
  final String secondSubTitle;

  Widget _buildTitle({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 25,
          color: kTextColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSubTitle({required String text}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 100,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: kGreyColor,
        ),
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 1,
      color: kGreyColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: AssetImage('assets/full-bloom.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(text: fristTitle),
              _buildSubTitle(text: fristSubTitle),
            ],
          ),
          _buildVerticalLine(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(text: secondTitle),
              _buildSubTitle(text: secondSubTitle),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectDetailCubit>();
    final state = cubit.state as ProjectDetailLoadedState;
    final tasks = state.tasks.where((e) => e.isDone == false).toList();

    return tasks.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle.withHorizontalMargin(title: 'Tasks'),
              ...List.generate(
                tasks.length,
                (index) => _TaskCard(task: tasks[index]),
              ),
            ],
          );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  bool _taskIsWorking(BuildContext context) {
    final cubit = context.read<ProjectDetailCubit>();
    final taskWorkCubit = context.read<TaskWorkCubit>();

    final timerTask = TimerTask(
      boxName: cubit.boxName,
      projectKey: cubit.projectKey,
      task: task,
    );

    return taskWorkCubit.isEqual(timerTask);
  }

  void _openTaskDeleteModal(BuildContext context) async {
    final cubit = context.read<ProjectDetailCubit>();

    if (_taskIsWorking(context)) {
      _openTimerStopModal(context);
    }

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to delete this task?',
      onConiform: () {
        cubit.deleteTask(task);
        Navigator.of(context).pop();
      },
    );
  }

  void _openTimerStopModal(BuildContext context) async {
    final cubit = context.read<TimerCubit>();

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to stop timer?',
      onConiform: () async {
        cubit.stop();
      },
    );
  }

  void _openTaskDetailPage(BuildContext context) async {
    final cubit = context.read<ProjectDetailCubit>();

    if (_taskIsWorking(context)) {
      _openTimerStopModal(context);
      return;
    }

    await Navigator.of(context).pushNamed(
      MainNavigationRoutes.projectDetailForm,
      arguments: {
        'boxName': cubit.boxName,
        'projectKey': cubit.projectKey,
        'task': task,
      },
    );

    cubit.updateProject();
  }

  void _openTimerPage(BuildContext context) async {
    final cubit = context.read<ProjectDetailCubit>();
    final taskWorkCubit = context.read<TaskWorkCubit>();

    final timerTask = TimerTask(
      boxName: cubit.boxName,
      projectKey: cubit.projectKey,
      task: task,
    );

    final result = await taskWorkCubit.trySetTimerTask(timerTask);

    if (result) {
      TabNavigator.navigate(context, MainNavigationRoutes.timer);
    } else {
      _openTimerStopModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin * 0.9,
      ),
      child: CupertinoButton(
        minSize: 0,
        padding: const EdgeInsets.all(kDefaultMargin / 2),
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        onPressed: () => _openTaskDetailPage(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CircleBordered(
              color: task.priority.color,
              child: task.isDone == true
                  ? const Icon(
                      Icons.check,
                      color: kTextColor,
                      size: 16,
                    )
                  : null,
              onPressed: () =>
                  context.read<ProjectDetailCubit>().toggleTask(task),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontFamily: 'Titlefont3',
                          fontSize: 18,
                          color: kTextColor,
                        ),
                      ),
                      Text(
                        '${task.workedInterval ?? 0}/${task.pomodoroTimer.workCycle}',
                        style: const TextStyle(
                          fontFamily: 'Titlefont3',
                          fontSize: 18,
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultMargin / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${((task.workedTime ?? 0)/60).toInt()} minute',
                        style: const TextStyle(
                          fontFamily: 'Titlefont3',
                          fontSize: 18,
                          color: kGreyColor,
                        ),
                      ),
                      Text(
                        '${task.pomodoroTimer.workTime} min',
                        style: const TextStyle(
                          fontFamily: 'Titlefont3',
                          fontSize: 18,
                          color: kGreyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              child: task.isDone == true
                  ? const Icon(
                      CupertinoIcons.trash_circle,
                      color: kRedColor,
                      size: 32,
                    )
                  : const Icon(
                      CupertinoIcons.play_circle,
                      color: kIndigoColor,
                      size: 32,
                    ),
              onPressed: () => task.isDone == true
                  ? _openTaskDeleteModal(context)
                  : _openTimerPage(context),
            )
          ],
        ),
      ),
    );
  }
}

class _CompletedTaskList extends StatelessWidget {
  const _CompletedTaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectDetailCubit>();
    final state = cubit.state as ProjectDetailLoadedState;
    final tasks = state.tasks.where((e) => e.isDone == true).toList();

    return tasks.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle.withHorizontalMargin(title: 'Completed Tasks'),
              ...List.generate(
                tasks.length,
                (index) => _TaskCard(task: tasks[index]),
              ),
            ],
          );
  }
}

class _CircleBordered extends StatelessWidget {
  const _CircleBordered({
    Key? key,
    required this.color,
    this.child,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final Widget? child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed.call,
      child: Container(
        width: 25,
        height: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: child,
      ),
    );
  }
}

class _TaskAddButton extends StatelessWidget {
  const _TaskAddButton({Key? key}) : super(key: key);

  void _openTaskFormPage(BuildContext context) async {
    final cubit = context.read<ProjectDetailCubit>();

    await Navigator.of(context).pushNamed(
      MainNavigationRoutes.projectDetailForm,
      arguments: {
        'boxName': cubit.boxName,
        'projectKey': cubit.projectKey,
      },
    );

    cubit.updateProject();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultMargin),
        child: ActionButton.withChildText(
          color: kOrangeColor,
          context: context,
          title: 'Add Task',
          onPressed: () => _openTaskFormPage(context),
        ),
      ),
    );
  }
}
