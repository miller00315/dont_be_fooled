import 'dart:io';

import 'package:dont_be_fooled/app/application/chat_message_bloc/chat_message_bloc.dart';
import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  TextStyle _markDownStyle() => const TextStyle(
        color: Colors.white,
        fontSize: 16,
      );
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatMessageBloc>(
      create: (_) => GetIt.instance.get<ChatMessageBloc>()
        ..add(SetMessageEvent(message: message)),
      child: BlocBuilder<ChatMessageBloc, ChatMessageState>(
        builder: (context, state) {
          final message = state.message;

          if (message == null) {
            return const SizedBox.shrink();
          }

          final url = message.url;

          return url != null
              ? Align(
                  alignment: message.isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: FileImage(File(url)),
                      ),
                    ),
                  ),
                )
              : Align(
                  alignment: message.isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: message.isFromOtherApp
                            ? Colors.green.withOpacity(0.9)
                            : message.isUserMessage
                                ? Colors.blue.withOpacity(0.9)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: message.isUserMessage
                              ? const Radius.circular(12)
                              : const Radius.circular(0),
                          bottomRight: message.isUserMessage
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: message.isUserMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Markdown(
                            data: message.text,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                              textAlign: message.isUserMessage
                                  ? WrapAlignment.end
                                  : WrapAlignment.start,
                              p: _markDownStyle(),
                              h1: _markDownStyle(),
                              h2: _markDownStyle(),
                              h3: _markDownStyle(),
                              pPadding: const EdgeInsets.all(0),
                              tableBody: _markDownStyle(),
                              tableHead: _markDownStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
