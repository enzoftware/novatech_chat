import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';
import 'package:novatech_chat/new_chat/bloc/new_chat_bloc.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockChatUser extends Mock implements ChatUser {
  @override
  String get id => 'test-user-id';
}

class MockCurrentUser extends Mock implements User {
  @override
  String get uid => 'current-user-id';
}

void main() {
  late NewChatBloc bloc;
  late MockCurrentUser mockCurrentUser;
  late MockChatRepository mockChatRepository;
  late MockAuthenticationRepository mockAuthRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockAuthRepository = MockAuthenticationRepository();
    mockCurrentUser = MockCurrentUser();

    when(() => mockAuthRepository.currentUser).thenReturn(mockCurrentUser);
    when(
      () => mockChatRepository.getChatUsers(
        currentUserId: any(named: 'currentUserId'),
      ),
    ).thenAnswer((_) async => []);

    when(
      () => mockChatRepository.createNewChat(
        currentUserId: any(named: 'currentUserId'),
        otherUserId: any(named: 'otherUserId'),
      ),
    ).thenAnswer((_) async => 'new-chat-id');

    bloc = NewChatBloc(
      chatRepository: mockChatRepository,
      authenticationRepository: mockAuthRepository,
    );
  });

  group('constructor', () {
    test('instantiates bloc with required repositories', () {
      expect(
        () => NewChatBloc(
          chatRepository: mockChatRepository,
          authenticationRepository: mockAuthRepository,
        ),
        isNot(throwsException),
      );
    });

    test('initial state is correct', () {
      expect(bloc.state, equals(const NewChatState()));
    });
  });

  group('NewChatGetUsers', () {
    final users = [
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

    blocTest<NewChatBloc, NewChatState>(
      'emits [loading, success] when getting users succeeds',
      setUp: () {
        when(
          () => mockChatRepository.getChatUsers(
            currentUserId: any(named: 'currentUserId'),
          ),
        ).thenAnswer((_) async => users);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const NewChatGetUsers()),
      expect: () => [
        const NewChatState(status: NewChatStatus.loading),
        NewChatState(
          status: NewChatStatus.success,
          users: users,
        ),
      ],
      verify: (_) {
        verify(
          () => mockChatRepository.getChatUsers(
            currentUserId: 'current-user-id',
          ),
        ).called(1);
      },
    );

    blocTest<NewChatBloc, NewChatState>(
      'emits [loading, failure] when getting users fails',
      setUp: () {
        when(
          () => mockChatRepository.getChatUsers(
            currentUserId: any(named: 'currentUserId'),
          ),
        ).thenThrow(Exception('Failed to get users'));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const NewChatGetUsers()),
      expect: () => [
        const NewChatState(status: NewChatStatus.loading),
        const NewChatState(status: NewChatStatus.failure),
      ],
    );

    blocTest<NewChatBloc, NewChatState>(
      'emits [loading, failure] when user is not authenticated',
      setUp: () {
        when(() => mockAuthRepository.currentUser?.uid).thenReturn(null);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const NewChatGetUsers()),
      expect: () => [
        const NewChatState(status: NewChatStatus.loading),
        const NewChatState(status: NewChatStatus.failure),
      ],
    );
  });

  group('NewChatStartChatWithUser', () {
    const otherUserId = 'other-user-id';

    blocTest<NewChatBloc, NewChatState>(
      'emits [success] when starting chat succeeds',
      setUp: () {
        when(
          () => mockChatRepository.createNewChat(
            currentUserId: any(named: 'currentUserId'),
            otherUserId: otherUserId,
          ),
        ).thenAnswer((_) async => 'new-chat-id');
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const NewChatStartChatWithUser('other-user-id')),
      expect: () => [
        const NewChatState(status: NewChatStatus.success),
      ],
      verify: (_) {
        verify(
          () => mockChatRepository.createNewChat(
            currentUserId: 'current-user-id',
            otherUserId: otherUserId,
          ),
        ).called(1);
      },
    );

    blocTest<NewChatBloc, NewChatState>(
      'emits [failure] when starting chat fails',
      setUp: () {
        when(
          () => mockChatRepository.createNewChat(
            currentUserId: any(named: 'currentUserId'),
            otherUserId: otherUserId,
          ),
        ).thenThrow(Exception('Failed to create chat'));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const NewChatStartChatWithUser('other-user-id')),
      expect: () => [
        const NewChatState(status: NewChatStatus.failure),
      ],
    );

    blocTest<NewChatBloc, NewChatState>(
      'emits [failure] when user is not authenticated',
      setUp: () {
        when(() => mockAuthRepository.currentUser?.uid).thenReturn(null);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const NewChatStartChatWithUser('other-user-id')),
      expect: () => [
        const NewChatState(status: NewChatStatus.failure),
      ],
    );
  });
}
