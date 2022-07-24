import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';

class Back_Button extends StatelessWidget {
  const Back_Button({
    Key? key,
    this.margin,
  }) : super(key: key);

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          const EdgeInsets.only(
            left: 8,
            top: 10,
          ),
      child: CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: Colors.orange,
          size: 25,
        ),
        onPressed: Navigator.of(context).pop,
      ),
    );
  }
}
