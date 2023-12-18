import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() =>
      const Stream<List<ChatMessage>>.empty();

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.photoUrl,
    });

    final doc = await docRef.get();
    final data = doc.data()!;

    return ChatMessage(
        id: doc.id,
        text: data['text'],
        createdAt: DateTime.parse(data['createdAt']),
        userId: data['userId'],
        userName: data['userName'],
        userImageUrl: data['userImageUrl']);
  }
}
