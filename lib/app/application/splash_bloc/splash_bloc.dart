import 'package:bloc/bloc.dart';
import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/domain/facades/i_splash_facade.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ISplashFacade _splashFacade;

  SplashBloc(this._splashFacade) : super(SplashInitial()) {
    on<SplashEvent>((event, emit) async {
      switch (event) {
        case GetLoggedUser():
          {
            final user = await _splashFacade.getLoggedUser();

            final appContexBloc = GetIt.instance.get<AppContextBloc>();

            print("passei aqui");

            if (user == null) {
              appContexBloc.add(UnauthenticateEvent());

              return;
            }

            appContexBloc.add(AuthenticateEvent(user: user));

            break;
          }
      }
    });
  }
}
