import 'package:dont_be_fooled/app/domain/entities/app_user.dart';
import 'package:dont_be_fooled/app/infrastructure/data_sources/i_login_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginDataSource implements ILoginDataSource {
  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  LoginDataSource(this._firebaseAuth);

  @override
  Future<AppUser?> authenticate() async {
    final googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final res = await _firebaseAuth.signInWithCredential(credential);

      final token = res.credential?.accessToken;

      if (token != null) {
        return AppUser(id: token);
      }
    }

    return null;
  }
}
