import 'package:presensi_battuta_app/app/module/entity/auth.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';

abstract class AuthRepository {
  Future<DataState> login(AuthEntity param);
}
