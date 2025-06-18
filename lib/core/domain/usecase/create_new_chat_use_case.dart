import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';

class CreateNewChatUseCase {
  CreateNewChatUseCase({
    required ChatRepository chatRepository,
    required AuthenticationRepository? authenticationRepository,
  })  : _chatRepository = chatRepository,
        _authenticationRepository = authenticationRepository!;

  final ChatRepository _chatRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> call({
    required String otherUserId,
  }) async {
    final currentUser = _authenticationRepository.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    await _chatRepository.createNewChat(
      currentUserId: currentUser.uid,
      otherUserId: otherUserId,
    );
  }
}
