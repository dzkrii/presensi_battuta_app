import 'package:presensi_battuta_app/app/module/repository/photo_repository.dart';
import 'package:presensi_battuta_app/core/network/data_state.dart';
import 'package:presensi_battuta_app/core/use_case/app_use_case.dart';

class PhotoGetBytesUseCase
    extends AppUseCase<Future<DataState<dynamic>>, void> {
  final PhotoRepository _photoRepository;

  PhotoGetBytesUseCase(this._photoRepository);

  @override
  Future<DataState> call({void param}) async {
    final response = await _photoRepository.get();
    if (response.success) {
      final responseByte = await _photoRepository.getBytes(response.data!);
      return responseByte;
    } else {
      return response;
    }
  }
}
