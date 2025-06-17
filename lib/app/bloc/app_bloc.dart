import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AppState()) {
    on<AppAuthenticationChanged>(_onAuthenticationChanged);
    _authSubscription = _authenticationRepository.authStateChanges.listen(
      (user) => add(AppAuthenticationChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User?> _authSubscription;

  void _onAuthenticationChanged(
    AppAuthenticationChanged event,
    Emitter<AppState> emit,
  ) {
    emit(
      state.copyWith(
        status: event.user != null
            ? AppStatus.authenticated
            : AppStatus.unauthenticated,
        user: event.user,
      ),
    );
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
