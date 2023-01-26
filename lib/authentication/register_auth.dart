import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/home/home.dart';
import '../screens/welcome/welcome_screen.dart';

class RegisterAuthPage extends StatelessWidget {
  const RegisterAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}