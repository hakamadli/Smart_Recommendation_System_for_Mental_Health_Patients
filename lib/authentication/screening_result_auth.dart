import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/screening_result.dart';
import '../screens/welcome/welcome_screen.dart';

class ScoreAuthPage extends StatelessWidget {
  const ScoreAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ScreeningResultPage();
          }
          else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}