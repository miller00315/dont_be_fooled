import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/presentation/profile/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppContextBloc, AppContextState>(
      listener: (_, state) {
        switch (state) {
          case AppContextStateInitial():
          case AppContextStateUnautheticated():
            context.pushReplacement('/');
            break;
          case AppContextStateAuthenticated():
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const SizedBox.shrink(),
          actions: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).primaryColor.withOpacity(.8),
                size: 45,
              ),
            )
          ],
        ),
        body: BlocBuilder<AppContextBloc, AppContextState>(
          builder: (context, state) {
            switch (state) {
              case AppContextStateInitial():
              case AppContextStateUnautheticated():
                return const Placeholder();
              case AppContextStateAuthenticated():
                return const ProfileBody();
            }
          },
        ),
      ),
    );
  }
}
