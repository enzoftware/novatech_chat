import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/domain/usecase/sign_in_use_case.dart';
import 'package:novatech_chat/core/domain/usecase/usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _googleSignInUseCase = GoogleSignInUseCase(
          authenticationRepository: authenticationRepository,
        ),
        _signInUseCase = SignInUseCase(
          authenticationRepository: authenticationRepository,
        ),
        super(const AuthenticationState()) {
    on<AuthenticationGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthenticationEmailChanged>(
      (event, emit) => emit(
        state.copyWith(email: event.email),
      ),
    );
    on<AuthenticationPasswordChanged>(
      (event, emit) => emit(
        state.copyWith(password: event.password),
      ),
    );
    on<AuthenticationSignInRequested>(_onSignInRequested);
  }

  final GoogleSignInUseCase _googleSignInUseCase;
  final SignInUseCase _signInUseCase;

  Future<void> _onGoogleSignInRequested(
    AuthenticationGoogleSignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    try {
      await _googleSignInUseCase();
      emit(state.copyWith(status: AuthenticationStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSignInRequested(
    AuthenticationSignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    try {
      await _signInUseCase(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: AuthenticationStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
