import 'package:firebase_auth/firebase_auth.dart';

import '../services/database.dart';



/// Interface to the info about the current user.
/// Relies on Firebase authentication.
class UserRepository {

  UserRepository() : _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;

/// Add user account
  Future<void> addAccount() async {
    final UserCredential result = await _firebaseAuth.signInAnonymously();
    final User? user = result.user;
    await DatabaseService(uid: user?.uid)
        .createUser();
  }

  Future<List<dynamic>> signOut() async {
    return Future.wait(<Future<dynamic>>[_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final User? currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  /// Reset Password
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((User? user) => user);
  }

  // bool get appleSignInAvailable => Platform.isIOS;

  // Future<UserCredential?> signInWithApple() async {
  //   try {
  //     final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
  //         scopes: <AppleIDAuthorizationScopes>[
  //           AppleIDAuthorizationScopes.email,
  //           AppleIDAuthorizationScopes.fullName
  //         ]);
  //
  //     final OAuthCredential credential = OAuthProvider('apple.com').credential(
  //       accessToken: appleCredential.authorizationCode,
  //       idToken: appleCredential.identityToken,
  //     );
  //
  //     return await _firebaseAuth.signInWithCredential(credential);
  //   } catch (e) {
  //     CloudFunction().logError('Error in Apple sign in: ${e.toString()}');
  //     return null;
  //   }
  // }
  //
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();
  //     final GoogleSignInAuthentication? googleSignInAuthentication =
  //         await googleSignInAccount?.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication?.accessToken,
  //       idToken: googleSignInAuthentication?.idToken,
  //     );
  //
  //     final UserCredential authResult =
  //         await _firebaseAuth.signInWithCredential(credential);
  //     final User? user = authResult.user;
  //
  //     assert(!user!.isAnonymous);
  //     assert(await user?.getIdToken() != null);
  //
  //     final User? currentUser = _firebaseAuth.currentUser;
  //     assert(user?.uid == currentUser?.uid);
  //     await _analyticsService.logLoginGoogle();
  //     return authResult;
  //   } catch (e) {
  //     _analyticsService.writeError(e.toString());
  //     return null;
  //   }
  // }

}
