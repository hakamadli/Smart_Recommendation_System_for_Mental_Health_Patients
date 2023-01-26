import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/welcome/welcome_screen.dart';

import '../screens/home/home.dart';

class LoginAuthPage extends StatelessWidget {
  const LoginAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
