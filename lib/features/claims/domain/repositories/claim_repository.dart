import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/claim.dart';

abstract class ClaimRepository {
  Future<Either<Failure, List<Claim>>> getClaims();
}
