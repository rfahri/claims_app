import 'package:claims_app/features/claims/data/data_sources/claims_data_sources.dart';
import 'package:claims_app/features/claims/domain/repositories/claim_repository.dart';
import 'package:claims_app/features/claims/domain/usecase/claim_usecase.dart';
import 'package:claims_app/features/claims/presentation/cubit/claim_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_modular/flutter_modular.dart';

@GenerateMocks([
  ClaimRepository,
  GetClaimsUseCase,
  RemoteDataSource,
  ClaimCubit,
  IModularNavigator
])
void main() {}
