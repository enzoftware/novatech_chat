import 'package:formz/formz.dart';

enum PasswordValidationError {
  invalid(
    'Password must be at least 8 characters long and contain '
    'at least one number',
  );

  const PasswordValidationError(this.message);

  final String message;
}

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}
