import 'package:presensi_battuta_app/app/module/entity/attendance.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';

abstract class AttendanceRepository {
  Future<DataState<AttendanceEntity?>> getToday();
  Future<DataState<List<AttendanceEntity>>> getThisMonth();
  Future<DataState> sendAttendance(AttendanceParamEntity param);
  Future<DataState<List<AttendanceEntity>>> getByMonthAndYear(
      AttendanceParamGetEntity param);
}
