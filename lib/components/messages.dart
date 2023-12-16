import 'package:chat/components/message_bubble.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder<List<ChatMessage>>(
        stream: ChatService().messagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Sem Menssagens. Vamos conversar?'),
            );
          } else {
            final msgs = snapshot.data as List<ChatMessage>;
            return ListView.builder(
                reverse: true,
                itemCount: msgs.length,
                padding: const EdgeInsets.only(bottom: 8),
                itemBuilder: (context, index) {
                  final msg = msgs[index];
                  return MessageBubble(
                    key: ValueKey(msg.id),
                    message: msg,
                    belongsToCurrentUser: currentUser?.id == msg.userId,
                  );
                });
          }
        });
  }
}
