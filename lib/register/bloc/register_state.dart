part of 'register_bloc.dart';

final class RegisterState extends Equatable {
  const RegisterState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.name = const NameInput.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final EmailInput email;
  final PasswordInput password;
  final NameInput name;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  RegisterState copyWith({
    EmailInput? email,
    PasswordInput? password,
    NameInput? name,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        status,
        isValid,
        errorMessage,
      ];
}
