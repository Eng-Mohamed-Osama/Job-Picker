import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

//abstract class to define the public interface for any auth service
abstract class AuthBase {
  User get currentUser;
  Future<void> signinAnonmous();
  Future<void> signout();
  Future<User> signinWithGoogle();
  Future<User> signinWithFacebook();
  Future<User> signUpwithEmail({email, password});
  Future<User> signinwithEmail({email, password});
  Stream<User> get authchanges;
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;

  @override
  Stream<User> get authchanges => _auth.authStateChanges();

  @override
  User get currentUser => _auth.currentUser;

  @override
  Future<void> signinAnonmous() async {
    await _auth.signInAnonymously();
  }

  @override
  Future<User> signinWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null) {
        final userCredential = await _auth.signInWithCredential(
            GoogleAuthProvider.credential(idToken: googleAuth.accessToken));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'missing google ID token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User> signinWithFacebook() async {
    final facebookSignIn = FacebookLogin();
    final facebookUser = await facebookSignIn.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);

    switch (facebookUser.status) {
      case FacebookLoginStatus.success:
        final accessToken = facebookUser.accessToken;
        final userCredential = await _auth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        return userCredential.user;

      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED', message: 'Sign in failed');

      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signUpwithEmail({email, password}) async {
    var usercreditial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return usercreditial.user;
  }

  @override
  Future<User> signinwithEmail({email, password}) async {
    var usercreditial = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return usercreditial.user;
  }

  @override
  Future<void> signout() async {
    final googlesignout = GoogleSignIn();
    final facebookSignIn = FacebookLogin();
    try {
      await _auth.signOut();
      await googlesignout.signOut();
      await facebookSignIn.logOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
