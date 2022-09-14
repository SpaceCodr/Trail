import 'package:flutter/material.dart';
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



Widget getTimerWidget(
    {Key? key,
    required Color color,
    required double value,
    required int widgetIndex}) {
  switch (widgetIndex) {
    case 0:
      return _TimerSliderTheme1(key: key, color: color, value: value);
    default:
      return Container();
  }
}
