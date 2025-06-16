import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novatech_chat/app/app.dart';
import 'package:novatech_chat/bootstrap.dart';

void main() {
  bootstrap(
    ({
      required GoogleSignIn googleSignIn,
      required FirebaseAuth firebaseAuth,
    }) async =>
        NolatechApp(
      googleSignIn: googleSignIn,
      firebaseAuth: firebaseAuth,
    ),
  );
}
