import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/screening_test/screening_test.dart';
import '../screens/welcome/welcome_screen.dart';

class ScreeningAuthPage extends StatelessWidget {
  const ScreeningAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ScreeningTestPage();
          }
          else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}