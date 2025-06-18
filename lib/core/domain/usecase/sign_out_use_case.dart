import 'package:novatech_chat/core/data/repository/authentication_repository.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  Future<void> call() async {
    await _authenticationRepository.signOut();
  }
}
