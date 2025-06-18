import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/register/models/models.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.name,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.email,
          password,
          state.name,
        ]),
      ),
    );
  }

  void _onNameChanged(
    RegisterNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final name = NameInput.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([
          state.email,
          state.password,
          name,
        ]),
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.createUserWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
