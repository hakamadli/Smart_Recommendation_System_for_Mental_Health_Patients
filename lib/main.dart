// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/login_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  MaterialColor myAppColor = MaterialColor(0xFF543E7A, const <int, Color>{
      50: Color(0xFF543E7A),
      100: Color(0xFF543E7A),
      200: Color(0xFF543E7A),
      300: Color(0xFF543E7A),
      400: Color(0xFF543E7A),
      500: Color(0xFF543E7A),
      600: Color(0xFF543E7A),
      700: Color(0xFF543E7A),
      800: Color(0xFF543E7A),
      900: Color(0xFF543E7A),
    },
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health',
      theme: ThemeData(
        primarySwatch: myAppColor,
      ),
      // initialRoute: "/main",
      // routes: {
      //   "/main":(context) => MainPage(),
      //   "/welcome": (context) => WelcomeScreen(),
      // },
      home: LoginAuthPage(),
    );
  }
}
