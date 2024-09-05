import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/application/auth/login_bloc/login_bloc.dart';
import 'package:dont_be_fooled/app/presentation/login/widgets/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppContextBloc, AppContextState>(
      listener: (_, state) {
        switch (state) {
          case AppContextStateInitial():
          case AppContextStateUnautheticated():
            break;
          case AppContextStateAuthenticated():
            context.pushReplacement('/chat');
            break;
        }
      },
      child: BlocProvider<LoginBloc>(
        create: (context) => GetIt.instance.get<LoginBloc>(),
        child: const LoginBody(),
      ),
    );
  }
}
