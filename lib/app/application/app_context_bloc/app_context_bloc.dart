import 'package:bloc/bloc.dart';
import 'package:dont_be_fooled/app/domain/entities/app_user.dart';
import 'package:dont_be_fooled/app/domain/facades/i_app_context_facade.dart';
import 'package:meta/meta.dart';

part 'app_context_event.dart';
part 'app_context_state.dart';

class AppContextBloc extends Bloc<AppContextEvent, AppContextState> {
  final IAppContextFacade _appContextFacade;

  AppContextBloc(this._appContextFacade) : super(AppContextStateInitial()) {
    on<AppContextEvent>((event, emit) async {
      switch (event) {
        case AuthenticateEvent():
          emit(AppContextStateAuthenticated(user: event.user));
          break;
        case UnauthenticateEvent():
          await _appContextFacade.signOut();

          emit(AppContextStateUnautheticated());
          break;
      }
    });
  }
}
