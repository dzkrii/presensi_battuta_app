import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/module/entity/schedule.dart';
import 'package:presensi_battuta_app/app/module/use_case/attendance_send.dart';
import 'package:presensi_battuta_app/app/module/use_case/schedule_banned.dart';
import 'package:presensi_battuta_app/app/module/use_case/schedule_get.dart';
import 'package:presensi_battuta_app/core/helper/location_helper.dart';
import 'package:presensi_battuta_app/core/provider/app_provider.dart';

class MapNotifier extends AppProvider {
  final ScheduleGetUseCase _scheduleGetUseCase;
  final AttendanceSendUseCase _attendanceSendUseCase;
  final ScheduleBannedUseCase _scheduleBannedUseCase;
  MapNotifier(this._scheduleGetUseCase, this._attendanceSendUseCase,
      this._scheduleBannedUseCase) {
    init();
  }

  bool _isSuccess = false;
  bool _isEnableSubmitButton = false;
  MapController _mapController = MapController.withPosition(
      initPosition:
          GeoPoint(latitude: 3.5969395920564, longitude: 98.665155172348));
  ScheduleEntity? _schedule;
  late CircleOSM _circle;
  bool _isGrantedLocation = false;
  bool _isEnabledLocation = false;
  // bool _isMockedLocation = false;
  late StreamSubscription<Position> _streamCurrentLocation;
  GeoPoint? _currentLocation;

  bool get isSuccess => _isSuccess;
  bool get isEnableSubmitButton => _isEnableSubmitButton;
  MapController get mapController => _mapController;
  ScheduleEntity? get schedule => _schedule;
  bool get isGrantedLocation => _isGrantedLocation;
  bool get isEnabledLocation => _isEnabledLocation;
  // bool get isMockedLocation => _isMockedLocation;

  @override
  void init() async {
    await _getEnableAndPermission();
    await _getSchedule();
  }

  _getEnableAndPermission() async {
    showLoading();
    _isGrantedLocation = await LocationHelper.isGrantedLocationPermission();
    if (_isGrantedLocation) {
      _isEnabledLocation = await LocationHelper.isEnabledLocationService();
      if (!_isEnabledLocation) {
        errorMessage = 'Mohon aktifkan lokasi terlebih dahulu';
      }
    } else {
      errorMessage = 'Mohon setujui izin lokasi';
    }
    hideLoading();
  }

  _getSchedule() async {
    showLoading();
    final response = await _scheduleGetUseCase();
    if (response.success) {
      _schedule = response.data!;
      _circle = CircleOSM(
          key: 'Center-Point',
          centerPoint: GeoPoint(
              latitude: _schedule!.office.latitude,
              longitude: _schedule!.office.longitude),
          radius: _schedule!.office.radius,
          color: Color(0x085e6b).withOpacity(0.5),
          strokeWidth: 2,
          borderColor: Color(0x085e6b));
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  checkLocationPermission() async {
    _isGrantedLocation = await LocationHelper.isGrantedLocationPermission();
    if (!_isGrantedLocation && !isDispose) {
      checkLocationPermission();
    } else {
      errorMessage = '';
      init();
    }
  }

  checkLocationService() async {
    _isEnabledLocation = await LocationHelper.isEnabledLocationService();
    if (!_isEnabledLocation && !isDispose) {
      checkLocationService();
    } else {
      errorMessage = '';
      init();
    }
  }

  mapIsReady() async {
    _openStreamCurrentLocation();
    await mapController.drawCircle(_circle);
  }

  _openStreamCurrentLocation() async {
    _streamCurrentLocation = Geolocator.getPositionStream().listen(
      (position) {
        if (position.isMocked) {
          // _isMockedLocation = true;
          // errorMessage = 'Perangkat anda terdeteksi menggunakan lokasi palsu';
          _closeStreamCurrentLocation();
          _sendBanned();
          // notifyListeners();
        } else {
          if (!isDispose) {
            if (_currentLocation != null)
              _mapController.removeMarker(_currentLocation!);
            _currentLocation = GeoPoint(
                latitude: position.latitude, longitude: position.longitude);
            _mapController.addMarker(_currentLocation!,
                markerIcon: MarkerIcon(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 30,
                  ),
                ));
            _mapController.moveTo(_currentLocation!, animate: true);
            _validationSubmitButton();
          } else {
            _closeStreamCurrentLocation();
          }
        }
      },
    );
  }

  _closeStreamCurrentLocation() {
    _streamCurrentLocation.cancel();
  }

  _validationSubmitButton() {
    final inCircle =
        LocationHelper.isLocationInCircle(_circle, _currentLocation!);
    if (inCircle != _isEnableSubmitButton) {
      _isEnableSubmitButton = inCircle;
      notifyListeners();
    }
  }

  send() async {
    showLoading();
    final response = await _attendanceSendUseCase(
        param: AttendanceParamEntity(
            latitude: _currentLocation!.latitude,
            longitude: _currentLocation!.longitude));
    if (response.success) {
      _isSuccess = true;
    } else {
      snackbarMessage = response.message;
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
}
