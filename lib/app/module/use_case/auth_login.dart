import 'package:presensi_battuta_app/app/module/entity/auth.dart';
import 'package:presensi_battuta_app/app/module/repository/auth_repository.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:presensi_battuta_app/core/use_case/app_use_case.dart';

class AuthLoginUseCase extends AppUseCase<Future<DataState>, AuthEntity> {
  final AuthRepository _authRepository;

  AuthLoginUseCase(this._authRepository);

  @override
  Future<DataState> call({AuthEntity? param}) {
    return _authRepository.login(param!);
  }
}
