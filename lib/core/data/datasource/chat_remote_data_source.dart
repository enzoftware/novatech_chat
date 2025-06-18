import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource({required this.firestore});

  final FirebaseFirestore firestore;

  Stream<List<ChatPreview>> getChatsForUser(String userId) {
    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastTimestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ChatPreview.fromFirestore).toList();
    });
  }

  Stream<List<Message>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(Message.fromFirestore).toList();
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required Message message,
  }) async {
    final chatRef = firestore.collection('chats').doc(chatId);
    final msgRef = chatRef.collection('messages').doc();

    await firestore.runTransaction((tx) async {
      tx
        ..set(msgRef, message.toMap())
        ..update(chatRef, {
          'lastMessage': message.text,
          'lastTimestamp': message.timestamp,
          'lastSenderId': message.senderId,
        });
    });
  }

  /// Creates a new chat between two users and returns the chat ID.
  /// [currentUserId] is the ID of the user creating the chat
  /// [otherUserId] is the ID of the user to chat with
  Future<String> createNewChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    // First check if a chat already exists between these users
    final querySnapshot = await firestore
        .collection('chats')
        .where('participants', arrayContainsAny: [currentUserId]).get();

    // Check if chat already exists
    for (final doc in querySnapshot.docs) {
      final participants = doc.data()['participants'] as List;
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    // If no chat exists, create a new one
    final chatDoc = firestore.collection('chats').doc();

    final chatData = {
      'participants': [currentUserId, otherUserId],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
      'lastSenderId': '',
    };

    await chatDoc.set(chatData);

    final chatId = chatDoc.id;
    final defaultMessage = Message(
      read: false,
      senderId: currentUserId,
      text: 'Hello! This is a new chat.',
      timestamp: DateTime.now(),
    );
    await sendMessage(chatId: chatId, message: defaultMessage);
    return chatId;
  }

  /// Fetches all registered users except the current user
  /// Returns a future with the list of users
  Future<List<ChatUser>> getRegisteredUsers({
    required String currentUserId,
    String? searchQuery,
  }) async {
    var query = firestore
        .collection('users')
        .where('id', isNotEqualTo: currentUserId)
        .orderBy('displayName');

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Add search functionality if a query is provided
      final searchLower = searchQuery.toLowerCase();
      query = query
          .where('searchName', isGreaterThanOrEqualTo: searchLower)
          .where('searchName', isLessThan: '${searchLower}z');
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatUser(
        id: doc.id,
        displayName: data['displayName'] as String? ?? 'Unknown User',
        email: data['email'] as String? ?? '',
        photoUrl: data['photoUrl'] as String?,
        lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
        isOnline: data['isOnline'] as bool? ?? false,
      );
    }).toList();
  }

  /// Updates the online status and last seen time of a user
  Future<void> updateUserStatus({
    required String userId,
    required bool isOnline,
  }) async {
    await firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  /// Fetches a user by their ID
  Future<ChatUser?> getUserById(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      return ChatUser(
        id: doc.id,
        displayName: data?['displayName'] as String? ?? 'Unknown User',
        email: data?['email'] as String? ?? '',
        photoUrl: data?['photoUrl'] as String?,
        lastSeen: (data?['lastSeen'] as Timestamp?)?.toDate(),
        isOnline: data?['isOnline'] as bool? ?? false,
      );
    }
    return null;
  }
}
