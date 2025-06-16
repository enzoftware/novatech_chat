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
