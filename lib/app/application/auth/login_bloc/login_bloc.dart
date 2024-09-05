import 'package:bloc/bloc.dart';
import 'package:dont_be_fooled/app/application/app_context_bloc/app_context_bloc.dart';
import 'package:dont_be_fooled/app/domain/facades/i_login_facade.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ILoginFacade _loginFacade;

  LoginBloc(this._loginFacade) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      switch (event) {
        case Authenticate():
          {
            final user = await _loginFacade.authenticate();

            if (user != null) {
              GetIt.instance.get<AppContextBloc>().add(AuthenticateEvent(user: user));
            }

            break;
          }
      }
    });
  }
}
