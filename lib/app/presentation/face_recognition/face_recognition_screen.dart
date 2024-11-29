import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:presensi_battuta_app/app/presentation/face_recognition/face_recognition_notifier.dart';
import 'package:presensi_battuta_app/app/presentation/map/map_screen.dart';
import 'package:presensi_battuta_app/core/helper/global_helper.dart';
import 'package:presensi_battuta_app/core/widget/app_widget.dart';

class FaceRecognitionScreen
    extends AppWidget<FaceRecognitionNotifier, void, void> {
  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.percentMatch >= 80) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(),
        ),
      ).then((result) {
        if (result == true) {
          Navigator.of(context).pop(true);
        }
      });
    }
  }

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text("Validasi Wajah"),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (notifier.currentImage != null)
              ? Image(
                  height: 150,
                  width: 150,
                  image: notifier.currentImage!.image,
                )
              : Icon(
                  Icons.no_photography,
                  size: 75,
                ),
          SizedBox(height: 50),
          (notifier.currentImage == null)
              ? Text(
                  "Gagal mengambil foto",
                  style: GlobalHelper.getTextStyle(context,
                      appTextStyle: AppTextStyle.headlineMedium),
                  textAlign: TextAlign.center,
                )
              : (notifier.percentMatch < 0.0)
                  ? Text(
                      "Sistem mendeteksi wajah anda tidak memiliki hak untuk membuat kehadiran",
                      style: GlobalHelper.getTextStyle(context,
                          appTextStyle: AppTextStyle.headlineSmall),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      "Tingkat kemiripan : ${notifier.percentMatch}%",
                      style: GlobalHelper.getTextStyle(context,
                          appTextStyle: AppTextStyle.headlineMedium),
                      textAlign: TextAlign.center,
                    ),
          SizedBox(height: 25),
          FilledButton(
            onPressed: _onPressOpenCamera,
            child: Text("Buka Kamera"),
          ),
        ],
      ),
    ));
  }

  _onPressOpenCamera() {
    notifier.getCurrentPhoto();
  }
}
