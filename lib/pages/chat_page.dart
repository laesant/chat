import 'package:chat/components/messages.dart';
import 'package:chat/components/new_message.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Lae Chat'), actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
                icon: const Icon(Icons.more_vert),
                items: const [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text("Sair")
                      ],
                    ),
                  )
                ],
                onChanged: (value) {
                  if (value == 'logout') {
                    AuthService().signOut();
                  }
                }),
          )
        ]),
        body: const SafeArea(
          child: Column(children: [
            Expanded(child: Messages()),
            NewMessage(),
          ]),
        ));
  }
}
