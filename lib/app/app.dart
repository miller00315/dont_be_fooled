import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/presentation/chat/chat.dart';
import 'package:dont_be_fooled/app/presentation/login/login.dart';
import 'package:dont_be_fooled/app/presentation/profile/profile.dart';
import 'package:dont_be_fooled/app/presentation/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  App({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const Chat(),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const Profile(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Receive WhatsApp Chat Plugin Demo',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      builder: (context, child) => BlocProvider<AppContextBloc>(
        create: (context) => GetIt.instance.get<AppContextBloc>(),
        child: child,
      ),
    );
  }
}
