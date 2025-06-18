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
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed('/chats');
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset('assets/nolatech.jpg'),
                  ),
                  const SizedBox(height: 32),
                  const _SignInForm(),
                  const Divider(),
                  ShadButton.outline(
                    width: double.infinity,
                    onPressed: () => context
                        .read<AuthenticationBloc>()
                        .add(const AuthenticationGoogleSignInRequested()),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.mail, size: 20),
                        SizedBox(width: 8),
                        Text('Sign in with Google'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  ShadButton.secondary(
                    width: double.infinity,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/register',
                    ),
                    child: const Text('Register here'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShadInput(
          placeholder: const Text('Email'),
          prefix: const Icon(Icons.email),
          onChanged: (value) => context
              .read<AuthenticationBloc>()
              .add(AuthenticationEmailChanged(value)),
        ),
        const SizedBox(height: 8),
        ShadInput(
          placeholder: const Text('Password'),
          prefix: const Icon(Icons.lock),
          obscureText: true,
          onChanged: (value) => context
              .read<AuthenticationBloc>()
              .add(AuthenticationPasswordChanged(value)),
        ),
        const SizedBox(height: 16),
        ShadButton(
          width: double.infinity,
          onPressed: () => context
              .read<AuthenticationBloc>()
              .add(const AuthenticationSignInRequested()),
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
