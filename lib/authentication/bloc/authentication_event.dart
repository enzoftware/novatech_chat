part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationGoogleSignInRequested extends AuthenticationEvent {
  const AuthenticationGoogleSignInRequested();

  @override
  List<Object> get props => [];
}

class AuthenticationEmailChanged extends AuthenticationEvent {
  const AuthenticationEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class AuthenticationPasswordChanged extends AuthenticationEvent {
  const AuthenticationPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class AuthenticationSignInRequested extends AuthenticationEvent {
  const AuthenticationSignInRequested();

  @override
  List<Object> get props => [];
}
