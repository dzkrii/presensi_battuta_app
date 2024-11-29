import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/app/module/repository/attendance_repository.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:presensi_battuta_app/core/use_case/app_use_case.dart';

class AttendanceGetByMonthAndYear extends AppUseCase<
    Future<DataState<List<AttendanceEntity>>>, AttendanceParamGetEntity> {
  final AttendanceRepository _attendanceRepository;

  AttendanceGetByMonthAndYear(this._attendanceRepository);

  @override
  Future<DataState<List<AttendanceEntity>>> call(
      {AttendanceParamGetEntity? param}) {
    return _attendanceRepository.getByMonthAndYear(param!);
  }
}
