import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/core/data/datasource/chat_remote_data_source.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late FirebaseChatRepository repository;
  late MockChatRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    repository = FirebaseChatRepository(remoteDataSource: mockRemoteDataSource);
    registerFallbackValue(
      Message(
        senderId: 'user1',
        text: 'test message',
        timestamp: DateTime(2025),
        read: false,
      ),
    );
  });

  group('constructor', () {
    test('instantiates repository with remote data source', () {
      expect(
        () => FirebaseChatRepository(remoteDataSource: mockRemoteDataSource),
        isNot(throwsException),
      );
    });
  });

  group('getChats', () {
    test('returns stream of chat previews from remote data source', () {
      // Arrange
      const userId = 'user1';
      final chatPreviews = [
        const ChatPreview(
          id: 'chat1',
          participants: ['user1', 'user2'],
          lastMessage: 'Hello',
          lastSenderId: 'user2',
        ),
      ];
      when(() => mockRemoteDataSource.getChatsForUser(userId))
          .thenAnswer((_) => Stream.value(chatPreviews));

      // Act
      final stream = repository.getChats(userId);

      // Assert
      expect(stream, emits(chatPreviews));
      verify(() => mockRemoteDataSource.getChatsForUser(userId)).called(1);
    });

    test('propagates errors from remote data source', () {
      // Arrange
      const userId = 'user1';
      when(() => mockRemoteDataSource.getChatsForUser(userId))
          .thenAnswer((_) => Stream.error('Error fetching chats'));

      // Act & Assert
      expect(
        repository.getChats(userId),
        emitsError('Error fetching chats'),
      );
    });
  });

  group('getMessages', () {
    test('returns stream of messages from remote data source', () {
      // Arrange
      const chatId = 'chat1';
      final messages = [
        Message(
          senderId: 'user1',
          text: 'Hello',
          timestamp: DateTime(2025),
          read: false,
        ),
      ];
      when(() => mockRemoteDataSource.getMessages(chatId))
          .thenAnswer((_) => Stream.value(messages));

      // Act
      final stream = repository.getMessages(chatId);

      // Assert
      expect(stream, emits(messages));
      verify(() => mockRemoteDataSource.getMessages(chatId)).called(1);
    });

    test('propagates errors from remote data source', () {
      // Arrange
      const chatId = 'chat1';
      when(() => mockRemoteDataSource.getMessages(chatId))
          .thenAnswer((_) => Stream.error('Error fetching messages'));

      // Act & Assert
      expect(
        repository.getMessages(chatId),
        emitsError('Error fetching messages'),
      );
    });
  });

  group('sendMessage', () {
    test('sends message through remote data source', () async {
      // Arrange
      const chatId = 'chat1';
      final message = Message(
        senderId: 'user1',
        text: 'Hello',
        timestamp: DateTime(2025),
        read: false,
      );
      when(
        () => mockRemoteDataSource.sendMessage(
          chatId: chatId,
          message: message,
        ),
      ).thenAnswer((_) async {});

      // Act
      await repository.sendMessage(chatId, message);

      // Assert
      verify(
        () => mockRemoteDataSource.sendMessage(
          chatId: chatId,
          message: message,
        ),
      ).called(1);
    });

    test('propagates errors from remote data source', () async {
      // Arrange
      const chatId = 'chat1';
      final message = Message(
        senderId: 'user1',
        text: 'Hello',
        timestamp: DateTime(2025),
        read: false,
      );
      when(
        () => mockRemoteDataSource.sendMessage(
          chatId: chatId,
          message: message,
        ),
      ).thenThrow(Exception('Failed to send message'));

      // Act & Assert
      expect(
        () => repository.sendMessage(chatId, message),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getChatUsers', () {
    test('returns list of chat users from remote data source', () async {
      // Arrange
      const currentUserId = 'user1';
      const searchQuery = 'john';
      final users = [
        ChatUser(
          id: 'user2',
          displayName: 'John Doe',
          email: 'john@example.com',
          photoUrl: 'https://example.com/photo.jpg',
          lastSeen: DateTime(2025),
          isOnline: true,
        ),
      ];

      when(
        () => mockRemoteDataSource.getRegisteredUsers(
          currentUserId: currentUserId,
          searchQuery: searchQuery,
        ),
      ).thenAnswer((_) async => users);

      // Act
      final result = await repository.getChatUsers(
        currentUserId: currentUserId,
        searchQuery: searchQuery,
      );

      // Assert
      expect(result, equals(users));
      verify(
        () => mockRemoteDataSource.getRegisteredUsers(
          currentUserId: currentUserId,
          searchQuery: searchQuery,
        ),
      ).called(1);
    });

    test('propagates errors from remote data source', () {
      // Arrange
      const currentUserId = 'user1';
      when(
        () => mockRemoteDataSource.getRegisteredUsers(
          currentUserId: currentUserId,
        ),
      ).thenThrow(Exception('Failed to fetch users'));

      // Act & Assert
      expect(
        () => repository.getChatUsers(currentUserId: currentUserId),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('createNewChat', () {
    test('creates new chat through remote data source', () async {
      // Arrange
      const currentUserId = 'user1';
      const otherUserId = 'user2';
      const chatId = 'new-chat-id';

      when(
        () => mockRemoteDataSource.createNewChat(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        ),
      ).thenAnswer((_) async => chatId);

      // Act
      final result = await repository.createNewChat(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      );

      // Assert
      expect(result, equals(chatId));
      verify(
        () => mockRemoteDataSource.createNewChat(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        ),
      ).called(1);
    });

    test('propagates errors from remote data source', () {
      // Arrange
      const currentUserId = 'user1';
      const otherUserId = 'user2';
      when(
        () => mockRemoteDataSource.createNewChat(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        ),
      ).thenThrow(Exception('Failed to create chat'));

      // Act & Assert
      expect(
        () => repository.createNewChat(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
