import 'package:dio/dio.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:retrofit/retrofit.dart';

part 'attendance_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class AttendanceApiService {
  factory AttendanceApiService(Dio dio) {
    return _AttendanceApiService(dio);
  }

  @GET('/api/get-attendance-today')
  Future<HttpResponse<DataState>> getAttendanceToday();

  @POST('/api/store-attendance')
  Future<HttpResponse<DataState>> sendAttendance(
      {@Body() required Map<String, dynamic> body});

  @GET('/api/get-attendance-by-month-and-year/{month}/{year}')
  Future<HttpResponse<DataState>> getAttendanceByMonthAndYear(
      {@Path('month') required String month,
      @Path('year') required String year});
}
