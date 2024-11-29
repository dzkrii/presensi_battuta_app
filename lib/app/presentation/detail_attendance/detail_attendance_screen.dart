import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/presentation/detail_attendance/detail_attendance_notifier.dart';
import 'package:presensi_battuta_app/core/helper/date_time_helper.dart';
import 'package:presensi_battuta_app/core/helper/global_helper.dart';
import 'package:presensi_battuta_app/core/widget/app_widget.dart';

class DetailAttendanceScreen
    extends AppWidget<DetailAttendanceNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text("Riwayat Kehadiran"),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownMenu<int>(
                    expandedInsets: EdgeInsets.symmetric(horizontal: 1),
                    label: Text("Bulan"),
                    dropdownMenuEntries: notifier.monthListDropdown,
                    initialSelection: 1,
                    controller: notifier.monthController,
                  ),
                ),
                Expanded(
                  child: DropdownMenu<int>(
                    expandedInsets: EdgeInsets.symmetric(horizontal: 1),
                    label: Text("Tahun"),
                    dropdownMenuEntries: notifier.yearListDropdown,
                    initialSelection: 2024,
                    controller: notifier.yearController,
                  ),
                ),
                IconButton(onPressed: _onPressSearch, icon: Icon(Icons.search)),
              ],
            ),
            SizedBox(height: 20),
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
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                // physics: ClampingScrollPhysics(),
                separatorBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  height: 1,
                  color: GlobalHelper.getColorScheme(context).surface,
                ),
                itemCount: notifier.listAttendance.length,
                itemBuilder: (context, index) {
                  final item = notifier.listAttendance[
                      notifier.listAttendance.length - index - 1];
                  return _itemThisMonth(context, item);
                },
              ),
            ),
          ],
        ),
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

  _onPressSearch() {
    notifier.search();
  }
}
