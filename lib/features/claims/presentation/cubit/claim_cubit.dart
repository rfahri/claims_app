import 'package:claims_app/features/claims/domain/usecase/claim_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/claim.dart';
import 'claim_state.dart';

class ClaimCubit extends Cubit<ClaimState> {
  final GetClaimsUseCase getClaims;
  ClaimCubit(this.getClaims) : super(ClaimInitial());

  Future<void> fetchClaims() async {
    emit(ClaimLoading());
    final Either<Failure, List<Claim>> result = await getClaims();
    result.fold(
      (failure) => emit(ClaimError(failure.message)),
      (claims) => emit(ClaimLoaded(claims)),
    );
  }
}
