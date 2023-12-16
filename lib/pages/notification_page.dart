import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatNotificationService>(context);
    final List<ChatNotification> items = service.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Notificações'),
      ),
      body: ListView.builder(
        itemCount: service.itemsCount,
        itemBuilder: (context, index) => ListTile(
          onTap: () => service.remove(index),
          title: Text(items[index].title),
          subtitle: Text(items[index].body),
        ),
      ),
    );
  }
}
