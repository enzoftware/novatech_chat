part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppAuthenticationChanged extends AppEvent {
  const AppAuthenticationChanged(this.user);

  final User? user;

  @override
  List<Object?> get props => [user];
}
