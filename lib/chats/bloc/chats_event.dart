part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class ChatsGetUserChats extends ChatsEvent {
  const ChatsGetUserChats();

  @override
  List<Object> get props => [];
}

class ChatsSignOut extends ChatsEvent {
  const ChatsSignOut();

  @override
  List<Object> get props => [];
}
