import 'dart:io';

import 'package:app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/services/setup_locator.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      if (email != null && password != null && email != "" && password != "") {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        return StatusCode.success;
      }
      return StatusCode.UnknownError;
    } catch (e) {
      String errorType = "UNKNOWN";
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = StatusCode.WrongLogin;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = StatusCode.WrongLogin;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = StatusCode.NetworkIssue;
            break;
          // ...
          default:
            errorType = StatusCode.WrongLogin;
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = StatusCode.WrongLogin;
            break;
          case 'Error 17009':
            errorType = StatusCode.WrongLogin;
            break;
          case 'Error 17020':
            errorType = StatusCode.NetworkIssue;
            break;
          // ...
          default:
            errorType = StatusCode.WrongLogin;
        }
      }
      return e.code + e.message;
    }
  }

  Future<String> signInGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final User user = authResult.user;
      if (user != null) {
        final User currentUser = _firebaseAuth.currentUser;
        locators.databaseService.createUserData(currentUser.uid);

        return "done";
      }

      return "didn't sign in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on Exception {
      return "error";
    } catch (error) {
      return error.toString();
    }
  }

  Future<dynamic> register({String email, String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await user.user.sendEmailVerification();
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      locators.databaseService.createUserData(user.user.uid);
      return user.user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {}
  }

  Future<void> verifyEmail() async {
    try {
      User user = _firebaseAuth.currentUser;
      await user.sendEmailVerification();

      return user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
