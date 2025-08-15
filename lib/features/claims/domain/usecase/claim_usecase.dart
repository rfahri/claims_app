import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/claim.dart';
import '../repositories/claim_repository.dart';

class GetClaimsUseCase {
  final ClaimRepository repository;

  GetClaimsUseCase(this.repository);

  Future<Either<Failure, List<Claim>>> call() async {
    return await repository.getClaims();
  }
}