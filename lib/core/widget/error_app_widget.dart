import 'package:flutter/material.dart';
import 'package:presensi_battuta_app/core/helper/global_helper.dart';

class ErrorAppWidget extends StatelessWidget {
  final String description;
  final void Function() onPressDefaultButton;
  final FilledButton? alternativeButton;
  const ErrorAppWidget(
      {super.key,
      required this.description,
      required this.onPressDefaultButton,
      this.alternativeButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            style: GlobalHelper.getTextStyle(context,
                appTextStyle: AppTextStyle.headlineSmall),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          alternativeButton ??
              FilledButton.icon(
                  onPressed: onPressDefaultButton,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"))
        ],
      ),
    );
  }
}
