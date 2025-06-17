import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/app/app.dart';
import 'package:novatech_chat/counter/counter.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        NolatechApp(
          firebaseAuth: MockFirebaseAuth(),
          googleSignIn: MockGoogleSignIn(),
          firestore: MockFirebaseFirestore(),
        ),
      );
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
