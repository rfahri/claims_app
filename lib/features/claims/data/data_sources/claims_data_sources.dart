import 'package:claims_app/features/claims/data/models/claim_model.dart';
import 'package:dio/dio.dart';

abstract class RemoteDataSource {
  Future<List<ClaimModel>> getClaims();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  RemoteDataSourceImpl(this.dio);

  @override
  Future<List<ClaimModel>> getClaims() async {
    final res = await dio.get('/posts');
    final data = res.data as List;
    return data.map((e) => ClaimModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}