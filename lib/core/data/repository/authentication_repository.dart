import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This is an abstract class for the authentication repository.
abstract class AuthenticationRepository {
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
}

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  FirebaseAuthenticationRepository({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
