class ChatMessage {
  final String id;
  final String text;
  final DateTime createdAt;

  final String userId;
  final String userName;

  final bool isFromOtherApp;
  final String? groupId;
  final String? url;

  final bool isUserMessage;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.isFromOtherApp,
    required this.isUserMessage,
    this.groupId,
    this.url,
  });

  @override
  String toString() => '''
  {
    "id": $id,
    "text": $text,
    "createdAt": $createdAt,
    "userId": $userId,
    "userName": $userName,
    "isFromOtherApp": $isFromOtherApp,
    "isUserMessage": $isUserMessage,
  }
  ''';
}
