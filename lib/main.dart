import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_battuta_app/app/presentation/login/login_screen.dart';
import 'package:presensi_battuta_app/core/di/dependency.dart';
import 'package:presensi_battuta_app/core/helper/notification_helper.dart';
import 'package:presensi_battuta_app/core/widget/error_app_widget.dart';
import 'package:presensi_battuta_app/core/widget/loading_app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await initDependency();
  await NotificationHelper.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Color(0x085e6b)),
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
