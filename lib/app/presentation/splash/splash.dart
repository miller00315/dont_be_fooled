import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/application/splash_bloc/splash_bloc.dart';
import 'package:dont_be_fooled/app/presentation/splash/widgets/splash_body.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppContextBloc, AppContextState>(
      listener: (_, state) {
        switch (state) {
          case AppContextStateInitial():
            break;
          case AppContextStateUnautheticated():
            context.pushReplacement('/Login');
            break;
          case AppContextStateAuthenticated():
            context.pushReplacement('/chat');
            break;
        }
      },
      child: BlocProvider<SplashBloc>(
        create: (_) => GetIt.instance.get<SplashBloc>(),
        child: const SplashBody(),
      ),
    );
  }
}
