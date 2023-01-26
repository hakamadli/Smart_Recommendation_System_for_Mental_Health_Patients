import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/login_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/models/user.dart'
    as u;
import 'package:smart_recommendation_system_for_mental_health_patients/screens/welcome/register.dart';
import '../../utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

final DateTime timestamp = DateTime.now();
final usersRef = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser!;
u.User? currentUser;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passEnable = true;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SpinKitWanderingCubes(
            color: Colors.white,
          ),
        );
      },
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    Get.to(() => const LoginAuthPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        // color: Colors.white,
        image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Spacer(),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'lato-bold',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(28),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _emailController,
                        validator: (email) => EmailValidator.validate(email!)
                            ? null
                            : 'Please enter a valid email',
                        decoration: const InputDecoration(
                          hintText: 'Enter email',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: myLightPurple),
                          ),
                          label: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(168, 195, 236, 1),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          contentPadding: EdgeInsets.all(18),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _passwordController,
                        validator: (password) {
                          if (password == null ||
                              password.isEmpty ||
                              password.length < 8) {
                            return 'Password is too short';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: myLightPurple),
                          ),
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Color.fromRGBO(168, 195, 236, 1),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passEnable = !_passEnable;
                              });
                            },
                            icon: Icon(_passEnable
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.white,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        obscureText: _passEnable,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                OutlinedButton(
                  style: darkOutlinedButton,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signIn();
                      const loggedInSnackBar = SnackBar(
                        content: Text(
                          "Welcome back!",
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(loggedInSnackBar);
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                  },
                  child: const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: "New here? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                        text: 'Create a new account',
                        style: const TextStyle(
                          color: myLightPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const RegisterPage());
                          }),
                  ]),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
