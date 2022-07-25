import 'package:flutter/cupertino.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    this.color,
    required this.child,
    this.childAlignment,
    this.padding,
    this.margin,
  }) : super(key: key);

  final void Function()? onPressed;
  final Color? color;
  final Widget child;
  final Alignment? childAlignment;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  factory ActionButton.withChildText({
    Key? key,
    void Function()? onPressed,
    Color? color,
    required String title,
    Color? titleColor,
    Alignment? childAlignment,
    EdgeInsets? padding,
    EdgeInsets? margin,
    required BuildContext context,
  }) {
    return ActionButton(
      key: key,
      onPressed: onPressed,
      childAlignment: childAlignment,
      color: color,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Titlefont2',
          fontSize: 18,
          color: titleColor ?? kWhiteColor,
        ),
      ),
      margin: margin,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CupertinoButton(
          minSize: 0,
          color: color ?? CupertinoTheme.of(context).primaryColor,
          alignment: childAlignment ?? Alignment.center,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: kDefaultMargin / 2),
          onPressed: onPressed ?? () {},
          child: child,
        ),
      ),
    );
  }
}
