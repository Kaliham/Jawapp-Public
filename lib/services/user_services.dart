import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/model/user.dart';
import 'package:app/services/setup_locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserService {
  UserModel _userData;
  Stream<User> _firebaseUserStream;
  User _firebaseUser;
  String familyId;
  UserService({User firebase}) {
    _firebaseUserStream = locators.authService.authStateChanges;

    _firebaseUserStream.listen((event) {
      _firebaseUser = event;

      locators.databaseService.userDataStream.listen((event) {
        _userData = event;
        locators.databaseService
            .familyIdStream(_userData.nationalID)
            .listen((event) {
          familyId = event;
        });
      });
    });
  }

  UserModel get userData => _userData;

  Locale get lang {
    return userData.lang;
  }

  String get email {
    return userData.email;
  }

  LatLng get homepoint {
    return userData.homePoint;
  }

  String get nationalId {
    return userData.nationalID;
  }

  String get id {
    return _firebaseUser.uid;
  }

  Future<User> get firebaseUser async {
    return await _firebaseUserStream.first;
  }

  bool get isVerified => FirebaseAuth.instance.currentUser.emailVerified;
}
