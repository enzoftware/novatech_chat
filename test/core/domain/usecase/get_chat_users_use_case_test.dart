import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';
import 'package:novatech_chat/core/domain/usecase/get_chat_users_use_case.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUser extends Mock implements User {
  @override
  String get uid => 'test-uid';
}

void main() {
  late GetChatUsersUseCase useCase;
  late MockChatRepository mockChatRepository;
  late MockAuthenticationRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockAuthRepository = MockAuthenticationRepository();
    mockUser = MockUser();
    useCase = GetChatUsersUseCase(
      chatRepository: mockChatRepository,
      authenticationRepository: mockAuthRepository,
    );
  });

  group('constructor', () {
    test('instantiates use case with required repositories', () {
      expect(
        () => GetChatUsersUseCase(
          chatRepository: mockChatRepository,
          authenticationRepository: mockAuthRepository,
        ),
        isNot(throwsException),
      );
    });
  });

  group('GetChatUsersUseCase', () {
    test('returns list of chat users when user is authenticated', () async {
      final chatUsers = [
        ChatUser(
          id: 'user1',
          displayName: 'Test User 1',
          email: 'test1@example.com',
          photoUrl: 'https://example.com/photo1.jpg',
          lastSeen: DateTime(2025),
          isOnline: true,
        ),
        ChatUser(
          id: 'user2',
          displayName: 'Test User 2',
          email: 'test2@example.com',
          photoUrl: 'https://example.com/photo2.jpg',
          lastSeen: DateTime(2025),
        ),
      ];

      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(
        () => mockChatRepository.getChatUsers(
          currentUserId: mockUser.uid,
        ),
      ).thenAnswer((_) async => chatUsers);

      final result = await useCase();

      expect(result, equals(chatUsers));
      verify(() => mockAuthRepository.currentUser).called(1);
      verify(
        () => mockChatRepository.getChatUsers(
          currentUserId: mockUser.uid,
        ),
      ).called(1);
    });

    test('throws exception when user is not authenticated', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      expect(
        () => useCase(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('User not authenticated'),
          ),
        ),
      );
      verify(() => mockAuthRepository.currentUser).called(1);
      verifyNever(
        () => mockChatRepository.getChatUsers(
          currentUserId: any(named: 'currentUserId'),
        ),
      );
    });

    test('propagates errors from chat repository', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(
        () => mockChatRepository.getChatUsers(
          currentUserId: mockUser.uid,
        ),
      ).thenThrow(Exception('Failed to fetch users'));

      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockAuthRepository.currentUser).called(1);
      verify(
        () => mockChatRepository.getChatUsers(
          currentUserId: mockUser.uid,
        ),
      ).called(1);
    });
  });
}
