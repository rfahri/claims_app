import 'package:claims_app/features/claims/data/models/claims.dart';
import 'package:claims_app/features/claims/data/repository/claims_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'claims_test.mocks.dart';

@GenerateMocks([ClaimsRepository])
void main() {
  late MockClaimsRepository mockClaimRepository;

  setUp(() {
    mockClaimRepository = MockClaimsRepository();
  });

  test('Should returns Claim data correctly by the same id that called', () async {
    // Arrange
    final claim = Claims(
      userId: 1,
      id: 1,
      title:
          "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
      body:
          "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
    );
    when(mockClaimRepository.getClaimById(1)).thenAnswer((_) async => claim);

    // Act
    final result = await mockClaimRepository.getClaimById(1);

    // Assert
    expect(result.id, 1);
    expect(result.userId, 1);
    expect(
      result.title,
      "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    );
    expect(
      result.body,
      "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
    );
    verify(mockClaimRepository.getClaimById(1)).called(1);
  });
}
