import 'package:dont_be_fooled/app/domain/entities/app_user.dart';

abstract class ILoginDataSource {
  Future<AppUser?> authenticate();
}
