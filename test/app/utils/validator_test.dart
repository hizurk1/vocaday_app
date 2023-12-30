import 'package:flutter_test/flutter_test.dart';
import 'package:vocaday_app/app/utils/validator.dart';

void main() {
  group('Email validate', () {
    test('should get [true] is a valid email', () {
      expect(Validator.validateEmail("test@test.com"), true);
      expect(Validator.validateEmail("test@test.gm.com"), true);
      expect(Validator.validateEmail("test_a@test.com"), true);
      expect(Validator.validateEmail("test.a@test.com"), true);
      expect(Validator.validateEmail("Test@TeSt.CoM"), true);
    });
    test('should get [false] is a invalid email', () {
      expect(Validator.validateEmail(""), false);
      expect(Validator.validateEmail("test"), false);
      expect(Validator.validateEmail("test@abc."), false);
      expect(Validator.validateEmail("test@test"), false);
      expect(Validator.validateEmail("test!@test.com"), false);
      expect(Validator.validateEmail("test..test@test.com"), false);
      expect(Validator.validateEmail("test@test..com"), false);
      expect(Validator.validateEmail("test@.com"), false);
      expect(Validator.validateEmail("testtest.com"), false);
      expect(Validator.validateEmail("test @test.com"), false);
      expect(Validator.validateEmail(" test@test.com"), false);
      expect(Validator.validateEmail("test_.#\$!-=+'\"|/\\@test.com"), false);
    });
  });
}
