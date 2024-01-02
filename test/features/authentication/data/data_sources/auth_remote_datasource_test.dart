import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/authentication/data/data_sources/auth_remote_data_source.dart';

class MockUser extends Mock implements User {}

final _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    return Stream.fromIterable([_mockUser]);
  }
}

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockAuth);
  });
  group('User state changed', () {
    test('should get user state changed', () {
      expectLater(authRemoteDataSourceImpl.user, emitsInOrder([_mockUser]));
    });
  });
}
