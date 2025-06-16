import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novatech_chat/authentication/authentication.dart';
import 'package:novatech_chat/chats/chats.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/domain/usecase/usecase.dart';
import 'package:novatech_chat/l10n/l10n.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NolatechApp extends StatelessWidget {
  const NolatechApp({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    super.key,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GoogleSignIn>(
          create: (_) => _googleSignIn,
        ),
        RepositoryProvider<FirebaseAuth>(
          create: (_) => _firebaseAuth,
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => FirebaseAuthenticationRepository(
            firebaseAuth: _firebaseAuth,
            googleSignIn: _googleSignIn,
          ),
        ),
        RepositoryProvider<GoogleSignInUseCase>(
          create: (context) => GoogleSignInUseCase(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              googleSignInUseCase: context.read<GoogleSignInUseCase>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatsBloc(),
          ),
        ],
        child: ShadApp(
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? '/authentication'
              : '/chats',
          routes: {
            '/authentication': (context) => const AuthenticationPage(),
            '/chats': (context) => const ChatsPage(),
          },
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadSlateColorScheme.light(),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
