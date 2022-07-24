import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/views/widgets/list_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rounded_card.dart';

Future<void> showBottomSheetModal({
  required BuildContext context,
}) async {
  /*
  await Navigator.of(context).push(
    CupertinoPageRoute(
      builder: (_) => const _BottomSheetModal(),
      fullscreenDialog: true,
    ),
  );
  */
  await showDialog(
    context: context,
    builder: (_) => const _BottomSheetModal(),
  );
}

class _BottomSheetModal extends StatefulWidget {
  const _BottomSheetModal({Key? key}) : super(key: key);

  @override
  State<_BottomSheetModal> createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<_BottomSheetModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));

    _animation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(_controller);
    _controller.animateBack(1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //_controller.animateTo(0);
        return true;
      },
      child: GestureDetector(
        onTap: () => _controller.animateTo(0),
        child: Container(
          color: kBGColor.withOpacity(0.5),
          child: SlideTransition(
            position: _animation,
            child: const _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RoundedCard(
          margin: const EdgeInsets.all(kDefaultMargin),
          child: Column(
            children: [
              ListButton.withLeadingIcon(
                iconData: CupertinoIcons.add,
                title: 'Add Task',
                onPressed: () {},
              ),
              ListButton.withLeadingIcon(
                iconData: CupertinoIcons.minus,
                title: 'Remove Tasks',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
