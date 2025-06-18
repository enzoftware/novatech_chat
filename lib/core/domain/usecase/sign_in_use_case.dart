import 'package:novatech_chat/core/data/repository/authentication_repository.dart';

class SignInUseCase {
  SignInUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  Future<void> call({required String email, required String password}) {
    return _authenticationRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
