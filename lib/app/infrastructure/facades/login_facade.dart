import 'package:dont_be_fooled/app/domain/entities/app_user.dart';
import 'package:dont_be_fooled/app/domain/facades/i_login_facade.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_login_data_source.dart';

class LoginFacade implements ILoginFacade {
  final ILoginDataSource _loginDataSource;

  LoginFacade(this._loginDataSource);

  @override
  Future<AppUser?> authenticate() async {
    final res = await _loginDataSource.authenticate();

    return res;
  }
}
