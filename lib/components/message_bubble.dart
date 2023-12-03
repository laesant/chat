import 'dart:io';

import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool belongsToCurrentUser;

  const MessageBubble(
      {super.key, required this.message, required this.belongsToCurrentUser});

  Widget _showUserImage(String imageUrl, BuildContext context) {
    ImageProvider? provider;
    if (imageUrl.startsWith('http')) {
      provider = NetworkImage(imageUrl);
    } else if (imageUrl.startsWith('file')) {
      provider = FileImage(File(imageUrl));
    } else {
      provider = AssetImage(imageUrl);
    }

    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: 15,
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: belongsToCurrentUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!belongsToCurrentUser)
          Row(
            children: [
              const SizedBox(width: 8),
              _showUserImage(message.userImageUrl, context)
            ],
          ),
        Container(
            constraints: const BoxConstraints(maxWidth: 180),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                color: belongsToCurrentUser
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: belongsToCurrentUser
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  topRight: belongsToCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!belongsToCurrentUser)
                  Text(
                    message.userName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 2),
                  ),
                const SizedBox(height: 4),
                Text(message.text),
              ],
            )),
      ],
    );
  }
}
