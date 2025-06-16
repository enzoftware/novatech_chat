import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novatech_chat/authentication/authentication.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthenticationBloc>(),
      child: const AuthenticationView(),
    );
  }
}

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/nolatech.jpg'),
                ),
                const Divider(),
                ShadButton(
                  onPressed: () => context
                      .read<AuthenticationBloc>()
                      .add(const AuthenticationGoogleSignInRequested()),
                  child: const Text('Iniciar sesión con Google'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
