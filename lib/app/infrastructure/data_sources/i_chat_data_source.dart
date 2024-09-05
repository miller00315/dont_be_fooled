import 'package:dont_be_fooled/app/external/plugin/models/chat_content.dart';
import 'package:dont_be_fooled/app/infrastructure/dtos/chat_dto.dart';
import 'package:image_picker/image_picker.dart';

abstract class IChatDataSource {
  Future<(Stream<List<ChatDto>>, Stream<ChatContent>)> startSession(
      String userId);

  Future<void> endSession();

  Future<void> sendMessage(ChatDto message, {bool shouldLogMessage = true});

  Future<String?> pickImage(ImageSource source);
}
