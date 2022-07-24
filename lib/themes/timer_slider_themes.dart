import 'package:flutter/material.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

abstract class _TimerSliderWidget extends StatelessWidget {
  const _TimerSliderWidget({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context);
}

class _TimerSliderTheme1 extends _TimerSliderWidget {
  const _TimerSliderTheme1({
    Key? key,
    required double value,
    required Color color,
  }) : super(
          key: key,
          value: value,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 1,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 15,
            color: color.withOpacity(0.5),
          ),
          pointers: [
            MarkerPointer(
              value: 0,
              markerWidth: 15,
              markerHeight: 15,
              markerType: MarkerType.circle,
              color: color,
            ),
            RangePointer(
              value: value,
              width: 15,
              color: color,
              enableAnimation: true,
              animationType: AnimationType.linear,
            ),
            MarkerPointer(
              value: value,
              markerWidth: 15,
              markerHeight: 15,
              markerType: MarkerType.circle,
              enableAnimation: true,
              animationType: AnimationType.linear,
              color: color,
            ),
          ],
        )
      ],
    );
  }
}

class _TimerSliderTheme2 extends _TimerSliderWidget {
  const _TimerSliderTheme2({
    Key? key,
    required double value,
    required Color color,
  }) : super(
          key: key,
          value: value,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 1,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 15,
            color: color.withOpacity(0.2),
          ),
          pointers: List.generate(
            18,
            (index) => MarkerPointer(
              value: (index + 1) / 18,
              markerWidth: 10,
              markerHeight: 10,
              markerType: MarkerType.circle,
              color: value > (index + 1) / 18 ? color : color.withOpacity(0.2),
            ),
          ),
        )
      ],
    );
  }
}

class _TimerSliderTheme3 extends _TimerSliderWidget {
  const _TimerSliderTheme3({
    Key? key,
    required double value,
    required Color color,
  }) : super(
          key: key,
          value: value,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 1,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0,
            color: Colors.transparent,
          ),
          pointers: List.generate(
            18,
            (index) => MarkerPointer(
              value: (index + 1) / 18,
              markerWidth: 10,
              markerHeight: 10,
              markerType: MarkerType.circle,
              color: value > (index + 1) / 18 ? color : color.withOpacity(0.2),
            ),
          ),
        )
      ],
    );
  }
}

class _TimerSliderTheme4 extends _TimerSliderWidget {
  const _TimerSliderTheme4({
    Key? key,
    required double value,
    required Color color,
  }) : super(
          key: key,
          value: value,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 1,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 20,
            color: Color.fromARGB(255, 41, 41, 41),
          ),
          pointers: [
            MarkerPointer(
              value: 0,
              markerWidth: 20,
              markerHeight: 20,
              markerType: MarkerType.circle,
              color: color,
            ),
            RangePointer(
              value: value,
              width: 20,
              color: color,
              animationType: AnimationType.linear,
              enableAnimation: true,
            ),
            MarkerPointer(
              value: value,
              markerWidth: 20,
              markerHeight: 20,
              markerType: MarkerType.circle,
              animationType: AnimationType.linear,
              enableAnimation: true,
              color: color,
            ),
            MarkerPointer(
              value: value,
              markerWidth: 12,
              markerHeight: 12,
              markerType: MarkerType.circle,
              animationType: AnimationType.linear,
              enableAnimation: true,
              color: kTextColor,
            ),
          ],
        )
      ],
    );
  }
}

Widget getTimerWidget(
    {Key? key,
    required Color color,
    required double value,
    required int widgetIndex}) {
  switch (widgetIndex) {
    case 0:
      return _TimerSliderTheme1(key: key, color: color, value: value);
    case 1:
      return _TimerSliderTheme2(key: key, color: color, value: value);
    case 2:
      return _TimerSliderTheme3(key: key, color: color, value: value);
    case 3:
      return _TimerSliderTheme4(key: key, color: color, value: value);
    default:
      return Container();
  }
}
