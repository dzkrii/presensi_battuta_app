import 'package:dio/dio.dart';
import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:retrofit/retrofit.dart';

part 'schedule_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class ScheduleApiService {
  factory ScheduleApiService(Dio dio) {
    return _ScheduleApiService(dio);
  }

  @GET('/api/get-schedule')
  Future<HttpResponse<DataState>> get();

  @POST('/api/banned')
  Future<HttpResponse<DataState>> banned();
}
