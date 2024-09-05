import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Expanded(child: Placeholder()),
          SizedBox(
            height: 50,
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Theme.of(context).primaryColor),
              ),
              onPressed: () => context.read<AppContextBloc>().add(
                    UnauthenticateEvent(),
                  ),
              child: const Text(
                'Sair',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: .03,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
