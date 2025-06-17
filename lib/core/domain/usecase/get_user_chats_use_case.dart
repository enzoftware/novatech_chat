import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

class GetUserChatsUseCase {
  GetUserChatsUseCase({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  final ChatRepository _chatRepository;

  Stream<List<ChatPreview>> call(String userId) {
    return _chatRepository.getChats(userId);
  }
}
