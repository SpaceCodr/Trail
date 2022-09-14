import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.decoration,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;

  factory RoundedCard.withHorizontalMargin({
    Key? key,
    required Widget child,
  }) {
    return RoundedCard(
      key: key,
      margin: const EdgeInsets.only(
        left: kDefaultMargin,
        right: kDefaultMargin,
        bottom: kDefaultMargin * 1.2,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(kDefaultMargin),
      margin: margin ?? const EdgeInsets.only(bottom: kDefaultMargin * 1.2),
      decoration: decoration ?? BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: child,
    );
  }
}
