import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/views/widgets/action_button.dart';

Future<void> showPopupModal({
  required BuildContext context,
  required String title,
  void Function()? onCancel,
  void Function()? onConiform,
}) async {
  await showCupertinoDialog(
    context: context,
    builder: (_) => _PopupModal(
      title: title,
      onCancel: onCancel,
      onConiform: onConiform,
    ),
  );
}

class _PopupModal extends StatelessWidget {
  const _PopupModal({
    Key? key,
    required this.title,
    this.onCancel,
    this.onConiform,
  }) : super(key: key);

  final String title;
  final void Function()? onCancel;
  final void Function()? onConiform;

  void _cancel(BuildContext context) {
    onCancel?.call();
    Navigator.of(context).pop();
  }

  void _coniform(BuildContext context) {
    onConiform?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return GestureDetector(
      onTap: () => _cancel(context),
      child: Container(
        padding: const EdgeInsets.all(kDefaultMargin),
        color: kBGColor.withOpacity(0.5),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(kDefaultMargin),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: kDefaultMargin),
              Row(
                children: [
                  Flexible(
                    child: ActionButton.withChildText(
                      context: context,
                      color: color.withOpacity(0.3),
                      title: 'No',
                      titleColor: color,
                      onPressed: () => _cancel(context),
                    ),
                  ),
                  const SizedBox(width: kDefaultMargin),
                  Flexible(
                    child: ActionButton.withChildText(
                      color: color,
                      titleColor: kOrangeColor,
                      context: context,
                      title: 'Yes',
                      onPressed: () => _coniform(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
