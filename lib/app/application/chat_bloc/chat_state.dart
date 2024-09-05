part of 'chat_bloc.dart';

@immutable
class ChatState {
  final List<ChatMessage> messages;
  final bool isSendingMessage;

  const ChatState({required this.isSendingMessage, required this.messages});

  factory ChatState.initial() => const ChatState(
        messages: [],
        isSendingMessage: false,
      );

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSendingMessage,
  }) {
    isSendingMessage ??= this.isSendingMessage;

    return ChatState(
      messages: messages ?? this.messages,
      isSendingMessage: isSendingMessage,
    );
  }

  @override
  String toString() => '''
      {
        "messages" : $messages
        "isSendingMessage": $isSendingMessage
      }
    ''';
}
