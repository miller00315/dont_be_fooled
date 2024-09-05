import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/application/chat_bloc/chat_bloc.dart';
import 'package:dont_be_fooled/app/presentation/chat/widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppContextBloc, AppContextState>(
      builder: (_, state) {
        switch (state) {
          case AppContextStateInitial():
            return const Material(
              child: Placeholder(),
            );
          case AppContextStateUnautheticated():
            return const Material(
              child: Placeholder(),
            );
          case AppContextStateAuthenticated():
            return BlocProvider<ChatBloc>(
              create: (_) => GetIt.instance.get<ChatBloc>()
                ..add(
                  StartSession(state.user.id),
                ),
              child: const ChatBody(),
            );
        }
      },
    );
  }
}
