import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:dont_be_fooled/app/domain/facades/i_chat_facade.dart';
import 'package:dont_be_fooled/app/external/plugin/models/chat_content.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IChatFacade _chatFacade;

  StreamSubscription<List<ChatMessage>>? _chatSubscription;

  StreamSubscription<ChatContent>? _messageContentSubscription;

  @override
  close() async {
    await _messageContentSubscription?.cancel();
    await _chatSubscription?.cancel();

    await _chatFacade.endSession();

    await super.close();
  }

  ChatBloc(this._chatFacade) : super(ChatState.initial()) {
    on<ChatEvent>((event, emit) async {
      switch (event) {
        case AddMessagesFromAppEvent():
          {
            final formatedMessage = event.messages
                .map((e) => '${e.userName}: \n  ${e.text}')
                .join('\n\n');

            final joinedMessage =
                '**As mensagens abaixo pertencem a conversa "${event.title}":** \n\n $formatedMessage \n\n **Fim da conversa**';

            add(
              SendMessageEvent(
                message: ChatMessage(
                  id: UniqueKey().toString(),
                  text: joinedMessage,
                  createdAt: DateTime.now(),
                  userId: event.userId,
                  userName: 'Me',
                  isFromOtherApp: true,
                  isUserMessage: true,
                ),
              ),
            );

            break;
          }

        case SendMessageEvent():
          {
            final messages = [...state.messages, event.message];

            messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            emit(state.copyWith(
              isSendingMessage: true,
              messages: messages,
            ));

            await _chatFacade.sendMessage(event.message);

            emit(state.copyWith(isSendingMessage: false));

            break;
          }

        case StartSession():
          {
            await _chatSubscription?.cancel();

            final (a, b) = await _chatFacade.startSession(event.userId);

            _chatSubscription = a.listen((event) {
              add(
                AddMessagesEvent(messages: event),
              );
            })
              ..onError(
                (e, st) => add(ErrorOnSendMEssageEvent(e: e)),
              );

            _messageContentSubscription = b.listen((event) {
              final contextState = GetIt.instance.get<AppContextBloc>().state;

              if (contextState is AppContextStateAuthenticated) {
                final user = contextState.user;

                add(AddMessagesFromAppEvent(
                  messages: event.messages
                      .map(
                        (e) => ChatMessage(
                          id: UniqueKey().toString(),
                          text: e.msg ?? 'unknow',
                          createdAt: DateTime.now(),
                          userId: user.id,
                          userName: e.senderId ?? 'unknow',
                          isFromOtherApp: true,
                          isUserMessage: true,
                        ),
                      )
                      .toList(),
                  title: event.chatName,
                  userId: user.id,
                ));
              }
            });

            emit(state.copyWith(isSendingMessage: true));

            await _chatFacade.sendMessage(
              ChatMessage(
                id: UniqueKey().toString(),
                text: const String.fromEnvironment('inital_prompt'),
                createdAt: DateTime.now(),
                userId: event.userId,
                userName: 'Me',
                isFromOtherApp: false,
                isUserMessage: true,
              ),
              shouldLogMessage: false,
            );

            break;
          }
        case AddMessagesEvent():
          {
            event.messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            emit(
              state.copyWith(
                isSendingMessage: false,
                messages: event.messages,
              ),
            );

            break;
          }
        case PickImage():
          {
            final contextState = GetIt.instance.get<AppContextBloc>().state;

            if (contextState is AppContextStateAuthenticated) {
              final user = contextState.user;

              final res = await _chatFacade.pickImage(event.source);

              if (res != null) {
                emit(state.copyWith(isSendingMessage: true));

                add(
                  SendMessageEvent(
                    message: ChatMessage(
                      id: UniqueKey().toString(),
                      text: '',
                      createdAt: DateTime.now(),
                      userId: user.id,
                      userName: 'Me',
                      isFromOtherApp: false,
                      isUserMessage: true,
                      url: res,
                    ),
                  ),
                );
              }
            }

            break;
          }
        case ErrorOnSendMEssageEvent():
          {
            emit(state.copyWith(isSendingMessage: false));

            break;
          }
      }
    });
  }
}
