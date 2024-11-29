import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/module/entity/schedule.dart';
import 'package:presensi_battuta_app/app/module/use_case/attendance_get_this_month.dart';
import 'package:presensi_battuta_app/app/module/use_case/attendance_get_today.dart';
import 'package:presensi_battuta_app/app/module/use_case/schedule_banned.dart';
import 'package:presensi_battuta_app/app/module/use_case/schedule_get.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/helper/date_time_helper.dart';
import 'package:presensi_battuta_app/core/helper/notification_helper.dart';
import 'package:presensi_battuta_app/core/helper/shared_preferences_helper.dart';
import 'package:presensi_battuta_app/core/provider/app_provider.dart';

class HomeNotifier extends AppProvider {
  final AttendanceGetTodayUseCase _attendanceGetTodayUseCase;
  final AttendanceGetMonthUseCase _attendanceGetMonthUseCase;
  final ScheduleGetUseCase _scheduleGetUseCase;
  final ScheduleBannedUseCase _scheduleBannedUseCase;

  HomeNotifier(this._attendanceGetTodayUseCase, this._attendanceGetMonthUseCase,
      this._scheduleGetUseCase, this._scheduleBannedUseCase) {
    init();
  }

  int _timeNotification = 5;
  List<DropdownMenuEntry<int>> _listEditNotification = [
    DropdownMenuEntry<int>(value: 5, label: '5 Menit'),
    DropdownMenuEntry<int>(value: 10, label: '10 Menit'),
    DropdownMenuEntry<int>(value: 15, label: '15 Menit'),
  ];
  bool _isGrantedNotificationPermission = false;
  bool _isPhysicDevice = false;
  String _name = '';
  String? _imageUrl = '';
  AttendanceEntity? _attendanceToday;
  List<AttendanceEntity> _listAttendanceThisMonth = [];
  ScheduleEntity? _schedule;
  bool _isLeaves = false;

  int get timeNotification => _timeNotification;
  List<DropdownMenuEntry<int>> get listEditNotification =>
      _listEditNotification;
  bool get isGrantedNotificationPermission => _isGrantedNotificationPermission;
  bool get isPhysicDevice => _isPhysicDevice;
  String get name => _name;
  String? get imageUrl => _imageUrl;
  AttendanceEntity? get attendanceToday => _attendanceToday;
  List<AttendanceEntity> get listAttendanceThisMonth =>
      _listAttendanceThisMonth;
  ScheduleEntity? get schedule => _schedule;
  bool get isLeaves => _isLeaves;

  @override
  Future<void> init() async {
    await _getUserDetail();
    await _getDeviceInfo();
    await _getNotificationPermission();
    if (errorMessage.isEmpty) await _getAttendanceToday();
    if (errorMessage.isEmpty) await _getAttendanceThisMonth();
    if (errorMessage.isEmpty) await _getSchedule();
  }

  _getUserDetail() async {
    showLoading();
    _name = await SharedPreferencesHelper.getString(prefName);
    _imageUrl = await SharedPreferencesHelper.getString(prefUrlImage);
    print(_imageUrl);
    final pref_notif = await SharedPreferencesHelper.getInt(prefNotifSetting);
    if (pref_notif != null) {
      _timeNotification = pref_notif;
    } else {
      await SharedPreferencesHelper.setInt(prefNotifSetting, _timeNotification);
    }
    hideLoading();
  }

  _getDeviceInfo() async {
    showLoading();
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      _isPhysicDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iOSInfo = await DeviceInfoPlugin().iosInfo;
      _isPhysicDevice = iOSInfo.isPhysicalDevice;
    }
    if (!_isPhysicDevice) _sendBanned();
    hideLoading();
  }

  _getNotificationPermission() async {
    _isGrantedNotificationPermission =
        await NotificationHelper.isPermissionGranted();
    if (!_isGrantedNotificationPermission) {
      await NotificationHelper.requestPermission();
      await Future.delayed(Duration(seconds: 5));
      _getNotificationPermission();
    }
  }

  _getAttendanceToday() async {
    showLoading();
    final response = await _attendanceGetTodayUseCase();
    if (response.success) {
      _attendanceToday = response.data;
    } else {
      errorMessage = response.message;
    }

    hideLoading();
  }

  _getAttendanceThisMonth() async {
    showLoading();
    final response = await _attendanceGetMonthUseCase();
    if (response.success) {
      _listAttendanceThisMonth = response.data!;
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  _getSchedule() async {
    showLoading();
    _isLeaves = false;
    final response = await _scheduleGetUseCase();
    if (response.success) {
      if (response.data != null) {
        _schedule = response.data!;
        _setNotification();
      } else {
        _isLeaves = true;
        snackbarMessage = response.message;
      }
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  _sendBanned() async {
    showLoading();
    final response = await _scheduleBannedUseCase();
    if (response.success) {
      _getSchedule();
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  _setNotification() async {
    showLoading();

    await NotificationHelper.cancelAll();

    final startShift = await SharedPreferencesHelper.getString(prefStartShift);
    final endShift = await SharedPreferencesHelper.getString(prefEndShift);
    final prefTimeNotif =
        await SharedPreferencesHelper.getInt(prefNotifSetting);

    if (prefTimeNotif == null) {
      SharedPreferencesHelper.setInt(prefNotifSetting, _timeNotification);
    } else {
      _timeNotification = prefTimeNotif;
    }

    DateTime startShiftDateTime = DateTimeHelper.parseDateTime(
        dateTimeString: startShift, format: 'HH:mm:ss');
    DateTime endShiftDateTime = DateTimeHelper.parseDateTime(
        dateTimeString: endShift, format: 'HH:mm:ss');

    startShiftDateTime =
        startShiftDateTime.subtract(Duration(minutes: _timeNotification));
    endShiftDateTime =
        endShiftDateTime.subtract(Duration(minutes: _timeNotification));

    await NotificationHelper.scheduleNotification(
        id: 'start'.hashCode,
        title: 'Pengingat!',
        body: 'Jangan lupa untuk buat kehadiran datang',
        hour: startShiftDateTime.hour,
        minutes: startShiftDateTime.minute);
    await NotificationHelper.scheduleNotification(
        id: 'end'.hashCode,
        title: 'Pengingat!',
        body: 'Jangan lupa untuk buat kehadiran pulang',
        hour: endShiftDateTime.hour,
        minutes: endShiftDateTime.minute);
    hideLoading();
  }

  saveNotificationSetting(int param) async {
    showLoading();
    await SharedPreferencesHelper.setInt(prefNotifSetting, param);
    _timeNotification = param;
    _setNotification();
    hideLoading();
  }
}
