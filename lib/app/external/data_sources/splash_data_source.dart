import 'package:dont_be_fooled/app/infrastructure/data_sources/i_splash_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dont_be_fooled/app/domain/entities/app_user.dart';

class SplashDataSource implements ISplashDataSource {
  final FirebaseAuth _firebaseAuth;

  SplashDataSource(this._firebaseAuth);

  @override
  Future<AppUser?> getLoggedUser() async {
    final currentLoggedUser = _firebaseAuth.currentUser;

    if (currentLoggedUser != null) {
      return AppUser(id: currentLoggedUser.uid);
    }

    return null;
  }
}
