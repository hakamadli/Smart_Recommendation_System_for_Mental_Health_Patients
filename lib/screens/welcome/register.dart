import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/login_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/models/user.dart'
    as u;
import 'package:smart_recommendation_system_for_mental_health_patients/screens/welcome/login.dart';
import '../../utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

final DateTime timestamp = DateTime.now();
final usersRef = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser!;
u.User? currentUser;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passEnable = true;
  bool _conPassEnable = true;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SpinKitWanderingCubes(
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'We are creating your profile',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "This won't take too long",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );

    bool passwordConfirmed() {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        return true;
      } else {
        return false;
      }
    }

    // Aunthenticate user
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = FirebaseAuth.instance.currentUser?.uid as String;
      // DocumentSnapshot doc = await usersRef.doc(uid).get();

      // Add user details
      addUserDetails(
        uid,
        _emailController.text.trim(),
        _nameController.text.trim(),
        int.parse(
          _ageController.text.trim(),
        ),
        timestamp,
        DateTime.now(),
      );
      // currentUser = u.User.fromDocument(doc);

      Get.to(() => const LoginAuthPage());
    }
  }

  Future addUserDetails(String uid, String email, String name, int age,
      DateTime timestamp, DateTime lastMessageTime) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
      'timestamp': timestamp,
      'lastMessageTime': lastMessageTime,
    });
    setMoodScore(uid, timestamp);
    setMentalScore(uid, timestamp);
  }

  Future setMoodScore(String uid, DateTime timestamp) async {
    await FirebaseFirestore.instance.collection('user_mood').doc(uid).set({
      'happy': 0,
      'neutral': 0,
      'sad': 0,
      'date': timestamp,
    });
  }

  Future setMentalScore(String uid, DateTime timestamp) async {
    await FirebaseFirestore.instance
        .collection('screening_score')
        .doc(uid)
        .set({
      'depressionScore': 0,
      'anxietyScore': 0,
      'stressScore': 0,
      'depressionSeverity': "",
      'anxietySeverity': "",
      'stressSeverity': "",
      'timestamp': timestamp,
    });
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
        body: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 50, bottom: 32),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato-Bold',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(28),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _nameController,
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Please enter your nickname';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Choose a nickname',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          label: Text(
                            'Nickname',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          contentPadding: EdgeInsets.all(16),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _ageController,
                        validator: (age) {
                          if (age == null || age.isEmpty) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Choose your age',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          label: Text(
                            'Age',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(168, 195, 236, 1),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          contentPadding: EdgeInsets.all(16),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _emailController,
                        validator: (email) => EmailValidator.validate(email!)
                            ? null
                            : 'Please enter a valid email',
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
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
                          contentPadding: EdgeInsets.all(16),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _passwordController,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Please enter a valid password';
                          } else if (password.length < 8) {
                            return 'Password is too short';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter a password',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
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
                          contentPadding: const EdgeInsets.all(16),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        ),
                        obscureText: _passEnable,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _confirmPasswordController,
                        validator: (confirmPassword) {
                          if (confirmPassword == null ||
                              confirmPassword.isEmpty) {
                            return 'Please confirm password';
                          } else if (confirmPassword !=
                              _passwordController.text.trim()) {
                            return 'Password is not matched';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Re-enter password',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          label: const Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Color.fromRGBO(168, 195, 236, 1),
                            fontSize: 16,
                            fontFamily: 'Lato',
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _conPassEnable = !_conPassEnable;
                              });
                            },
                            icon: Icon(_conPassEnable
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.white,
                          ),
                        ),
                        obscureText: _conPassEnable,
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
                      signUp();
                      const registeredSnackBar = SnackBar(
                        content: Text(
                          "Registered successfully!",
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(registeredSnackBar);
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'By continuing, I confirm I am 13 or older',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: 'Already have account? ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: myLightPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const LoginPage());
                          }),
                  ]),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
