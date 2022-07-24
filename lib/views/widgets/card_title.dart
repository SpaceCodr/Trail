import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';

class CardTitle extends StatelessWidget {
  const CardTitle({
    Key? key,
    required this.title,
    this.trailing,
    this.margin,
  }) : super(key: key);

  final String title;
  final Widget? trailing;
  final EdgeInsets? margin;

  factory CardTitle.withHorizontalMargin({
    Key? key,
    required String title,
    Widget? trailing,
  }) {
    return CardTitle(
      key: key,
      title: title,
      trailing: trailing,
      margin: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin * 0.9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          const EdgeInsets.only(
            bottom: kDefaultMargin * 0.9,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Titlefont1',
              color: Colors.orange,
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}
