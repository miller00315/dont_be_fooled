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
      print(url);

      try {
        final res = await _gemini.textAndImage(
          text: "Verifique se existe algo ilegal ou abusivo na imagem enviada. \\n Verifique se na imagem existe um contrato com cláusulas abusivas de acordo com a legislação brasileira, solicitação de transferências cancárias (TED, ou pix) ilegais, charlatanismo, promessa milagrosas, falsa lojas onlines, violações de diretos do trablahador, violação de direitos civis, violaçãos de direitos da criança e do adolescentes, violações dos direitos humanos ou qualquer outra violação legal.\\n Também verifique se existe incitação a violência, misogênia, violação dos direitos da população LGBTQIAPN+, notícias falsa ou negacionismo, jogos de azar, apologia ao tráfico de drogas, venda de produtos ilícitos, incitação a suicídio.\\n Também verifique se na imgaem a um link para endereço maliciosso, link para um site de conteúdo adulto ou perigoso, falso link para site de banco ou instituição do governo, link para conteúdo com apologia ao racismo, violção do diretos de minorias ou quaisquer violação a direitos humanos.\\n Caso a imagem contenha um qr code verifique se esse qrcode aponta para site malicooso, site om notícias falsas ou negacionismo, conteúdo ilegal ou falso, falso link pra site de banco ou instituição do governo, site com notícias falsas ou negacionismo, arquivo que possa danificar ou prejudicar dispositivos, jogo de azar no brasil é.",
          images: [File(message.url!).readAsBytesSync()]
        );

        print(res);

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
