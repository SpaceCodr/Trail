import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key? key,
    required this.title,
    this.padding,
  }) : super(key: key);

  final String title;
  final EdgeInsets? padding;

  factory PageTitle.withHorizontalMargin({
    Key? key,
    required String title,
  }) {
    return PageTitle(
      key: key,
      title: title,
      padding: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        top: kDefaultMargin,
        bottom: kDefaultMargin * 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.only(
            top: kDefaultMargin,
            bottom: kDefaultMargin * 1.5,
          ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: 'Titlefont1',
          fontWeight: FontWeight.w800,
          color: Colors.orange,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
