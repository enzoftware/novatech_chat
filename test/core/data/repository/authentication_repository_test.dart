import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  late FirebaseAuthenticationRepository repository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FakeFirebaseFirestore fakeFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late MockAuthCredential mockAuthCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    fakeFirestore = FakeFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockAuthCredential = MockAuthCredential();
    mockUser = MockUser();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

    repository = FirebaseAuthenticationRepository(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
      firestore: fakeFirestore,
    );

    // Default mock values
    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockGoogleSignInAccount.id).thenReturn('google-account-id');

    registerFallbackValue(mockAuthCredential);
    registerFallbackValue(mockGoogleSignInAccount);
    registerFallbackValue(mockGoogleSignInAuthentication);
    registerFallbackValue(mockUserCredential);
    registerFallbackValue(mockUser);
    registerFallbackValue(mockFirebaseAuth);
    registerFallbackValue(mockGoogleSignIn);
  });

  group('constructor', () {
    test('instantiates internal firebase auth instance when not injected', () {
      expect(
        () => FirebaseAuthenticationRepository(
          firebaseAuth: mockFirebaseAuth,
          googleSignIn: mockGoogleSignIn,
          firestore: fakeFirestore,
        ),
        isNot(throwsException),
      );
    });
  });

  group('currentUser', () {
    test('returns current user when authenticated', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      expect(repository.currentUser, equals(mockUser));
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });

    test('returns null when not authenticated', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);
      expect(repository.currentUser, isNull);
      verify(() => mockFirebaseAuth.currentUser).called(1);
    });
  });

  group('authStateChanges', () {
    test('emits user when authenticated', () {
      final stream = Stream.value(mockUser);
      when(() => mockFirebaseAuth.authStateChanges()).thenAnswer((_) => stream);

      expect(repository.authStateChanges, emits(mockUser));
      verify(() => mockFirebaseAuth.authStateChanges()).called(1);
    });

    test('emits null when not authenticated', () {
      final stream = Stream<User?>.value(null);
      when(() => mockFirebaseAuth.authStateChanges()).thenAnswer((_) => stream);

      expect(repository.authStateChanges, emits(null));
      verify(() => mockFirebaseAuth.authStateChanges()).called(1);
    });
  });

  group('signInWithGoogle', () {
    setUp(() {
      when(() => mockGoogleSignInAuthentication.accessToken)
          .thenReturn('access-token');
      when(() => mockGoogleSignInAuthentication.idToken).thenReturn('id-token');
      when(() => mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(() => mockFirebaseAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockUserCredential);
    });

    test('signs in successfully with Google', () async {
      when(() => mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);

      final result = await repository.signInWithGoogle();

      expect(result, equals(mockUserCredential));
      verify(() => mockGoogleSignIn.signIn()).called(1);
      verify(() => mockGoogleSignInAccount.authentication).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);

      // Verify user document was created/updated in Firestore
      final userDoc =
          await fakeFirestore.collection('users').doc(mockUser.uid).get();
      expect(userDoc.exists, isTrue);
      expect(userDoc.data()?['email'], equals('test@example.com'));
      expect(userDoc.data()?['displayName'], equals('Test User'));
    });

    test('throws exception when Firebase sign in fails', () async {
      when(() => mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(() => mockFirebaseAuth.signInWithCredential(any()))
          .thenThrow(Exception('Firebase error'));

      expect(
        () => repository.signInWithGoogle(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to sign in with Google'),
          ),
        ),
      );
    });
  });

  group('signOut', () {
    test('signs out successfully and updates online status', () async {
      // Setup: Create a user document in Firestore
      await fakeFirestore.collection('users').doc(mockUser.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });

      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);

      // Verify user's online status was updated
      final userDoc =
          await fakeFirestore.collection('users').doc(mockUser.uid).get();
      expect(userDoc.data()?['isOnline'], isFalse);
    });

    test('signs out when no current user exists', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('throws exception when sign out fails', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockFirebaseAuth.signOut())
          .thenThrow(Exception('Sign out error'));

      expect(
        () => repository.signOut(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
