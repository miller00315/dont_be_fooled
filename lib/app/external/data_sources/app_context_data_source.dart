import 'package:dont_be_fooled/app/infrastructure/data_sources/i_app_context_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppContextDataSource implements IAppContextDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppContextDataSource(this._firebaseAuth);

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();

      await _firebaseAuth.signOut();
    } catch (e, st) {
      debugPrint(e.toString());

      debugPrintStack(stackTrace: st);
    }
  }
}
