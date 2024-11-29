import 'package:presensi_battuta_app/app/module/entity/schedule.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';

abstract class ScheduleRepository {
  Future<DataState<ScheduleEntity?>> get();
  Future<DataState> banned();
}
