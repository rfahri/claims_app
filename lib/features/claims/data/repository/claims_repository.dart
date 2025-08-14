import '../models/claims.dart';

abstract class ClaimsRepository {
  Future<Claims> getClaimById(int id);
}