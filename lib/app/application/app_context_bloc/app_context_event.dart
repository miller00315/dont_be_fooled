part of 'app_context_bloc.dart';

@immutable
sealed class AppContextEvent {}

final class AuthenticateEvent extends AppContextEvent {
  final AppUser user;

  AuthenticateEvent({required this.user});
}

final class UnauthenticateEvent extends AppContextEvent {}
