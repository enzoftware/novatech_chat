part of 'new_chat_bloc.dart';

enum NewChatStatus {
  initial,
  loading,
  success,
  failure,
}

class NewChatState extends Equatable {
  const NewChatState({
    this.status = NewChatStatus.initial,
    this.users = const [],
  });

  final NewChatStatus status;
  final List<ChatUser> users;

  NewChatState copyWith({
    NewChatStatus? status,
    List<ChatUser>? users,
  }) {
    return NewChatState(
      status: status ?? this.status,
      users: users ?? this.users,
    );
  }

  @override
  List<Object> get props => [status, users];
}
