import 'package:bloc/bloc.dart';
import 'package:dont_be_fooled/app/domain/entities/chat_message.dart';
import 'package:meta/meta.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  ChatMessageBloc() : super(ChatMessageState.initial()) {
    on<ChatMessageEvent>((event, emit) {
      switch (event) {
        case SetMessageEvent():
          {
            emit(state.copyWith(message: event.message));

            break;
          }
      }
    });
  }
}
