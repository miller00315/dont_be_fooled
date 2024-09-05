import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:dont_be_fooled/app/external/plugin/models/chat_content.dart';
import 'package:image_picker/image_picker.dart';

abstract class IChatFacade {
  Future<(Stream<List<ChatMessage>>, Stream<ChatContent>)> startSession(
      String userId);
  Future<void> endSession();
  Future<void> sendMessage(
    ChatMessage message, {
    bool shouldLogMessage = true,
  });

  Future<String?> pickImage(ImageSource source);
}
