import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:dont_be_fooled/app/presentation/chat/widgets/chat_header.dart';
import 'package:dont_be_fooled/app/presentation/chat/widgets/messages.dart';
import 'package:dont_be_fooled/app/presentation/chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

enum MenuOptions {
  getMessagesFromWhatsApp,
}

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  ChatBodyState createState() => ChatBodyState();
}

class ChatBodyState extends State<ChatBody> {
  List<ChatMessage> chats = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 35),
              child: Column(
                children: [
                  Expanded(
                    child: Messages(),
                  ),
                  NewMessage(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 16,
              left: 16,
              child: ChatHeader(),
            ),
          ],
        ),
      ),
    );
  }
}
