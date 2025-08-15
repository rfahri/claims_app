import 'package:claims_app/core/errors/failure.dart';
import 'package:claims_app/features/claims/data/models/claim_model.dart';
import 'package:claims_app/features/claims/data/repository/claims_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockRemoteDataSource mockDataSource;
  late ClaimRepositoryImpl repo;

  setUp((){
    mockDataSource = MockRemoteDataSource();
    repo = ClaimRepositoryImpl(mockDataSource);
  });

  test('returns claims when datasource successful', () async {
    final data = [const ClaimModel(userId:1,id:1,title:'t',body:'b')];
    when(mockDataSource.getClaims()).thenAnswer((_) async => data);
    final res = await repo.getClaims();
    expect(res, Right(data));
  });

  test('returns NetworkFailure on Dio connection error', () async {
    when(mockDataSource.getClaims()).thenThrow(DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionError));
    final res = await repo.getClaims();
    expect(res.isLeft(), true);
    expect(res.fold((l) => l, (r) => null), isA<NetworkFailure>());
  });
}
