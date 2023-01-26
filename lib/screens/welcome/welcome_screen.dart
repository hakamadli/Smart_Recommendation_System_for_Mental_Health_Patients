// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/models/user.dart'
    as u;
import 'package:smart_recommendation_system_for_mental_health_patients/screens/welcome/register.dart';
import '../../utils/constants.dart';
import 'package:get/get.dart';
import 'login.dart';

final DateTime timestamp = DateTime.now();
final usersRef = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser!;
u.User? currentUser;

class WelcomeScreen extends StatefulWidget {
  // const WelcomeScreen({super.key});
  const WelcomeScreen({Key key = const Key("any_key")}) : super(key: key);

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(
                flex: 3,
              ),
              Container(
                  width: 321,
                  height: 321,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Logo.png'),
                        fit: BoxFit.fitWidth),
                  )),
              SizedBox(height: 30),
              Text(
                'Sage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lato',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 8),
              Row(children: const <Widget>[
                Expanded(
                    child: Divider(
                  color: Colors.white,
                )),
                Text(
                  " Let us help you ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Expanded(
                    child: Divider(
                  color: Colors.white,
                )),
              ]),
              SizedBox(height: 30),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: OutlinedButton(
                  style: mainDarkOutlinedButton,
                  onPressed: () {
                    Get.to(() => RegisterPage());
                  },
                  child: Text(
                    'Get Started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Lato-Bold',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Already have account? ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        color: myLightPurple,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => LoginPage());
                        }),
                ]),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
