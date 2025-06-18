import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/register/register.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pushReplacementNamed('/chats');
          } else if (state.status == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: SnackBar(
                  content: Text(state.errorMessage ?? 'Registration failed'),
                  duration: const Duration(seconds: 2),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NameInput(),
                    const SizedBox(height: 8),
                    _EmailInput(),
                    const SizedBox(height: 8),
                    _PasswordInput(),
                    const SizedBox(height: 16),
                    _RegisterButton(),
                    if (state.status == FormzSubmissionStatus.failure)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorMessage ?? 'Registration failed',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RegisterTextInput extends StatelessWidget {
  const _RegisterTextInput({
    required this.label,
    required this.icon,
    required this.onChanged,
    required this.showError,
    required this.errorMessage,
  });

  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool showError;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShadInput(
          prefix: Icon(icon),
          placeholder: Text(label),
          onChanged: onChanged,
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return _RegisterTextInput(
          label: 'Name',
          icon: Icons.person,
          onChanged: (String name) =>
              context.read<RegisterBloc>().add(RegisterNameChanged(name)),
          showError: state.name.displayError != null,
          errorMessage: state.name.displayError?.message ?? '',
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return _RegisterTextInput(
          label: 'Email',
          icon: Icons.email,
          onChanged: (String email) =>
              context.read<RegisterBloc>().add(RegisterEmailChanged(email)),
          showError: state.email.displayError != null,
          errorMessage: state.email.displayError?.message ?? '',
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return _RegisterTextInput(
          label: 'Password',
          icon: Icons.lock,
          onChanged: (String password) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          showError: state.password.displayError != null,
          errorMessage: state.password.displayError?.message ?? '',
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return state.status == FormzSubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ShadButton(
                width: double.infinity,
                onPressed: state.isValid
                    ? () => context
                        .read<RegisterBloc>()
                        .add(const RegisterSubmitted())
                    : null,
                child: const Text('Register'),
              );
      },
    );
  }
}
