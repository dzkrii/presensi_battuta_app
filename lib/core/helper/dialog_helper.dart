import 'package:flutter/material.dart';
import 'package:presensi_battuta_app/core/helper/global_helper.dart';

class DialogHelper {
  static showSnackbar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static showBottomDialog(
      {required BuildContext context,
      required String title,
      required Widget content}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Container(
              width: double.maxFinite,
              child: Column(
                children: [
                  Text(
                    title,
                    style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.titleMedium),
                  ),
                  SizedBox(height: 20),
                  content
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
