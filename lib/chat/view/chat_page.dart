import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:novatech_chat/chat/chat.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({required this.chatId, super.key});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
            actions: [
              IconButton(
                icon: const Icon(Icons.video_call),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
