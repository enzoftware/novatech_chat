import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novatech_chat/authentication/authentication.dart';
import 'package:novatech_chat/chat/chat.dart';
import 'package:novatech_chat/chats/chats.dart';
import 'package:novatech_chat/core/data/datasource/chat_remote_data_source.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/core/data/repository/chat_repository.dart';
import 'package:novatech_chat/l10n/l10n.dart';
import 'package:novatech_chat/new_chat/new_chat.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NolatechApp extends StatelessWidget {
  const NolatechApp({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
    super.key,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    final chatRemoteDataSource = ChatRemoteDataSource(
      firestore: _firestore,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GoogleSignIn>(
          create: (_) => _googleSignIn,
        ),
        RepositoryProvider<FirebaseAuth>(
          create: (_) => _firebaseAuth,
        ),
        RepositoryProvider<FirebaseFirestore>(
          create: (_) => _firestore,
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => FirebaseAuthenticationRepository(
            firebaseAuth: _firebaseAuth,
            googleSignIn: _googleSignIn,
            firestore: _firestore,
          ),
        ),
        RepositoryProvider<ChatRemoteDataSource>.value(
          value: chatRemoteDataSource,
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => FirebaseChatRepository(
            remoteDataSource: chatRemoteDataSource,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatsBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
        ],
        child: ShadApp(
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? '/authentication'
              : '/chats',
          routes: {
            '/authentication': (context) => const AuthenticationPage(),
            '/chats': (context) => const ChatsPage(),
            '/new_chat': (context) => const NewChatPage(),
            '/chat': (context) {
              final chatId =
                  ModalRoute.of(context)!.settings.arguments! as String;
              return ChatPage(chatId: chatId);
            },
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
