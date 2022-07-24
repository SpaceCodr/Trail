import 'package:flutter/cupertino.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';

const _defaultTextTheme = CupertinoTextThemeData(
  primaryColor: kTextColor,
  textStyle: TextStyle(color: kTextColor, fontFamily: 'Montserrat'),
);

const _defaultTheme = CupertinoThemeData(
  primaryColor: kTextColor,
  scaffoldBackgroundColor: kBGColor,
  textTheme: _defaultTextTheme,
);

final indigoTheme = _defaultTheme.copyWith(
  primaryColor: kIndigoColor,
  primaryContrastingColor: kGreenColor,
  textTheme: _defaultTextTheme.copyWith(
    actionTextStyle: const TextStyle(color: kTextColor),
  ),
);

final lightMoonTheme = _defaultTheme.copyWith(
  primaryColor: const Color.fromARGB(255, 232, 232, 233),
  primaryContrastingColor: const Color.fromARGB(255, 39, 39, 39),
  textTheme: _defaultTextTheme.copyWith(
    actionTextStyle: const TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
  ),
);

final appThemes = [indigoTheme, lightMoonTheme];
