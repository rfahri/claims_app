import 'package:claims_app/features/claims/data/data_sources/claims_data_sources.dart';
import 'package:claims_app/features/claims/data/repository/claims_repository.dart';
import 'package:claims_app/features/claims/domain/repositories/claim_repository.dart';
import 'package:claims_app/features/claims/domain/usecase/claim_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../app_module.dart';
import 'claims/presentation/cubit/claim_cubit.dart';
import 'claims/presentation/pages/claim_detail_page.dart';
import 'claims/presentation/pages/claims_page.dart';

class ClaimsModule extends Module {

  @override
  List<Module> get imports => [AppModule()];

  @override
  void binds(Injector i) {
    // DataSource
    i.addLazySingleton<RemoteDataSourceImpl>(
      () => RemoteDataSourceImpl(i<Dio>()),
    );

    // Repository
    i.addLazySingleton<ClaimRepository>(
      () => ClaimRepositoryImpl(i<RemoteDataSource>()),
    );

    // Use case
    i.addLazySingleton<GetClaimsUseCase>(
      () => GetClaimsUseCase(i<ClaimRepository>()),

    );

    // Cubit
    i.addSingleton<ClaimCubit>(() => ClaimCubit(i<GetClaimsUseCase>()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => BlocProvider(
        create: (_) => Modular.get<ClaimCubit>(),
        child: const ClaimPage(),
      ),
    );
    r.child('/detail',
        child: (context) => ClaimDetailPage(
          claim: r.args.data
        ));
  }
}
