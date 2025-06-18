import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/core/domain/models/models.dart';
import 'package:novatech_chat/core/domain/usecase/create_new_chat_use_case.dart';
import 'package:novatech_chat/core/domain/usecase/get_chat_users_use_case.dart';
import 'package:novatech_chat/core/domain/usecase/get_current_user_use_case.dart';

part 'new_chat_event.dart';
part 'new_chat_state.dart';

class NewChatBloc extends Bloc<NewChatEvent, NewChatState> {
  NewChatBloc({
    required ChatRepository chatRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _getChatUsersUseCase = GetChatUsersUseCase(
          chatRepository: chatRepository,
          authenticationRepository: authenticationRepository,
        ),
        _createNewChatUseCase = CreateNewChatUseCase(
          chatRepository: chatRepository,
          authenticationRepository: authenticationRepository,
        ),
        _getCurrentUserUseCase = GetCurrentUserUseCase(
          authenticationRepository: authenticationRepository,
        ),
        super(const NewChatState()) {
    on<NewChatGetUsers>(_onGetUsers);
    on<NewChatStartChatWithUser>(_onStartChatWithUser);
  }

  final GetChatUsersUseCase _getChatUsersUseCase;
  final CreateNewChatUseCase _createNewChatUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> _onGetUsers(
    NewChatGetUsers event,
    Emitter<NewChatState> emit,
  ) async {
    try {
      emit(state.copyWith(status: NewChatStatus.loading));
      final currentUser = await _getCurrentUserUseCase();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      final users = await _getChatUsersUseCase();
      emit(state.copyWith(status: NewChatStatus.success, users: users));
    } catch (e) {
      emit(
        state.copyWith(
          status: NewChatStatus.failure,
        ),
      );
    }
  }

  Future<void> _onStartChatWithUser(
    NewChatStartChatWithUser event,
    Emitter<NewChatState> emit,
  ) async {
    try {
      final currentUser = await _getCurrentUserUseCase();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      await _createNewChatUseCase(otherUserId: event.userId);
      emit(state.copyWith(status: NewChatStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: NewChatStatus.failure,
        ),
      );
    }
  }
}
