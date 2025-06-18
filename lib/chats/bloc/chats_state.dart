part of 'chats_bloc.dart';

enum ChatsStatus {
  initial,
  loading,
  success,
  failure,
  signedOut,
}

class ChatsState extends Equatable {
  const ChatsState({
    this.status = ChatsStatus.initial,
    this.chats = const [],
    this.errorMessage,
  });

  final ChatsStatus status;
  final List<ChatPreviewUi> chats;
  final String? errorMessage;

  ChatsState copyWith({
    ChatsStatus? status,
    List<ChatPreviewUi>? chats,
    String? errorMessage,
  }) {
    return ChatsState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, chats, errorMessage ?? ''];
}
