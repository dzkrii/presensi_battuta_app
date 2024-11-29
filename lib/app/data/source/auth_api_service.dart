import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) {
    return _AuthApiService(dio);
  }

  @POST('/api/login')
  Future<HttpResponse<DataState>> login(
      {@Body() required Map<String, dynamic> body});
}
