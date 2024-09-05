import 'package:dont_be_fooled/app/application/chat_bloc/chat_bloc.dart';
import 'package:dont_be_fooled/app/presentation/chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Messages extends StatefulWidget {
  const Messages({
    super.key,
  });

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late ScrollController _controller;
  bool _showDownardButton = false;
  bool _autoScrolling = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(checkScrollPosition);
    _controller.dispose();
    super.dispose();
  }

  void checkScrollPosition() async {
    if (_autoScrolling) return;

    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_showDownardButton) {
        setState(() {
          _showDownardButton = false;
        });
      }
    } else {
      if (!_showDownardButton) {
        setState(() {
          _showDownardButton = true;
        });
      }
    }
  }

  void _goToEnd() {
    setState(() {
      _showDownardButton = false;
    });

    _autoScrolling = true;

    _controller
        .animateTo(
          _controller.position.minScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
        .then((value) => _autoScrolling = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) => previous.messages != current.messages,
      buildWhen: (previous, current) => previous.messages != current.messages,
      listener: (context, state) => _goToEnd(),
      builder: (context, state) => Stack(
        children: [
          ListView.separated(
            reverse: true,
            controller: _controller,
            padding: const EdgeInsets.all(16),
            itemBuilder: (ctx, i) => i == state.messages.length
                ? const SizedBox(
                    height: 40,
                  )
                : MessageBubble(
                    message: state.messages[i],
                    key: ValueKey(
                      state.messages[i],
                    ),
                  ),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: state.messages.length + 1,
          ),
          if (_showDownardButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: _goToEnd,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(.7),
                  ),
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.white.withOpacity(.7),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
