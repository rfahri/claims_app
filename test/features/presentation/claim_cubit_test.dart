import 'package:claims_app/core/errors/failure.dart';
import 'package:claims_app/features/claims/domain/entities/claim.dart';
import 'package:claims_app/features/claims/presentation/cubit/claim_cubit.dart';
import 'package:claims_app/features/claims/presentation/cubit/claim_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetClaimsUseCase mockGetClaims;
  late ClaimCubit cubit;

  setUp((){
    mockGetClaims = MockGetClaimsUseCase();
    cubit = ClaimCubit(mockGetClaims);
  });

  test('emits loading then loaded on success', () async {
    final data = [const Claim(userId:1,id:1,title:'t',body:'b')];
    when(mockGetClaims()).thenAnswer((_) async => Right(data));

    final expected = [isA<ClaimLoading>(), isA<ClaimLoaded>()];
    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.fetchClaims();
  });

  test('emits loading then error on failure', () async {
    when(mockGetClaims()).thenAnswer((_) async => Left(NetworkFailure('No internet')));

    final expected = [isA<ClaimLoading>(), isA<ClaimError>()];
    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.fetchClaims();
  });
}
