import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/authentication/data/models/auth_model.dart';
import 'package:vocaday_app/features/authentication/domain/entities/auth_entity.dart';

class MockUser extends Mock implements User {}

void main() {
  final mockUser = MockUser();

  final testAuthModel = AuthModel(
    uid: 'uid',
    user: mockUser,
    signInMethod: SignInMethod.none,
  );
  final testAuthEntity = AuthEntity(
    uid: 'uid',
    user: mockUser,
    isNewUser: false,
    signInMethod: SignInMethod.none,
  );

  test('should return entity class from model', () {
    expect(testAuthModel.toEntity(), testAuthEntity);
  });
  test('should return model class with copyWith', () {
    final modelCopy = AuthModel(
      uid: 'new uid',
      user: mockUser,
      signInMethod: SignInMethod.email,
    );
    expect(
      testAuthModel.copyWith(
        uid: 'new uid',
        signInMethod: SignInMethod.email,
      ),
      modelCopy,
    );
  });
}
