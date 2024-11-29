import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/presentation/detail_attendance/detail_attendance_screen.dart';
import 'package:presensi_battuta_app/app/presentation/face_recognition/face_recognition_screen.dart';
import 'package:presensi_battuta_app/app/presentation/home/home_notifier.dart';
import 'package:presensi_battuta_app/app/presentation/login/login_screen.dart';
import 'package:presensi_battuta_app/app/presentation/map/map_screen.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/helper/date_time_helper.dart';
import 'package:presensi_battuta_app/core/helper/dialog_helper.dart';
import 'package:presensi_battuta_app/core/helper/global_helper.dart';
import 'package:presensi_battuta_app/core/helper/shared_preferences_helper.dart';
import 'package:presensi_battuta_app/core/widget/app_widget.dart';

class HomeScreen extends AppWidget<HomeNotifier, void, void> {
  // @override
  // AppBar? appBarBuild(BuildContext context) {
  //   return AppBar(
  //     title: Text("Presensi Battuta"),
  //     actions: [
  //       Icon(Icons.edit_notifications),
  //       SizedBox(width: 15),
  //       IconButton(
  //           onPressed: () => _onPressLogout(context), icon: Icon(Icons.logout)),
  //       SizedBox(width: 15)
  //     ],
  //   );
  // }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => notifier.init(),
        child: Column(
          children: [
            _headerLayout(context),
            _todayLayout(context),
            Expanded(
              child: _thisMonthLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  _headerLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            // child: Icon(
            //   Icons.person,
            //   size: 35,
            // ),
            backgroundColor:
                GlobalHelper.getColorScheme(context).primaryContainer,
            radius: 30,
            child: (notifier.imageUrl != null)
                ? ClipOval(
                    child: Image.network(
                      '$baseUrl/storage/${notifier.imageUrl}',
                    ),
                  )
                : Icon(Icons.person),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notifier.name,
                  style: GlobalHelper.getTextStyle(context,
                          appTextStyle: AppTextStyle.titleLarge)
                      ?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 2,
                ),
                (notifier.isLeaves)
                    ? SizedBox()
                    : Row(
                        children: [
                          // Expanded(
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.location_city),
                          //       SizedBox(
                          //         width: 8,
                          //       ),
                          //       Text(
                          //         notifier.schedule.office.name,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.access_time),
                          //       SizedBox(
                          //         width: 2,
                          //       ),
                          //       Text(
                          //         '${notifier.schedule?.shift.startTime ?? ''} - ${notifier.schedule?.shift.endTime ?? ''}',
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          // IconButton(
          //     onPressed: () => _onPressEditNotification(context),
          //     icon: Icon(Icons.edit_notifications)),
          IconButton(
              onPressed: () => _onPressLogout(context),
              icon: Icon(Icons.logout)),
        ],
      ),
    );
  }

  _todayLayout(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: GlobalHelper.getColorScheme(context).primary),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: GlobalHelper.getColorScheme(context).onPrimary),
                child: Row(
                  children: [
                    Icon(Icons.today),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      DateTimeHelper.formatDateTime(
                          dateTime: DateTime.now(), format: "EEE, dd MMM yyyy"),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: GlobalHelper.getColorScheme(context).onPrimary),
              //   child: Text("WFO"),
              // ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              _timeTodayLayout(context,
                  notifier.attendanceToday?.startTime ?? '--:--:--', "Datang"),
              _timeTodayLayout(context,
                  notifier.attendanceToday?.endTime ?? '--:--:--', "Pulang"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          (notifier.isLeaves)
              ? Text(
                  "Anda sedang cuti",
                  style: GlobalHelper.getTextStyle(context,
                          appTextStyle: AppTextStyle.titleLarge)
                      ?.copyWith(
                          color: GlobalHelper.getColorScheme(context).onPrimary,
                          fontWeight: FontWeight.bold),
                )
              : Container(
                  width: double.maxFinite,
                  child: FilledButton(
                    onPressed: () => _onPressCreateAttendance(context),
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            GlobalHelper.getColorScheme(context).onPrimary,
                        foregroundColor:
                            GlobalHelper.getColorScheme(context).primary),
                    child: (notifier.attendanceToday?.startTime == null)
                        ? Text("Buat Presensi Datang")
                        : (notifier.attendanceToday?.endTime == null)
                            ? Text("Buat Presensi Pulang")
                            : Text("Update Presensi Pulang"),
                  ),
                ),
        ],
      ),
    );
  }

  _thisMonthLayout(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: GlobalHelper.getColorScheme(context).primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Riwayat Presensi",
                  style: GlobalHelper.getTextStyle(context,
                      appTextStyle: AppTextStyle.titleLarge),
                ),
              ),
              FilledButton(
                  onPressed: () => _onPressSeeAll(context),
                  child: Text("Lihat Semua"))
            ],
          ),
          SizedBox(height: 5),
          Container(
            height: 1,
            color: GlobalHelper.getColorScheme(context).primary,
          ),
          SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Tgl",
                    style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.titleSmall),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Datang",
                    style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.titleSmall),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Pulang",
                    style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.titleSmall),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Container(
            height: 2,
            color: GlobalHelper.getColorScheme(context).primary,
          ),
          SizedBox(height: 7),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                height: 1,
                color: GlobalHelper.getColorScheme(context).surface,
              ),
              itemCount: notifier.listAttendanceThisMonth.length,
              itemBuilder: (context, index) {
                final item = notifier.listAttendanceThisMonth[
                    notifier.listAttendanceThisMonth.length - index - 1];
                return _itemThisMonth(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  _timeTodayLayout(BuildContext context, String time, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            time,
            style: GlobalHelper.getTextStyle(context,
                    appTextStyle: AppTextStyle.headlineMedium)
                ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GlobalHelper.getColorScheme(context).onPrimary),
          ),
          Text(
            label,
            style: GlobalHelper.getTextStyle(context,
                    appTextStyle: AppTextStyle.bodyMedium)
                ?.copyWith(
                    color: GlobalHelper.getColorScheme(context).onPrimary),
          ),
        ],
      ),
    );
  }

  _itemThisMonth(BuildContext context, AttendanceEntity item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: GlobalHelper.getColorScheme(context).primary),
              child: Text(
                DateTimeHelper.formatDateTimeFromString(
                    dateTimeString: item.date!, format: 'dd\nMMM'),
                style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.labelLarge)
                    ?.copyWith(
                        color: GlobalHelper.getColorScheme(context).onPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                item.startTime,
                style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.bodyMedium)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ))),
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                item.endTime ?? '--:--:--',
                style: GlobalHelper.getTextStyle(context,
                        appTextStyle: AppTextStyle.bodyMedium)
                    ?.copyWith(fontWeight: FontWeight.bold),
              ))),
        ],
      ),
    );
  }

  _onPressCreateAttendance(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceRecognitionScreen(),
      ),
    );

    if (result == true) {
      notifier.init();
    }
  }

  _onPressEditNotification(BuildContext context) {
    DialogHelper.showBottomDialog(
      context: context,
      title: "Edit waktu notifikasi",
      content: DropdownMenu<int>(
        initialSelection: notifier.timeNotification,
        onSelected: (value) => _onSaveEditNotifcation(context, value!),
        dropdownMenuEntries: notifier.listEditNotification,
      ),
    );
  }

  _onPressLogout(BuildContext context) async {
    await SharedPreferencesHelper.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  _onPressSeeAll(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailAttendanceScreen(),
      ),
    );
  }

  _onSaveEditNotifcation(BuildContext context, int param) {
    Navigator.pop(context);
    notifier.saveNotificationSetting(param);
  }
}
