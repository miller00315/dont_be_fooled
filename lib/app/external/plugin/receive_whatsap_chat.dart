import 'dart:async';
import 'dart:io';

import 'package:dont_be_fooled/app/external/plugin/chat_analyzer/chat_analyzer.dart';
import 'package:dont_be_fooled/app/external/plugin/models/chat_content.dart';
import 'package:dont_be_fooled/app/external/plugin/share/share.dart';
import 'package:flutter/services.dart';

class ReceiveWhatsAppChat {
  bool _allowReceiveWithMedia = false;

  static const MethodChannel methodChannel =
      MethodChannel('com.whatsapp.chat/chat');

  static const stream = EventChannel('plugins.flutter.io/receiveshare');

  StreamSubscription? _shareReceiveSubscription;

  StreamController<ChatContent>? _controller;

  Stream<ChatContent>? get chatContentStream => _controller?.stream;

  Future<void> init() async {
    await _enabelShareReceiving();
  }

  Future<void> _enabelShareReceiving() async {
    await _shareReceiveSubscription?.cancel();

    await _controller?.close();

    if (Platform.isAndroid) {
      _shareReceiveSubscription = stream
          .receiveBroadcastStream()
          .listen(_receiveSharadeInternalAndroid);

      _controller = StreamController<ChatContent>();
    }
  }

  void _receiveSharadeInternalAndroid(dynamic received) async {
    await _receiveShareAndroid(Share.fromReceived(received));
  }

  /// Enable [_allowReceiveWithMedia] to save the images paths
  void enableReceivingChatWithMedia() {
    _allowReceiveWithMedia = true;
  }

  /// Disable [shareReceiveEnabled]
  void disableReceivingChatWithMedia() {
    _allowReceiveWithMedia = false;
  }

  Future<void> _disableShareReceiving() async {
    if (_shareReceiveSubscription != null) {
      await _shareReceiveSubscription!.cancel();

      await _controller?.close();

      _shareReceiveSubscription = null;

      _controller = null;
    }
  }

  Future<void> _receiveShareAndroid(Share shared) async {
    final url = shared.shares[0].path;

    if (!isWhatsAppChatUrl(url)) throw Exception("Not a WhatsApp chat url");

    List<String> chat = List<String>.from(await methodChannel
        .invokeMethod("analyze", <String, dynamic>{"data": url}));

    _submitContent(ChatAnalyzer.analyze(chat, _getImagePaths(shared)));
  }

  _submitContent(ChatContent content) {
    _controller?.add(content);
  }

  Future<void> finish() async {
    await _disableShareReceiving();
  }

  List<String>? _getImagePaths(Share shared) {
    if (!_allowReceiveWithMedia) return null;
    List<String> ret = [];
    for (Share file in shared.shares) {
      if (file.path.endsWith(".jpg")) {
        ret.add(file.path);
      }
    }
    return ret;
  }

  bool isWhatsAppChatUrl(String url) {
    if (Platform.isAndroid) {
      return url
          .startsWith("content://com.whatsapp.provider.media/export_chat/");
    } else if (Platform.isIOS) {
      return url
          .startsWith("file:///private/var/mobile/Containers/Shared/AppGroup/");
    }
    return false;
  }
}
