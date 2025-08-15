
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';

import 'core/network/dio_client.dart';
import 'features/claims_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Registrasi DioClient
    i.addLazySingleton<DioClient>(() => DioClient());

    // Registrasi Dio langsung dari DioClient
    i.addLazySingleton<Dio>(() => i<DioClient>().dio);
  }

  @override
  void routes(RouteManager r) {
    r.module("/", module: ClaimsModule());
  }
}
