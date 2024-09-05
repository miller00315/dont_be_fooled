part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class AddMessagesFromAppEvent extends ChatEvent {
  final List<ChatMessage> messages;
  final String title;
  final String userId;

  AddMessagesFromAppEvent({
    required this.messages,
    required this.title,
    required this.userId,
  });
}

final class SendMessageEvent extends ChatEvent {
  final ChatMessage message;

  SendMessageEvent({required this.message});
}

final class AddMessagesEvent extends ChatEvent {
  final List<ChatMessage> messages;

  AddMessagesEvent({required this.messages});
}

final class StartSession extends ChatEvent {
  final String userId;

  StartSession(this.userId);
}

final class PickImage extends ChatEvent {
  final ImageSource source;

  PickImage(this.source);
}

final class ErrorOnSendMEssageEvent extends ChatEvent {
  final dynamic e;

  ErrorOnSendMEssageEvent({required this.e});
}
