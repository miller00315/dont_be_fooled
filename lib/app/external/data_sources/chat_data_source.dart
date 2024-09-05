import 'dart:async';
import 'dart:io';

import 'package:dont_be_fooled/app/external/plugin/models/chat_content.dart';
import 'package:dont_be_fooled/app/external/plugin/receive_whatsap_chat.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_chat_data_source.dart';
import 'package:dont_be_fooled/app/infrastructure/dtos/chat_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatDataSource implements IChatDataSource {
  final ImagePicker _picker = ImagePicker();

  StreamController<List<ChatDto>>? _streamController;

  StreamSubscription<ChatContent>? _chatSubscription;

  final List<ChatDto> _messages = [];

  final Gemini _gemini;

  final ReceiveWhatsAppChat _receiveWhatsAppChat;

  ChatDataSource(
    this._gemini,
    this._receiveWhatsAppChat,
  );

  @override
  Future<void> endSession() async {
    await _streamController?.close();

    await _chatSubscription?.cancel();

    await _receiveWhatsAppChat.finish();

    _streamController = null;
  }

  @override
  Future<(Stream<List<ChatDto>>, Stream<ChatContent>)> startSession(
      String userId) async {
    if (_streamController != null) {
      await _streamController?.close();

      _streamController = null;
    }

    await _receiveWhatsAppChat.init();

    _streamController = StreamController<List<ChatDto>>();

    final subscription = _receiveWhatsAppChat.chatContentStream!;

    return (_streamController!.stream, subscription);
  }

  @override
  Future<void> sendMessage(
    ChatDto message, {
    bool shouldLogMessage = true,
  }) async {
    _messages.add(message);

    if (message.url != null) {
      await sendImageMessage(message);

      return;
    }

    try {
      final res =
          await _gemini.chat(_messages.map((e) => e.toContent()).toList());

      final content = res?.content;

      if (content != null) {
        final newMessages = content.parts
            ?.map(
              (e) => ChatDto(
                id: UniqueKey().toString(),
                text: e.text ?? 'Mensagem sem conteúdo ignore',
                createdAt: DateTime.now(),
                userId: 'gemini',
                userName: 'João',
                isFromOtherApp: false,
                isUserMessage: false,
              ),
            )
            .where((element) => element.text.trim().isNotEmpty)
            .toList();

        if (newMessages != null) {
          _messages.addAll(newMessages);

          _streamController?.add(_messages.sublist(1));
        }
      }
    } catch (e, st) {
      print(e);
      print(st);

      _streamController?.addError(e, st);
    }
  }

  @override
  Future<String?> pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);

    if (image != null) {
      return image.path;
    }

    return null;
  }

  Future<void> sendImageMessage(ChatDto message) async {
    final url = message.url;

    if (url != null) {
      try {
        final res = await _gemini.textAndImage(
          text: const String.fromEnvironment('image_prompt'),
          images: [File(message.url!).readAsBytesSync()],
        );

        final content = res?.content;

        if (content != null) {
          final newMessages = content.parts
              ?.map(
                (e) => ChatDto(
                  id: UniqueKey().toString(),
                  text: e.text ??
                      'Esta é uma mensagem de imagem, pode ignorar no contexto geral das mensagens',
                  createdAt: DateTime.now(),
                  userId: 'gemini',
                  userName: 'João',
                  isFromOtherApp: false,
                  isUserMessage: false,
                ),
              )
              .where((element) => element.text.trim().isNotEmpty)
              .toList();

          if (newMessages != null) {
            _messages.addAll(newMessages);

            _streamController?.add(_messages.sublist(1));
          }
        }
      } catch (e, st) {
        _streamController?.addError(e, st);
      }
    }
  }
}
