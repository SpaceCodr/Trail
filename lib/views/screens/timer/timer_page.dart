import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:TrailApp/components/popup_modal.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/core/values/keys.dart';
import 'package:TrailApp/cubit/task_work_logic/task_work_cubit.dart';
import 'package:TrailApp/cubit/timer_logic/timer_cubit.dart';
import 'package:TrailApp/cubit/timer_logic/timer_event.dart';
import 'package:TrailApp/models/task.dart';
import 'package:TrailApp/models/task_priority.dart';
import 'package:TrailApp/services/notification_service.dart';
import 'package:TrailApp/themes/timer_slider_themes.dart';
import 'package:TrailApp/views/widgets/action_button.dart';
import 'dart:io' show Platform;

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    final timerCubit = context.read<TimerCubit>();
    final taskWorkCubit = context.read<TaskWorkCubit>();
    final task = taskWorkCubit.state.task;


    if (task != null) {
      timerCubit.setPomodoroTimer(task.pomodoroTimer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child:Container(
          decoration: BoxDecoration(
            // color: Color(0xFF14162D),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF141640),Color(0xFF000000)]
            ),
            image: DecorationImage(
              image: AssetImage('assets/abg.jpg'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: _NotificationService(
            child: _Body(),
         ),
        ),
      ),
    );
  }
}

class _NotificationService extends StatefulWidget {
  const _NotificationService({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<_NotificationService> createState() => __NotificationServiceState();
}

class __NotificationServiceState extends State<_NotificationService> {
  final _notificationService = NotificationService.instance;

  String? _soundOfWorkEnd;
  String? _soundOfBreakEnd;

  @override
  void initState() {
    super.initState();
    _initBox();
    final cubit = context.read<TimerCubit>();
    cubit.timerStream.listen(_onTimerEvent);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _initBox() async {
    final box = await Hive.openBox<String?>(kNotificationSampleBox);
    _updateSounds();
    box.listenable().addListener(_updateSounds);
  }

  void _updateSounds() async {
    final box = await Hive.openBox<String?>(kNotificationSampleBox);
    _soundOfWorkEnd = box.get(kWorkEndKey);
    _soundOfBreakEnd = box.get(kBreakEndKey);
  }

  void _onTimerEvent(TimerEvent event) {
    final cubit = context.read<TimerCubit>();
    final state = cubit.state;

    if (Platform.isWindows) {
      return;
    }

    if (state.pomodoroTimer.notify == false) {
      return;
    }

    if (event is TimerCycleCompletedEvent) {
      _notificationService.showNotication(
        title: 'Pomodoro Timer',
        payload: event.mode.isWork
            ? 'Work cycle completed'
            : 'Break cycle completed',
        soundName: event.mode.isWork ? _soundOfWorkEnd : _soundOfBreakEnd,
      );
    } else if (event is TimerCompletedEvent) {
      _notificationService.showNotication(
        title: 'Pomodoro Timer',
        payload: 'Timer completed',
      );
    }
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:  [
        _TaskCardBody(),
        _TimerBody(),
        _TimerActionButton(),
        Padding(padding: EdgeInsets.all(140),child:Align(alignment: Alignment.topCenter,child: CupertinoButton(child: Icon(Icons.refresh_rounded,color: kOrangeColor,size: 40,),
          onPressed: () => Phoenix.rebirth(context),
        ))),
      ],
    );
  }
}

class _TaskCardBody extends StatelessWidget {
  const _TaskCardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = context.select((TaskWorkCubit cubit) => cubit.state.task);

    return task != null
        ? Positioned(
            top: kDefaultMargin,
            left: kDefaultMargin,
            right: kDefaultMargin,
            child: SizedBox(
              child: _TaskCard(task: task),
            ),
          )
        : const SizedBox();
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  void _openTimerStopModal(BuildContext context) async {
    final cubit = context.read<TimerCubit>();

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to stop timer?',
      onConiform: () {
        cubit.stop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: const EdgeInsets.all(kDefaultMargin / 2),
      color: Colors.white,
      borderRadius: BorderRadius.circular(kDefaultRadius),
      onPressed: () {},
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
            onPressed: () {},
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
                    Icons.play_circle_outline_rounded,
                    color: kIndigoColor,
                    size: 32,
                  ),
            onPressed: () => _openTimerStopModal(context),
          )
        ],
      ),
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
          color: color.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        child: child,
      ),
    );
  }
}

