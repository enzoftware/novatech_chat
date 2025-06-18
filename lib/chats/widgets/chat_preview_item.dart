import 'package:flutter/material.dart';
import 'package:novatech_chat/core/domain/usecase/get_user_chats_use_case.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatPreviewItem extends StatelessWidget {
  const ChatPreviewItem({
    required this.chatUi,
    super.key,
  });

  final ChatPreviewUi chatUi;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        '/chat',
        arguments: chatUi.chatPreview.id,
      ),
      leading: chatUi.sender.photoUrl != null
          ? ShadAvatar(
              chatUi.sender.photoUrl,
            )
          : const SizedBox(),
      title: Text(
        chatUi.sender.displayName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        chatUi.chatPreview.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
