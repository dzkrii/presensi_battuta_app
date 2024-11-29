import 'package:presensi_battuta_app/app/data/model/auth.dart';
import 'package:presensi_battuta_app/app/data/source/auth_api_service.dart';
import 'package:presensi_battuta_app/app/module/entity/auth.dart';
import 'package:presensi_battuta_app/app/module/repository/auth_repository.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/helper/shared_preferences_helper.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<DataState> login(AuthEntity param) {
    return handleResponse(
      () => _authApiService.login(body: param.toJson()),
      (json) async {
        final authModel = AuthModel.fromJson(json);
        await SharedPreferencesHelper.setString(
            prefAuth, '${authModel.tokenType} ${authModel.accessToken}');
        await SharedPreferencesHelper.setInt(prefId, authModel.user.id);
        await SharedPreferencesHelper.setString(prefName, authModel.user.name);
        await SharedPreferencesHelper.setString(
            prefEmail, authModel.user.email);

        // Menyimpan URL gambar ke SharedPreferences
        if (authModel.user.image != null) {
          await SharedPreferencesHelper.setString(
              prefUrlImage, authModel.user.image!);
        }
        return null;
      },
    );
  }
}
