import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

class GetChatUsersUseCase {
  GetChatUsersUseCase({
    required ChatRepository chatRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _chatRepository = chatRepository,
        _authenticationRepository = authenticationRepository;

  final ChatRepository _chatRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<List<ChatUser>> call() {
    final currentUser = _authenticationRepository.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    return _chatRepository.getChatUsers(currentUserId: currentUser.uid);
  }
}
