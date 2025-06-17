import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novatech_chat/chats/chats.dart';
import 'package:novatech_chat/chats/widgets/chat_preview_item.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ChatsBloc>()..add(const ChatsGetUserChats()),
      child: const ChatsView(),
    );
  }
}

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsBloc, ChatsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ChatsStatus.signedOut) {
          Navigator.of(context).pushReplacementNamed('/authentication');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Chats',
            ),
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.plus),
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/new_chat',
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.logOut),
                onPressed: () => context.read<ChatsBloc>().add(
                      const ChatsSignOut(),
                    ),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state.status == ChatsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ChatsStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Something went wrong'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context
                            .read<ChatsBloc>()
                            .add(const ChatsGetUserChats()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state.chats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No chats yet'),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/new_chat',
                        ),
                        icon: const Icon(LucideIcons.plus),
                        label: const Text('Start a new chat'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ChatsBloc>().add(const ChatsGetUserChats());
                },
                child: ListView.builder(
                  itemCount: state.chats.length,
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];
                    return ChatPreviewItem(
                      chatPreview: chat,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