class _TimerBody extends StatelessWidget {
  const _TimerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _TimerSlider(),
          _TimerTitle(),
        ],
      ),
    );
  }
}

class _TimerSlider extends StatelessWidget {
  const _TimerSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerCubit>();
    final state = cubit.state;
    final value = state.currentDuration / state.duration;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 360,
        maxHeight: 360,
      ),
      child: Container(
        padding: const EdgeInsets.all(kDefaultMargin),
        child: getTimerWidget(
          color: Colors.white,
          value: 1 - value,
          widgetIndex: 0,//timerWidgetIndex,
        ),
      ),
    );
  }
}

class _TimerTitle extends StatelessWidget {
  const _TimerTitle({Key? key}) : super(key: key);

  String _numberFormat(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerCubit>();
    final state = cubit.state;

    final minutes = _numberFormat(state.currentDuration ~/ 60);
    final seconds = _numberFormat(state.currentDuration % 60);

    return Center(
      child: Text(
        '$minutes:$seconds',
        style: const TextStyle(
          fontSize: 85,
          color: Colors.black,
          fontFamily: 'Lato-Regular',
        ),
      ),
    );
  }
}

class _TimerActionButton extends StatelessWidget {
  const _TimerActionButton({Key? key}) : super(key: key);

  void _openTimerStopModal(BuildContext context) async {
    final cubit = context.read<TimerCubit>();

    cubit.pause();

    await showPopupModal(
      context: context,
      title: 'Are you sure you want to stop timer?',
      onCancel: cubit.resume,
      onConiform: cubit.stop,
    );
  }

  Widget _buildStartButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return ActionButton.withChildText(
      color: Colors.orange,
      context: context,
      title: 'Start',
      titleColor: Colors.white,
      onPressed: () => cubit.start(),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return Row(
      children: [
        Flexible(
          child: ActionButton.withChildText(
            color: Colors.orange.withOpacity(0.7),
            titleColor: Colors.white,
            context: context,
            title: 'Stop',
            onPressed: () => _openTimerStopModal(context),
          ),
        ),
        const SizedBox(width: kDefaultMargin),
        Flexible(
          child: ActionButton.withChildText(
            context: context,
            color: Colors.orange,
            titleColor: Colors.white,
            title: 'Pause',
            onPressed: () => cubit.pause(),
          ),
        ),
      ],
    );
  }

  Widget _buildSkipBreakButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return ActionButton.withChildText(
      context: context,
      title: 'Skip Break',
      onPressed: () => cubit.nextCycle(),
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    final cubit = context.read<TimerCubit>();

    return ActionButton.withChildText(
      color: Colors.orange,
      titleColor: Colors.white,
      context: context,
      title: 'Resume',
      onPressed: () => cubit.resume(),
    );
  }

  Widget _buildCrossFade(
      Widget firstChild, Widget secondChild, bool showFristChild) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState:
          showFristChild ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimerCubit>();
    final state = cubit.state;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(
          kDefaultMargin,
        ),
        child: _buildCrossFade(
          _buildStartButton(context),
          _buildCrossFade(
            _buildCrossFade(
              _buildToggleButton(context),
              _buildSkipBreakButton(context),
              state.mode.isWork,
            ),
            _buildResumeButton(context),
            state.status.isPaused == false,
          ),
          state.status.isStopped,
        ),
      ),
    );
  }
}
