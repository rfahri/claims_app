import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/claim_repository.dart';
import '../data_sources/claims_data_sources.dart';
import '../../domain/entities/claim.dart';

class ClaimRepositoryImpl implements ClaimRepository {
  final RemoteDataSource dataSource;

  ClaimRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Claim>>> getClaims() async {
    try {
      final result = await dataSource.getClaims();
      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('No internet connection'));
      } else if (e.response != null) {
        return Left(
          ServerFailure(
            'Server error: ${e.response?.statusCode} ${e.response?.statusMessage}',
          ),
        );
      } else {
        return Left(ServerFailure('Unexpected error: ${e.message}'));
      }
    } catch (e) {
      return Left(ServerFailure('Unknown error: $e'));
    }
  }
}
