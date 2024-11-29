import 'dart:io';

import 'package:presensi_battuta_app/app/data/source/photo_api_service.dart';
import 'package:presensi_battuta_app/app/module/repository/photo_repository.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/helper/shared_preferences_helper.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';

class PhotoRepositoryImpl extends PhotoRepository {
  final PhotoApiService _photoApiService;

  PhotoRepositoryImpl(this._photoApiService);

  @override
  Future<DataState<String>> get() {
    return handleResponse(
      () => _photoApiService.get(),
      (p0) => p0,
      // (json) {
      //   if (json != null) {
      //     SharedPreferencesHelper.setString(prefUrlImage, value)
      //   }
      // }
    );
  }

  @override
  Future<DataState> getBytes(String url) async {
    final response =
        await _photoApiService.getBytes(path: url.replaceAll(baseUrl, ''));
    if (response.response.statusCode == HttpStatus.ok) {
      return SuccessState(data: response.response.data);
    } else {
      return ErrorState(
          message:
              '${response.response.statusCode} : ${response.response.statusMessage}');
    }
  }
}
