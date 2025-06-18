import 'package:flutter/material.dart';
import 'package:novatech_chat/core/domain/models/chat_user.dart';

class UserChatItem extends StatelessWidget {
  const UserChatItem({
    required this.chatUser,
    this.onTap,
    super.key,
  });

  final ChatUser chatUser;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 24,
      ),
      title: Text(
        chatUser.displayName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(onPressed: onTap, icon: const Icon(Icons.message)),
    );
  }
}
