import 'package:app/services/setup_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/view/screens/accountscreen/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:app/view/screens/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Container(
        child: MainScreen(title: 'Flutter Demo Home Page'),
      );
    }
    return LoginScreen();
  }
}
