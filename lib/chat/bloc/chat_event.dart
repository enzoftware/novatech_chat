part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatStarted extends ChatEvent {
  const ChatStarted(this.chatId);

  final String chatId;

  @override
  List<Object> get props => [chatId];
}

class ChatMessageSent extends ChatEvent {
  const ChatMessageSent({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class ChatMessagesReceived extends ChatEvent {
  const ChatMessagesReceived(this.messages);

  final List<Message> messages;

  @override
  List<Object> get props => [messages];
}
