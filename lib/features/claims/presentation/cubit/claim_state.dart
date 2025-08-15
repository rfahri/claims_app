import 'package:equatable/equatable.dart';
import '../../domain/entities/claim.dart';

abstract class ClaimState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClaimInitial extends ClaimState {}

class ClaimLoading extends ClaimState {}

class ClaimLoaded extends ClaimState {
  final List<Claim> claims;
  ClaimLoaded(this.claims);

  @override
  List<Object?> get props => [claims];
}

class ClaimError extends ClaimState {
  final String message;
  ClaimError(this.message);

  @override
  List<Object?> get props => [message];
}
