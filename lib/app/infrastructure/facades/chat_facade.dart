import 'dart:async';

import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:dont_be_fooled/app/domain/facades/i_chat_facade.dart';
import 'package:dont_be_fooled/app/external/plugin/models/chat_content.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_chat_data_source.dart';
import 'package:dont_be_fooled/app/infrastructure/dtos/chat_dto.dart';
import 'package:image_picker/image_picker.dart';

class ChatFacade implements IChatFacade {
  final IChatDataSource chatDataSource;

  ChatFacade(this.chatDataSource);

  @override
  Future<void> endSession() async {
    try {
      chatDataSource.endSession();
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  @override
  Future<(Stream<List<ChatMessage>>, Stream<ChatContent>)> startSession(
      String userId) async {
    final (a, b) = await chatDataSource.startSession(userId);

    return (
      a.transform(
        StreamTransformer<List<ChatDto>, List<ChatMessage>>.fromHandlers(
          handleData:
              (List<ChatDto> value, EventSink<List<ChatMessage>> sink) =>
                  sink.add(value.map((e) => e.toDomain()).toList()),
          handleError: (error, stackTrace, sink) => sink.addError(error),
        ),
      ),
      b
    );
  }

  @override
  Future<void> sendMessage(
    ChatMessage message, {
    bool shouldLogMessage = true,
  }) async {
    try {
      await chatDataSource.sendMessage(
        ChatDto.fromDomain(message),
        shouldLogMessage: shouldLogMessage,
      );
    } catch (e, st) {
      print(e);
      print(st);
    }
  }

  @override
  Future<String?> pickImage(ImageSource source) async {
    try {
      final res = await chatDataSource.pickImage(source);

      return res;
    } catch (e, st) {
      print(e);
      print(st);
      return null;
    }
  }
}
