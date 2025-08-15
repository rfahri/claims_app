import 'package:claims_app/core/errors/failure.dart';
import 'package:claims_app/features/claims/domain/entities/claim.dart';
import 'package:claims_app/features/claims/domain/repositories/claim_repository.dart';
import 'package:claims_app/features/claims/domain/usecase/claim_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'claim_model_test.mocks.dart';
@GenerateMocks([ClaimRepository])
void main() {
  late GetClaimsUseCase usecase;
  late MockClaimRepository mockRepository;

  setUp(() {
    mockRepository = MockClaimRepository();
    usecase = GetClaimsUseCase(mockRepository);
  });

  final tClaims = [Claim(userId: 1, id: 1, title: 'title', body: 'body')];

  test('should get claims from the repository', () async {
    when(mockRepository.getClaims()).thenAnswer((_) async => Right(tClaims));

    final result = await usecase();

    expect(result, Right(tClaims));
    verify(mockRepository.getClaims());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    final failure = ServerFailure('Error');
    when(mockRepository.getClaims()).thenAnswer((_) async => Left(failure));

    final result = await usecase();

    expect(result, Left(failure));
    verify(mockRepository.getClaims());
    verifyNoMoreInteractions(mockRepository);
  });
}