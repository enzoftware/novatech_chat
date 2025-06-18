import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novatech_chat/core/data/datasource/chat_remote_data_source.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ChatRemoteDataSource chatRemoteDataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    chatRemoteDataSource = ChatRemoteDataSource(firestore: fakeFirestore);
  });

  group('getChatsForUser', () {
    test('returns stream of chat previews for user', () async {
      // Arrange
      const userId = 'user1';
      final chatData = {
        'participants': [userId, 'user2'],
        'lastMessage': 'Hello',
        'lastTimestamp': Timestamp.fromDate(DateTime(2025)),
        'lastSenderId': 'user2',
      };
      await fakeFirestore.collection('chats').add(chatData);

      // Act
      final stream = chatRemoteDataSource.getChatsForUser(userId);

      // Assert
      await expectLater(
        stream,
        emits(
          isA<List<ChatPreview>>().having(
            (list) => list.length,
            'length',
            1,
          ),
        ),
      );
    });

    test('returns empty list when no chats exist', () async {
      // Act
      final stream = chatRemoteDataSource.getChatsForUser('nonexistent');

      // Assert
      await expectLater(stream, emits(isEmpty));
    });
  });

  group('getMessages', () {
    test('returns stream of messages for chat', () async {
      // Arrange
      const chatId = 'chat1';
      final messageData = {
        'senderId': 'user1',
        'text': 'Hello',
        'timestamp': Timestamp.fromDate(DateTime(2025)),
        'read': false,
      };
      await fakeFirestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      // Act
      final stream = chatRemoteDataSource.getMessages(chatId);

      // Assert
      await expectLater(
        stream,
        emits(
          isA<List<Message>>().having(
            (list) => list.length,
            'length',
            1,
          ),
        ),
      );
    });

    test('returns empty list when no messages exist', () async {
      // Act
      final stream = chatRemoteDataSource.getMessages('nonexistent');

      // Assert
      await expectLater(stream, emits(isEmpty));
    });
  });

  group('sendMessage', () {
    test('successfully sends message and updates chat', () async {
      // Arrange
      const chatId = 'chat1';
      final message = Message(
        senderId: 'user1',
        text: 'Test message',
        timestamp: DateTime(2025),
        read: false,
      );

      // Create the chat document first
      await fakeFirestore.collection('chats').doc(chatId).set({
        'participants': ['user1', 'user2'],
        'lastMessage': '',
        'lastTimestamp': Timestamp.now(),
        'lastSenderId': '',
      });

      // Act
      await chatRemoteDataSource.sendMessage(
        chatId: chatId,
        message: message,
      );

      // Assert
      final chatDoc = await fakeFirestore.collection('chats').doc(chatId).get();
      expect(chatDoc.data()?['lastMessage'], equals('Test message'));
      expect(chatDoc.data()?['lastSenderId'], equals('user1'));

      final messagesSnapshot = await fakeFirestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();
      expect(messagesSnapshot.docs, hasLength(1));
      expect(
        messagesSnapshot.docs.first.data()['text'],
        equals('Test message'),
      );
    });
  });

  group('createNewChat', () {
    test('creates new chat when no chat exists between users', () async {
      // Arrange
      const currentUserId = 'user1';
      const otherUserId = 'user2';

      // Act
      final chatId = await chatRemoteDataSource.createNewChat(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      );

      // Assert
      final chatDoc = await fakeFirestore.collection('chats').doc(chatId).get();
      expect(chatDoc.exists, isTrue);
      expect(
        chatDoc.data()?['participants'],
        containsAll([currentUserId, otherUserId]),
      );

      final messagesSnapshot = await fakeFirestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();
      expect(messagesSnapshot.docs, hasLength(1)); // Default message
      expect(
        messagesSnapshot.docs.first.data()['text'],
        equals('Hello! This is a new chat.'),
      );
    });

    test('returns existing chat id when chat already exists', () async {
      // Arrange
      const currentUserId = 'user1';
      const otherUserId = 'user2';
      final existingChatDoc = await fakeFirestore.collection('chats').add({
        'participants': [currentUserId, otherUserId],
        'lastMessage': '',
        'lastTimestamp': Timestamp.now(),
        'lastSenderId': '',
      });

      // Act
      final chatId = await chatRemoteDataSource.createNewChat(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      );

      // Assert
      expect(chatId, equals(existingChatDoc.id));

      final chatsSnapshot = await fakeFirestore.collection('chats').get();
      expect(chatsSnapshot.docs, hasLength(1)); // No new chat created
    });
  });

  group('getRegisteredUsers', () {
    test('returns list of users excluding current user', () async {
      // Arrange
      const currentUserId = 'user1';
      await fakeFirestore.collection('users').doc(currentUserId).set({
        'id': currentUserId,
        'displayName': 'Current User',
        'email': 'current@test.com',
        'isOnline': true,
      });

      await fakeFirestore.collection('users').doc('user2').set({
        'id': 'user2',
        'displayName': 'Other User',
        'email': 'other@test.com',
        'isOnline': false,
      });

      // Act
      final users = await chatRemoteDataSource.getRegisteredUsers(
        currentUserId: currentUserId,
      );

      // Assert
      expect(users, hasLength(1));
      expect(users.first.id, equals('user2'));
      expect(users.first.displayName, equals('Other User'));
    });

    test('filters users by search query', () async {
      // Arrange
      const currentUserId = 'user1';
      await fakeFirestore.collection('users').doc('user2').set({
        'id': 'user2',
        'displayName': 'Alice',
        'searchName': 'alice',
        'email': 'alice@test.com',
      });

      await fakeFirestore.collection('users').doc('user3').set({
        'id': 'user3',
        'displayName': 'Bob',
        'searchName': 'bob',
        'email': 'bob@test.com',
      });

      // Act
      final users = await chatRemoteDataSource.getRegisteredUsers(
        currentUserId: currentUserId,
        searchQuery: 'ali',
      );

      // Assert
      expect(users, hasLength(1));
      expect(users.first.displayName, equals('Alice'));
    });
  });

  group('updateUserStatus', () {
    test('successfully updates user online status and last seen', () async {
      // Arrange
      const userId = 'user1';
      await fakeFirestore.collection('users').doc(userId).set({
        'id': userId,
        'isOnline': false,
        'lastSeen': Timestamp.fromDate(DateTime(2025)),
      });

      // Act
      await chatRemoteDataSource.updateUserStatus(
        userId: userId,
        isOnline: true,
      );

      // Assert
      final userDoc = await fakeFirestore.collection('users').doc(userId).get();
      expect(userDoc.data()?['isOnline'], isTrue);
      expect(userDoc.data()?['lastSeen'], isA<Timestamp>());
    });

    test('throws exception when user does not exist', () async {
      // Act & Assert
      expect(
        () => chatRemoteDataSource.updateUserStatus(
          userId: 'nonexistent',
          isOnline: true,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
