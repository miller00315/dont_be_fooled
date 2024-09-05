import 'package:dont_be_fooled/app/domain/facades/i_app_context_facade.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_app_context_data_source.dart';

class AppContextFacade implements IAppContextFacade {
  final IAppContextDataSource _appContextDataSource;

  AppContextFacade(this._appContextDataSource);

  @override
  Future<void> signOut() async {
    await _appContextDataSource.signOut();
  }
}
