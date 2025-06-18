import 'package:flutter_test/flutter_test.dart';
import 'package:novatech_chat/register/models/models.dart';

void main() {
  group('EmailInput', () {
    test('supports value equality', () {
      expect(
        const EmailInput.pure(),
        const EmailInput.pure(),
      );
    });

    group('constructor', () {
      test('pure creates correct instance', () {
        const email = EmailInput.pure();
        expect(email.value, '');
        expect(email.isPure, true);
      });

      test('dirty creates correct instance', () {
        const email = EmailInput.dirty('test@example.com');
        expect(email.value, 'test@example.com');
        expect(email.isPure, false);
      });
    });

    group('validator', () {
      test('returns null when email is empty', () {
        expect(const EmailInput.dirty().error, EmailValidationError.invalid);
      });

      test('returns null when email is valid', () {
        expect(const EmailInput.dirty('test@example.com').error, null);
      });

      test('returns error when email is invalid', () {
        expect(
          const EmailInput.dirty('test').error,
          EmailValidationError.invalid,
        );
      });
    });
  });

  group('PasswordInput', () {
    test('supports value equality', () {
      expect(
        const PasswordInput.pure(),
        const PasswordInput.pure(),
      );
    });

    group('constructor', () {
      test('pure creates correct instance', () {
        const password = PasswordInput.pure();
        expect(password.value, '');
        expect(password.isPure, true);
      });

      test('dirty creates correct instance', () {
        const password = PasswordInput.dirty('password123');
        expect(password.value, 'password123');
        expect(password.isPure, false);
      });
    });

    group('validator', () {
      test('returns error when password is empty', () {
        expect(
          const PasswordInput.dirty().error,
          PasswordValidationError.invalid,
        );
      });

      test('returns error when password is too short', () {
        expect(
          const PasswordInput.dirty('pass').error,
          PasswordValidationError.invalid,
        );
      });

      test('returns error when password has no number', () {
        expect(
          const PasswordInput.dirty('password').error,
          PasswordValidationError.invalid,
        );
      });

      test('returns null when password is valid', () {
        expect(const PasswordInput.dirty('password123').error, null);
      });
    });
  });

  group('NameInput', () {
    test('supports value equality', () {
      expect(
        const NameInput.pure(),
        const NameInput.pure(),
      );
    });

    group('constructor', () {
      test('pure creates correct instance', () {
        const name = NameInput.pure();
        expect(name.value, '');
        expect(name.isPure, true);
      });

      test('dirty creates correct instance', () {
        const name = NameInput.dirty('test');
        expect(name.value, 'test');
        expect(name.isPure, false);
      });
    });

    group('validator', () {
      test('returns error when name is empty', () {
        expect(const NameInput.dirty().error, NameValidationError.invalid);
      });

      test('returns error when name is too short', () {
        expect(const NameInput.dirty('a').error, NameValidationError.invalid);
      });

      test('returns null when name is valid', () {
        expect(const NameInput.dirty('test').error, null);
      });
    });
  });
}
