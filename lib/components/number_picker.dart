import 'package:flutter/cupertino.dart';
import 'package:TrailApp/core/values/colors.dart';

Future<int> openNumberPickerDialog({
  required BuildContext context,
  required int minValue,
  required int value,
  required int maxValue,
}) async {
  int result = value;

  await showCupertinoDialog(
    context: context,
    builder: (_) => _NumberPicker(
      minValue: minValue,
      value: value,
      maxValue: maxValue,
      onValuePicked: (newValue) => result = newValue,
    ),
  );

  return result;
}

class _NumberPicker extends StatefulWidget {
  const _NumberPicker({
    Key? key,
    required this.minValue,
    required this.value,
    required this.maxValue,
    this.onValuePicked,
  }) : super(key: key);

  final int minValue;
  final int value;
  final int maxValue;
  final Function(int)? onValuePicked;

  @override
  State<_NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<_NumberPicker> {
  int _value = 0;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  void _changeValue(value) {
    setState(
      () => _value = value.clamp(
        widget.minValue,
        widget.maxValue,
      ),
    );
    widget.onValuePicked?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.center,
        color: kBGColor.withOpacity(0.5),
        child: SizedBox(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_value',
                    style: const TextStyle(
                      fontFamily: 'Papyrus',
                      fontSize: 55,
                      color: kTextColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Button(
                        onPressed: () => _changeValue(_value + 1),
                        title: '+',
                      ),
                      const SizedBox(width: 15),
                      _Button(
                        onPressed: () => _changeValue(_value - 1),
                        title: '-',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(8),
      color: kCardColor,
      borderRadius: BorderRadius.circular(4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Papyrus',
          fontSize: 20,
          color: kTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
