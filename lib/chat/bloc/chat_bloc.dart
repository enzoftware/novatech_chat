import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required ChatRepository chatRepository,
    required FirebaseAuth firebaseAuth,
    required String chatId,
  })  : _chatRepository = chatRepository,
        _firebaseAuth = firebaseAuth,
        _chatId = chatId,
        super(const ChatState()) {
    on<ChatStarted>(_onChatStarted);
    on<ChatMessageSent>(_onChatMessageSent);
    on<ChatMessagesReceived>(_onChatMessagesReceived);

    add(ChatStarted(chatId));
  }

  final ChatRepository _chatRepository;
  final FirebaseAuth _firebaseAuth;
  final String _chatId;
  StreamSubscription<List<Message>>? _messagesSubscription;

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    await _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository
        .getMessages(event.chatId)
        .listen((messages) => add(ChatMessagesReceived(messages)));
  }

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return;

      final message = Message(
        senderId: currentUser.uid,
        text: event.message,
        timestamp: DateTime.now(),
        read: false,
      );

      await _chatRepository.sendMessage(_chatId, message);
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }

  void _onChatMessagesReceived(
    ChatMessagesReceived event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: event.messages,
      ),
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
