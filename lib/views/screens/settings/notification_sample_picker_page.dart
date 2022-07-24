import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/cubit/notification_sample_picker_logic/notification_sample_picker_cubit.dart';
import 'package:pomodoro_timer_task_management/views/widgets/back_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/list_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rounded_card.dart';

class NotificationSamplePickerPage extends StatelessWidget {
  const NotificationSamplePickerPage({
    Key? key,
    required this.sampleKey,
  }) : super(key: key);

  final String sampleKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationSamplePickerCubit>(
      create: (_) =>
          NotificationSamplePickerCubit(sampleKey: sampleKey)..init(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final cubit = context.read<NotificationSamplePickerCubit>();

        await cubit.saveSample();

        return false;
      },
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: const [
              _BackButton(),
              _Title(),
              _SampleList(),
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
    return PageTitle.withHorizontalMargin(title: 'Notification Sample');
  }
}

class _SampleList extends StatelessWidget {
  const _SampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NotificationSamplePickerCubit>();
    final state = cubit.state;

    return RoundedCard.withHorizontalMargin(
      child: Column(
        children: [
          _Button(
            iconData: CupertinoIcons.multiply_circle,
            title: 'Without Sound',
            isSelected: state.selectedSampleIndex == null,
            onPressed: () => cubit.changeSeletectedSampleIndex(null),
          ),
          ...List.generate(
            state.sampleNames.length,
            (index) => _Button(
              iconData: CupertinoIcons.music_note_2,
              title: state.sampleNames[index],
              isSelected: state.selectedSampleIndex == index,
              onPressed: () => cubit.changeSeletectedSampleIndex(index),
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.iconData,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListButton.withLeadingIcon(
      iconData: iconData,
      title: title,
      trailing: isSelected ? const Icon(CupertinoIcons.checkmark_alt) : null,
      onPressed: onPressed,
    );
  }
}
