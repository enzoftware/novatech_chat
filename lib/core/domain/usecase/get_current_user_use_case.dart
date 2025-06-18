import 'package:firebase_auth/firebase_auth.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  Future<User?> call() async {
    final currentUser = _authenticationRepository.currentUser;
    if (currentUser == null) {
      return null;
    }
    return currentUser;
  }
}
