import 'package:presensi_battuta_app/core/constant/constant.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'photo_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class PhotoApiService {
  factory PhotoApiService(Dio dio) {
    return _PhotoApiService(dio);
  }

  @GET('/api/get-image')
  Future<HttpResponse<DataState>> get();

  @GET('{path}')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getBytes(
      {@Path('path') required String path});
}
