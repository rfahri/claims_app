import 'package:flutter_test/flutter_test.dart';
import 'package:claims_app/features/claims/domain/entities/claim.dart';

void main() {
  test('Claim equality and props', () {
    const a = Claim(userId:1, id:1, title:'t', body:'b');
    expect(a.id, 1);
    expect(a.userId, 1);
    expect(a.body, 'b');
    expect(a.title, 't');
  });
}
