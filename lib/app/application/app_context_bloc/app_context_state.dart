part of 'app_context_bloc.dart';

@immutable
sealed class AppContextState {}

final class AppContextStateInitial extends AppContextState {}

final class AppContextStateUnautheticated extends AppContextState {}

final class AppContextStateAuthenticated extends AppContextState {
  final AppUser user;

  AppContextStateAuthenticated({required this.user});

  AppContextStateAuthenticated copyWith({
    AppUser? user,
  }) =>
      AppContextStateAuthenticated(
        user: user ?? this.user,
      );

  @override
  String toString() => '''
      {"user" : $user}
    ''';
}
