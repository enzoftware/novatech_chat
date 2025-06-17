import 'package:flutter/material.dart';
import 'package:novatech_chat/core/domain/models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatPreviewItem extends StatelessWidget {
  const ChatPreviewItem({
    required this.chatPreview,
    super.key,
  });

  final ChatPreview chatPreview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        '/chat/:chatId',
        arguments: chatPreview.id,
      ),
      leading: const ShadAvatar(
        'assets/images/avatar_placeholder.png',
      ),
      title: Text(
        chatPreview.participants.last,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        chatPreview.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chatPreview.unreadCount > 0)
            ShadBadge(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                chatPreview.unreadCount.toString(),
                style: theme.textTheme.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}
