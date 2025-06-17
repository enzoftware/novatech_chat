part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.unauthenticated,
    this.user,
  });

  final AppStatus status;
  final User? user;

  AppState copyWith({
    AppStatus? status,
    User? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
