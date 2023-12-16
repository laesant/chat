import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    ChatMessage(
        id: '1',
        text: 'Bom dia',
        createdAt: DateTime.now(),
        userId: '123',
        userName: 'Vitoria',
        userImageUrl: 'assets/images/avatar.png'),
    ChatMessage(
        id: '2',
        text: 'Olá, teremos reuniao hoje?',
        createdAt: DateTime.now(),
        userId: '1',
        userName: 'Luana',
        userImageUrl: 'assets/images/avatar.png'),
    ChatMessage(
        id: '3',
        text: 'Sim. Pode ser agora!',
        createdAt: DateTime.now(),
        userId: '123',
        userName: 'Vitoria',
        userImageUrl: 'assets/images/avatar.png')
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    _controller!.add(_msgs.reversed.toList());
  });

  @override
  Stream<List<ChatMessage>> messagesStream() => _msgsStream;

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final msg = ChatMessage(
        id: Random().nextDouble().toString(),
        text: text,
        createdAt: DateTime.now(),
        userId: user.id,
        userName: user.name,
        userImageUrl: user.photoUrl);
    _msgs.add(msg);
    _controller?.add(_msgs.reversed.toList());
    return msg;
  }
}
