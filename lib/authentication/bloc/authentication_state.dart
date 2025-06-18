part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.initial,
    this.errorMessage = '',
    this.password = '',
    this.email = '',
  });

  final AuthenticationStatus status;
  final String errorMessage;
  final String password;
  final String email;

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? errorMessage,
    String? password,
    String? email,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, password, email];
}
