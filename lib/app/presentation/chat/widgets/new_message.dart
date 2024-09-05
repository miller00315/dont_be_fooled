import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/application/chat_bloc/chat_bloc.dart';
import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  late TextEditingController _messageController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _messageController = TextEditingController();
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  dispose() {
    super.dispose();

    _focusNode.unfocus();

    _focusNode.dispose();

    _messageController.dispose();
  }

  Future<void> _sendMessage() async {
    final contextState = context.read<AppContextBloc>().state;

    final message = _message.trim();

    if (contextState is AppContextStateAuthenticated && message.isNotEmpty) {
      context.read<ChatBloc>().add(
            SendMessageEvent(
              message: ChatMessage(
                id: UniqueKey().toString(),
                text: message,
                createdAt: DateTime.now(),
                userId: contextState.user.id,
                userName: 'Me',
                isFromOtherApp: false,
                isUserMessage: true,
              ),
            ),
          );
    }

    _messageController.clear();

    _message = '';
  }

  Future<void> _showGetMessagesModal() => showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor.withOpacity(.7),
                      size: 45,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          try {
                            LaunchApp.openApp(
                              androidPackageName: 'com.whatsapp',
                              iosUrlScheme: 'whatsapp://app',
                              appStoreLink:
                                  'https://apps.apple.com/us/app/whatsapp-messenger/id310633997',
                            ).then((value) => Navigator.of(context).pop());
                          } catch (e, st) {
                            print(e);
                            print(st);

                            Navigator.of(context).pop();
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_rounded,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Whats app',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Future<void> _showGetImageModal() => showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        builder: (_) => Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor.withOpacity(.7),
                      size: 45,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ChatBloc>()
                              .add(PickImage(ImageSource.camera));

                          Navigator.of(context).pop();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Câmera',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ChatBloc>()
                              .add(PickImage(ImageSource.gallery));

                          Navigator.of(context).pop();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Galeria',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(.7),
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Entre com a mensagem',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColor.withOpacity(.7),
                          fontSize: 14,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      controller: _messageController,
                      onChanged: (msg) => setState(() => _message = msg),
                      onSubmitted: (_) {
                        if (_message.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (previous, current) =>
                        previous.isSendingMessage != current.isSendingMessage,
                    builder: (context, state) => state.isSendingMessage
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: _showGetImageModal,
                            icon: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              size: 35,
                            ),
                          ),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (previous, current) =>
                        previous.isSendingMessage != current.isSendingMessage,
                    builder: (context, state) => state.isSendingMessage
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: _showGetMessagesModal,
                            icon: Icon(
                              Icons.question_answer_rounded,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              size: 35,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (previous, current) =>
                previous.isSendingMessage != current.isSendingMessage,
            builder: (context, state) => state.isSendingMessage
                ? Container(
                    height: 45,
                    width: 45,
                    padding: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(),
                  )
                : IconButton(
                    onPressed: () => _sendMessage(),
                    icon: Icon(
                      Icons.send_rounded,
                      size: 45,
                      color: Theme.of(context).primaryColor.withOpacity(.7),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
