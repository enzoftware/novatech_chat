import 'package:firebase_auth/firebase_auth.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';

class GoogleSignInUseCase {
  GoogleSignInUseCase({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  Future<UserCredential> call() async {
    return _authenticationRepository.signInWithGoogle();
  }
}
