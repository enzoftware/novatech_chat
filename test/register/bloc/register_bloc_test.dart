import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novatech_chat/core/data/repository/authentication_repository.dart';
import 'package:novatech_chat/register/bloc/register_bloc.dart';
import 'package:novatech_chat/register/models/models.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });

  group('RegisterBloc', () {
    test('initial state is RegisterState', () {
      expect(
        RegisterBloc(authenticationRepository: authenticationRepository).state,
        const RegisterState(),
      );
    });

    group('RegisterEmailChanged', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits [invalid] when email is invalid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        act: (bloc) => bloc.add(const RegisterEmailChanged('invalid')),
        expect: () => [
          const RegisterState(
            email: EmailInput.dirty('invalid'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [valid] when email is valid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        seed: () => const RegisterState(
          name: NameInput.dirty('name'),
          password: PasswordInput.dirty('password123'),
        ),
        act: (bloc) => bloc.add(const RegisterEmailChanged('test@example.com')),
        expect: () => [
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            name: NameInput.dirty('name'),
            password: PasswordInput.dirty('password123'),
            isValid: true,
          ),
        ],
      );
    });

    group('RegisterPasswordChanged', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits [invalid] when password is invalid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        act: (bloc) => bloc.add(const RegisterPasswordChanged('pass')),
        expect: () => [
          const RegisterState(
            password: PasswordInput.dirty('pass'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [valid] when password is valid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        seed: () => const RegisterState(
          email: EmailInput.dirty('test@example.com'),
          name: NameInput.dirty('name'),
        ),
        act: (bloc) => bloc.add(const RegisterPasswordChanged('password123')),
        expect: () => [
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            name: NameInput.dirty('name'),
            password: PasswordInput.dirty('password123'),
            isValid: true,
          ),
        ],
      );
    });

    group('RegisterNameChanged', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits [invalid] when name is invalid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        act: (bloc) => bloc.add(const RegisterNameChanged('a')),
        expect: () => [
          const RegisterState(
            name: NameInput.dirty('a'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [valid] when name is valid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        seed: () => const RegisterState(
          email: EmailInput.dirty('test@example.com'),
          password: PasswordInput.dirty('password123'),
        ),
        act: (bloc) => bloc.add(const RegisterNameChanged('name')),
        expect: () => [
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            password: PasswordInput.dirty('password123'),
            name: NameInput.dirty('name'),
            isValid: true,
          ),
        ],
      );
    });

    group('RegisterSubmitted', () {
      blocTest<RegisterBloc, RegisterState>(
        'does nothing when form is invalid',
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        act: (bloc) => bloc.add(const RegisterSubmitted()),
        expect: () => const <RegisterState>[],
      );

      blocTest<RegisterBloc, RegisterState>(
        'calls createUserWithEmailAndPassword with correct values',
        setUp: () {
          when(
            () => authenticationRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            ),
          ).thenAnswer((_) async => throw UnimplementedError());
        },
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        seed: () => const RegisterState(
          email: EmailInput.dirty('test@example.com'),
          password: PasswordInput.dirty('password123'),
          name: NameInput.dirty('name'),
          isValid: true,
        ),
        act: (bloc) => bloc.add(const RegisterSubmitted()),
        verify: (_) {
          verify(
            () => authenticationRepository.createUserWithEmailAndPassword(
              email: 'test@example.com',
              password: 'password123',
              name: 'name',
            ),
          ).called(1);
        },
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [inProgress, success] when registration succeeds',
        setUp: () {
          when(
            () => authenticationRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            ),
          ).thenAnswer((_) async => throw UnimplementedError());
        },
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        seed: () => const RegisterState(
          email: EmailInput.dirty('test@example.com'),
          password: PasswordInput.dirty('password123'),
          name: NameInput.dirty('name'),
          isValid: true,
        ),
        act: (bloc) => bloc.add(const RegisterSubmitted()),
        expect: () => [
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            password: PasswordInput.dirty('password123'),
            name: NameInput.dirty('name'),
            status: FormzSubmissionStatus.inProgress,
            isValid: true,
          ),
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            password: PasswordInput.dirty('password123'),
            name: NameInput.dirty('name'),
            status: FormzSubmissionStatus.success,
            isValid: true,
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [inProgress, failure] when registration fails',
        setUp: () {
          when(
            () => authenticationRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            ),
          ).thenThrow(Exception('Registration failed'));
        },
        build: () =>
            RegisterBloc(authenticationRepository: authenticationRepository),
        seed: () => const RegisterState(
          email: EmailInput.dirty('test@example.com'),
          password: PasswordInput.dirty('password123'),
          name: NameInput.dirty('name'),
          isValid: true,
        ),
        act: (bloc) => bloc.add(const RegisterSubmitted()),
        expect: () => [
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            password: PasswordInput.dirty('password123'),
            name: NameInput.dirty('name'),
            status: FormzSubmissionStatus.inProgress,
            isValid: true,
          ),
          const RegisterState(
            email: EmailInput.dirty('test@example.com'),
            password: PasswordInput.dirty('password123'),
            name: NameInput.dirty('name'),
            status: FormzSubmissionStatus.failure,
            isValid: true,
            errorMessage: 'Exception: Registration failed',
          ),
        ],
      );
    });
  });
}
