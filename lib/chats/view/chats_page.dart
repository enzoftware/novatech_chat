import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:novatech_chat/chats/chats.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ChatsBloc>(),
      child: const ChatsView(),
    );
  }
}

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
          ),
          body: const Placeholder(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
        );
      },
    );
  }
}
