import 'package:dont_be_fooled/app/domain/entities/app_user.dart';
import 'package:dont_be_fooled/app/domain/facades/i_splash_facade.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_splash_data_source.dart';

class SplashFacade implements ISplashFacade {
  final ISplashDataSource _splashDataSource;

  SplashFacade(this._splashDataSource);

  @override
  Future<AppUser?> getLoggedUser() async {
    return await _splashDataSource.getLoggedUser();
  }
}
