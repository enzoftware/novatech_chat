import 'package:novatech_chat/core/data/datasource/chat_remote_data_source.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

abstract class ChatRepository {
  Stream<List<ChatPreview>> getChats(String userId);
  Stream<List<Message>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, Message message);
  Future<List<ChatUser>> getChatUsers({
    required String currentUserId,
    String? searchQuery,
  });
  Future<String> createNewChat({
    required String currentUserId,
    required String otherUserId,
  });
  Future<ChatUser> getUserById(String userId);
}

class FirebaseChatRepository implements ChatRepository {
  FirebaseChatRepository({
    required this.remoteDataSource,
  });

  final ChatRemoteDataSource remoteDataSource;

  @override
  Stream<List<ChatPreview>> getChats(String userId) {
    return remoteDataSource.getChatsForUser(userId);
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return remoteDataSource.getMessages(chatId);
  }

  @override
  Future<void> sendMessage(String chatId, Message message) {
    return remoteDataSource.sendMessage(chatId: chatId, message: message);
  }

  @override
  Future<List<ChatUser>> getChatUsers({
    required String currentUserId,
    String? searchQuery,
  }) {
    return remoteDataSource.getRegisteredUsers(
      currentUserId: currentUserId,
      searchQuery: searchQuery,
    );
  }

  @override
  Future<String> createNewChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    return remoteDataSource.createNewChat(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  @override
  Future<ChatUser> getUserById(String userId) async {
    final user = await remoteDataSource.getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }
}
