part of 'chat_message_bloc.dart';

@immutable
sealed class ChatMessageEvent {}

final class SetMessageEvent extends ChatMessageEvent {
  final ChatMessage message;

  SetMessageEvent({required this.message});
}
