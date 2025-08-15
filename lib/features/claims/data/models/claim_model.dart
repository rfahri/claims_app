import '../../domain/entities/claim.dart';

class ClaimModel extends Claim {
  const ClaimModel({required super.userId, required super.id, required super.title, required super.body});

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}