import 'package:formz/formz.dart';

enum NameValidationError {
  invalid('Name must be at least 2 characters long');

  const NameValidationError(this.message);
  final String message;
}

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    return value.length >= 2 ? null : NameValidationError.invalid;
  }
}
