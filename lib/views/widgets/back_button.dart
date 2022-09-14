import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
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
        onPressed: Navigator.of(context).pop,
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: Colors.orange,
          size: 25,
        ),
      ),
    );
  }
}
