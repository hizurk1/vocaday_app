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
  group("Password validate", () {
    test("should get [true] is a valid password", () {
      expect(Validator.validatePassword("abc12345"), true);
    });
    test("should get [false] is a invalid password", () {
      expect(Validator.validatePassword(""), false);
      expect(Validator.validatePassword("12345"), false);
      expect(Validator.validatePassword("123456789"), false);
      expect(Validator.validatePassword("abcdefgh"), false);
    });
  });

  group("Phone number validate", () {
    test("should get [true] is a valid phone number", () {
      expect(Validator.validatePhoneNumber("0987654321"), true);
      expect(Validator.validatePhoneNumber("0654321"), true);
      expect(Validator.validatePhoneNumber("+34876543210"), true);
      expect(Validator.validatePhoneNumber("+1654321"), true);
    });
    test("should get [false] is a invalid phone number", () {
      expect(Validator.validatePhoneNumber(""), false);
      expect(Validator.validatePhoneNumber("123456789"), false);
      expect(Validator.validatePhoneNumber("1234567890123"), false);
      expect(Validator.validatePhoneNumber("+01"), false);
      expect(Validator.validatePhoneNumber("+123456"), false);
    });
  });
}
