import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/module/repository/attendance_repository.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:presensi_battuta_app/core/use_case/app_use_case.dart';

class AttendanceGetTodayUseCase
    extends AppUseCase<Future<DataState<AttendanceEntity?>>, void> {
  final AttendanceRepository _attendanceRepository;

  AttendanceGetTodayUseCase(this._attendanceRepository);

  @override
  Future<DataState<AttendanceEntity?>> call({void param}) {
    return _attendanceRepository.getToday();
  }
}
