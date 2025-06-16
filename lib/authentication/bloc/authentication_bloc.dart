import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novatech_chat/core/domain/usecase/usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required GoogleSignInUseCase googleSignInUseCase,
  })  : _googleSignInUseCase = googleSignInUseCase,
        super(const AuthenticationState()) {
    on<AuthenticationGoogleSignInRequested>(_onGoogleSignInRequested);
  }

  final GoogleSignInUseCase _googleSignInUseCase;

  Future<void> _onGoogleSignInRequested(
    AuthenticationGoogleSignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    try {
      await _googleSignInUseCase.call();
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
