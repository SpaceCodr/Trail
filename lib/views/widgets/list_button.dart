import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';

class ListButton extends StatelessWidget {
  const ListButton({
    Key? key,
    required this.leading,
    required this.title,
    this.titleColor,
    required this.trailing,
    this.height,
    required this.onPressed,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final Color? titleColor;
  final Widget trailing;
  final double? height;
  final void Function() onPressed;

  factory ListButton.withLeadingIcon({
    Key? key,
    required IconData iconData,
    double? iconSize,
    Color? iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    double? height,
    required void Function() onPressed,
  }) {
    return ListButton(
      key: key,
      leading: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      title: title,
      titleColor: Colors.black,
      trailing: trailing ?? const SizedBox(),
      height: height,
      onPressed: onPressed,
    );
  }

  factory ListButton.withTrailingSwitch({
    Key? key,
    required IconData iconData,
    double? iconSize,
    Color? iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    double? height,
    required BuildContext context,
    required bool value,
    required void Function(bool) onPressed,
  }) {
    return ListButton(
      key: key,
      leading: Icon(
        iconData,
        size: iconSize,
        color: iconColor ?? kTextColor,
      ),
      title: title,
      titleColor: kTextColor,
      trailing: CupertinoSwitch(
        activeColor: kOrangeColor,
        value: value,
        onChanged: onPressed,
      ),
      height: height,
      onPressed: () => onPressed.call(!value),
    );
  }

  factory ListButton.withTrailingChevronIcon(
      {Key? key,
      required IconData iconData,
      double? iconSize,
      Color? iconColor,
      required String title,
      Color? titleColor,
      double? height,
      required Function() onPressed}) {
    return ListButton.withLeadingIcon(
      key: key,
      iconData: iconData,
      iconSize: iconSize,
      iconColor: iconColor ?? kTextColor,
      title: title,
      titleColor: titleColor,
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: kOrangeColor,
      ),
      height: height,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: kDefaultMargin / 2),
        onPressed: onPressed.call,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: kDefaultMargin / 2),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Titlefont3',
                  fontSize: 18,
                  color: titleColor ?? CupertinoColors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: kDefaultMargin / 2),
            trailing,
          ],
        ),
      ),
    );
  }
}
