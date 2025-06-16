import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/app/app.dart';
import 'package:novatech_chat/counter/counter.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        NolatechApp(
          firebaseAuth: MockFirebaseAuth(),
          googleSignIn: MockGoogleSignIn(),
        ),
      );
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
