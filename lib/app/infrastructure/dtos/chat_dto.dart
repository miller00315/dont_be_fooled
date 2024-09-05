import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:dont_be_fooled/app/external/plugin/models/message_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatDto {
  final String id;
  final String text;
  final DateTime createdAt;

  final String userId;
  final String userName;

  final bool isFromOtherApp;
  final String? groupId;
  final String? url;
  final bool isUserMessage;

  const ChatDto({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.isFromOtherApp,
    required this.isUserMessage,
    this.url,
    this.groupId,
  });

  factory ChatDto.fromDomain(ChatMessage message) => ChatDto(
        id: message.id,
        text: message.text,
        createdAt: message.createdAt,
        userId: message.userId,
        userName: message.userName,
        isFromOtherApp: message.isFromOtherApp,
        isUserMessage: message.isUserMessage,
        url: message.url,
      );

  factory ChatDto.fromMessageContent(MessageContent messageContent, String userId) => ChatDto(
        id: UniqueKey().toString(),
        text: messageContent.msg ?? '',
        createdAt: DateTime.now(),
        userId: userId,
        userName: messageContent.senderId ?? 'unknown',
        isFromOtherApp: true,
        isUserMessage: true,
      );

  @override
  String toString() {
    return '''
    {
      'role': ${isUserMessage ? 'user' : 'model'},
    }
    ''';
  }
}

extension ChatDtoX on ChatDto {
  ChatMessage toDomain() => ChatMessage(
        id: id,
        text: text,
        createdAt: createdAt,
        userId: userId,
        userName: userName,
        isFromOtherApp: isFromOtherApp,
        isUserMessage: isUserMessage,
        url: url,
      );

  Content toContent() => Content(
        parts: [Parts(text: text)],
        role: isUserMessage ? 'user' : 'model',
      );
}
