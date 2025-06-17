import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';

import 'package:novatech_chat/new_chat/new_chat.dart';
import 'package:novatech_chat/new_chat/widgets/user_chat_item.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewChatBloc(
        chatRepository: context.read<ChatRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      )..add(const NewChatGetUsers()),
      child: const NewChatView(),
    );
  }
}

class NewChatView extends StatelessWidget {
  const NewChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: BlocConsumer<NewChatBloc, NewChatState>(
        listener: (context, state) {
          if (state.status == NewChatStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to load users'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == NewChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NewChatStatus.success) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserChatItem(
                  chatUser: user,
                  onTap: () {
                    context.read<NewChatBloc>().add(
                          NewChatStartChatWithUser(user.id),
                        );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
