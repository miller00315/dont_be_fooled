part of 'chat_message_bloc.dart';

final class ChatMessageState {
  final ChatMessage? message;

  ChatMessageState({this.message});

  factory ChatMessageState.initial() => ChatMessageState();

  ChatMessageState copyWith({
    ChatMessage? message,
  }) =>
      ChatMessageState(
        message: message ?? this.message,
      );
}
