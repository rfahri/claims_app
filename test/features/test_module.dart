import 'package:claims_app/features/claims/presentation/cubit/claim_cubit.dart';
import 'package:claims_app/features/claims/presentation/pages/claim_detail_page.dart';
import 'package:claims_app/features/claims/presentation/pages/claims_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../helpers/test_helper.mocks.dart';

class TestModule extends Module {
  final MockClaimCubit mockCubit;

  TestModule(this.mockCubit);

  @override
  void binds(Injector i) {
    i.addInstance<ClaimCubit>(mockCubit);
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
    r.child('/detail', child: (context) => ClaimDetailPage(claim: r.args.data));
  }
}
