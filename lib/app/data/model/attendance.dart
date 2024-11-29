import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_battuta_app/app/module/entity/attendance.dart';

part 'attendance.g.dart';
part 'attendance.freezed.dart';

@freezed
sealed class Attendance with _$Attendance {
  factory Attendance.model(
      {AttendanceEntity? today,
      @JsonKey(name: 'this_month')
      required List<AttendanceEntity> thisMonth}) = AttendanceModel;
  factory Attendance.fromJson(Map<String, Object> json) =>
      _$AttendanceFromJson(json);
}
