import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novatech_chat/app/app.dart';
import 'package:novatech_chat/bootstrap.dart';

void main() {
  bootstrap(
    ({
      required GoogleSignIn googleSignIn,
      required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firestore,
    }) =>
        NolatechApp(
      googleSignIn: googleSignIn,
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    ),
  );
}
