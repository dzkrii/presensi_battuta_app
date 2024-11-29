import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/module/repository/attendance_repository.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:presensi_battuta_app/core/use_case/app_use_case.dart';

class AttendanceSendUseCase
    extends AppUseCase<Future<DataState>, AttendanceParamEntity> {
  final AttendanceRepository _attendanceRepository;

  AttendanceSendUseCase(this._attendanceRepository);

  @override
  Future<DataState> call({AttendanceParamEntity? param}) {
    return _attendanceRepository.sendAttendance(param!);
  }
}
