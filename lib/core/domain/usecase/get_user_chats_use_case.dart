import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

class ChatPreviewUi {
  ChatPreviewUi({
    required this.chatPreview,
    required this.sender,
  });

  final ChatPreview chatPreview;
  final ChatUser sender;
}

class GetUserChatsUseCase {
  GetUserChatsUseCase({
    required ChatRepository chatRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _chatRepository = chatRepository,
        _authenticationRepository = authenticationRepository;

  final ChatRepository _chatRepository;
  final AuthenticationRepository _authenticationRepository;

  Stream<List<ChatPreviewUi>> call(String userId) async* {
    final currentUser = _authenticationRepository.currentUser;
    await for (final chats in _chatRepository.getChats(userId)) {
      final chatPreviews = await Future.wait(
        chats.map((chat) async {
          final sender = chat.participants.firstWhere(
            (participant) => participant != currentUser?.uid,
            orElse: () => '',
          );
          if (sender.isEmpty) {
            throw Exception('No sender found for chat: ${chat.id}');
          }
          final senderUser = await _chatRepository.getUserById(sender);
          final chatUser = ChatUser(
            id: senderUser.id,
            displayName: senderUser.displayName,
            email: senderUser.email,
            photoUrl: senderUser.photoUrl,
          );
          return ChatPreviewUi(chatPreview: chat, sender: chatUser);
        }),
      );
      yield chatPreviews;
    }
  }
}
