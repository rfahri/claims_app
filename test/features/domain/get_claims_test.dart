import 'package:claims_app/core/errors/failure.dart';
import 'package:claims_app/features/claims/domain/entities/claim.dart';
import 'package:claims_app/features/claims/domain/usecase/claim_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../data/models/claim_model_test.mocks.dart';

void main() {
  late MockClaimRepository mockRepo;
  late GetClaimsUseCase usecase;

  setUp((){
    mockRepo = MockClaimRepository();
    usecase = GetClaimsUseCase(mockRepo);
  });

  test('returns claims on success', () async {
    final claims = [const Claim(userId:1,id:1,title:'t',body:'b')];
    when(mockRepo.getClaims()).thenAnswer((_) async => Right(claims));

    final res = await usecase();
    expect(res, Right(claims));
    verify(mockRepo.getClaims());
  });

  test('returns failure on error', () async {
    when(mockRepo.getClaims()).thenAnswer((_) async => Left(ServerFailure('err')));

    final res = await usecase();

    // cek Left dengan matcher
    expect(res.isLeft(), true);
    res.fold(
          (failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'err'); // cek pesan error
      },
          (_) => fail('Expected Left but got Right'),
    );
  });
}
