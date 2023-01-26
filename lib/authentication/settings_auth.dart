import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/settings.dart';

import '../screens/welcome/welcome_screen.dart';

class SettingsAuthPage extends StatelessWidget {
  const SettingsAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SettingsPage();
          }
          else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}