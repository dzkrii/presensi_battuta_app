import 'package:flutter/material.dart';
import 'package:presensi_battuta_app/app/module/entity/auth.dart';
import 'package:presensi_battuta_app/app/module/use_case/auth_login.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/helper/shared_preferences_helper.dart';
import 'package:presensi_battuta_app/core/provider/app_provider.dart';

class LoginNotifier extends AppProvider {
  final AuthLoginUseCase _authLoginUseCase;

  LoginNotifier(this._authLoginUseCase) {
    init();
  }

  bool _isLoged = false;
  bool _isShowPassword = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool get isLoged => _isLoged;
  bool get isShowPassword => _isShowPassword;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  set isShowPassword(bool param) {
    _isShowPassword = param;
    notifyListeners();
  }

  @override
  void init() {
    _checkAuth();
  }

  _checkAuth() async {
    showLoading();
    final String? auth = await SharedPreferencesHelper.getString(prefAuth);
    if (auth?.isNotEmpty ?? false) _isLoged = true;
    hideLoading();
  }

  login() async {
    showLoading();
    final param = AuthEntity(
        email: _emailController.text, password: _passwordController.text);
    final response = await _authLoginUseCase(param: param);
    if (response.success) {
    } else {
      snackbarMessage = response.message;
    }
    _checkAuth();
    hideLoading();
  }
}
