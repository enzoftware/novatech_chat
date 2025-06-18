part of 'new_chat_bloc.dart';

sealed class NewChatEvent extends Equatable {
  const NewChatEvent();

  @override
  List<Object> get props => [];
}

class NewChatGetUsers extends NewChatEvent {
  const NewChatGetUsers();

  @override
  List<Object> get props => [];
}

class NewChatStartChatWithUser extends NewChatEvent {
  const NewChatStartChatWithUser(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}
