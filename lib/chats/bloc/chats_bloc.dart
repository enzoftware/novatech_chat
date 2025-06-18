import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/usecase/get_current_user_use_case.dart';
import 'package:novatech_chat/core/domain/usecase/get_user_chats_use_case.dart';
import 'package:novatech_chat/core/domain/usecase/sign_out_use_case.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc({
    required AuthenticationRepository authenticationRepository,
    required ChatRepository chatRepository,
  })  : _signOutUseCase = SignOutUseCase(
          authenticationRepository: authenticationRepository,
        ),
        _getUserChatsUseCase = GetUserChatsUseCase(
          chatRepository: chatRepository,
          authenticationRepository: authenticationRepository,
        ),
        _getCurrentUserUseCase = GetCurrentUserUseCase(
          authenticationRepository: authenticationRepository,
        ),
        super(const ChatsState()) {
    on<ChatsSignOut>(_onSignOut);
    on<ChatsGetUserChats>(_onGetUserChats);
  }

  final SignOutUseCase _signOutUseCase;
  final GetUserChatsUseCase _getUserChatsUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> _onGetUserChats(
    ChatsGetUserChats event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      if (emit.isDone) return;
      emit(state.copyWith(status: ChatsStatus.loading));

      final currentUser = await _getCurrentUserUseCase();

      await emit.forEach<List<ChatPreviewUi>>(
        _getUserChatsUseCase(currentUser?.uid ?? ''),
        onData: (chats) => state.copyWith(
          status: ChatsStatus.success,
          chats: chats,
        ),
        onError: (_, __) => state.copyWith(
          status: ChatsStatus.failure,
        ),
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(state.copyWith(status: ChatsStatus.failure));
      }
    }
  }

  Future<void> _onSignOut(
    ChatsSignOut event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _signOutUseCase();
      emit(state.copyWith(status: ChatsStatus.signedOut));
    } catch (e) {
      emit(state.copyWith(status: ChatsStatus.failure));
    }
  }
}
