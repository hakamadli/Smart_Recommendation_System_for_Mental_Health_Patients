// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/settings_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import '../utils/constants.dart';
import '../authentication/login_auth.dart';
import 'package:tuple/tuple.dart';

class SettingsPage extends StatefulWidget {
  // const SettingsPage({Key key = const Key("any_key")}) : super(key: key);
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settingsFormKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  // final DocumentSnapshot doc = usersRef.doc(user.uid).get();

  // final Stream<DocumentSnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('users').doc(userID).snapshots();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _currentEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  // Documents IDs
  List<String> docIDs = [];

  // Get Doc IDS
  Future getDocIDs() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));
  }

  Future getUserDetails() async {
    await usersRef.where('uid', isEqualTo: user.uid).get().then((snapshot) => {
          snapshot.docs.forEach((document) {
            Map<String, dynamic> data = document.data();
            userDocID = document.reference.id;
            _nameController.text = data['name'];
            _ageController.text = data['age'].toString();
            _currentEmailController.text = data['email'];
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    saveDataToState();
  }

  void saveDataToState() async {
    setState(() {
      getUserDetails();
    });
  }

  Future<void> reauthenticateWithCredential(
      String email, String password) async {
    print(email);
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
    } on Exception catch (e) {
      print(e);
    }
  }

  // late bool passwordChanged;
  // late String message;

  Future<Tuple2<bool, String>> _changePassword(
      String password, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser!;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email.toString(),
        password: password,
      );
      user.updatePassword(newPassword).then((_) {
        print("Successfully changed password");
        final passwordChanged = true;
        final message = "Successfully changed password";
        // setMessage("Successfully changed password", passwordChanged);
        return Tuple2(passwordChanged, message);
      }).catchError((error) {
        //print("Password can't be changed" + error.toString());
        final passwordChanged = false;
        final message = "Sorry, password can't be changed!";
        // setMessage(message, passwordChanged);
        return Tuple2(passwordChanged, message);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
        final passwordChanged = false;
        final message = "Sorry, try to log in again!";
        // setMessage(message, passwordChanged);
        return Tuple2(passwordChanged, message);
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        final passwordChanged = false;
        final message = "Sorry, wrong password!";
        // setMessage(message, passwordChanged);
        return Tuple2(passwordChanged, message);
      }
    }
    final passwordChanged = true;
    final message = "Successfully changed password";
    return Tuple2(passwordChanged, message);
  }

  // void setMessage(String newMessage, bool isChanged) async {
  //   setState(() {
  //     message = newMessage;
  //     passwordChanged = isChanged;
  //   });
  // }

  Future<void> _deleteUser(String userID) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).delete();
    _deleteUserAuth();
  }

  Future<void> _deleteUserAuth() async {
    FirebaseAuth.instance.currentUser!
        .delete()
        .then((value) => FirebaseAuth.instance.signOut());
  }

  Future<void> _updateUserName(String newName) async {
    await usersRef.doc(user.uid).update({'name': newName});
  }

  Future<void> _updateUserAge(String newAge) async {
    await usersRef.doc(user.uid).update({'age': int.parse(newAge)});
  }

  Future<void> _updateUserEmail(
      String currentEmail, String newEmail, String currentPassword) async {
    // await reauthenticateWithCredential(currentEmail, currentPassword);
    // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: currentEmail,
    //   password: currentPassword,
    // );
    await user.reload();
    usersRef.doc(user.uid).update({'email': newEmail}).then(
        (value) => user.updateEmail(newEmail.trim()));
  }

  // Future<void> _updateUserPassword(String newPassword) async {
  //   // FirebaseAuth.instance.signInWithEmailAndPassword(email: user., password: password);
  //   user.updatePassword(newPassword.trim());
  // }

  _showDeleteAccountDialog(BuildContext context, String userID) async {
    Widget cancelButton = ElevatedButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.normal,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
      ),
      child: Text(
        "Delete",
        style: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.normal,
        ),
      ),
      onPressed: () async {
        await _deleteUser(userID).then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginAuthPage()),
            ));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        final accountDeletedSnackBar = SnackBar(
          content: Text("Account deleted"),
        );
        ScaffoldMessenger.of(context).showSnackBar(accountDeletedSnackBar);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Whoa, there!",
        style: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.normal,
        ),
      ),
      content: Text(
        "Once you delete your account, there's no getting it back.",
        style: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.normal,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String userDocID = '';
  // String initName = '';
  // String initAgeInString = '';
  // int initAge = 0;
  // String initEmail = '';
  // String initPassword = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: myDarkPurple,
        // image: DecorationImage(
        //     image: AssetImage('assets/images/Bg.png'), fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //     color: Colors.white,
        //   ),
        //   centerTitle: true,
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
          stream: _usersStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, top: 25, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Lato-Bold',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginAuthPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.home,
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(30),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.person,
                                color: Color(0xFF746BA0),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Lato-Bold',
                                  fontWeight: FontWeight.bold,
                                  // color: Color.fromRGBO(56, 79, 125, 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Form(
                                    key: _settingsFormKey,
                                    child: AlertDialog(
                                      title: Text('Change Name'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: _nameController,
                                            validator: (name) {
                                              if (name == null ||
                                                  name.isEmpty) {
                                                return "Hang on, you can't leave it empty!";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              // hintText: 'New Name',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF8E8E8E),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  244, 249, 254, 1),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myLightPurple),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              label: Text(
                                                'New Name',
                                                style: TextStyle(
                                                  color: myDarkPurple,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    168, 195, 236, 1),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(16),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            onSaved: (val) {
                                              setState(() {});
                                            },
                                            autovalidateMode:
                                                AutovalidateMode.always,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Close")),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (_settingsFormKey.currentState!
                                                  .validate()) {
                                                _updateUserName(
                                                    _nameController.text);
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SettingsAuthPage()),
                                                );
                                                final nameUpdatedSnackBar =
                                                    SnackBar(
                                                  content: const Text(
                                                      'Name updated!'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        nameUpdatedSnackBar);
                                              }
                                            },
                                            child: Text("Apply")),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Form(
                                    key: _settingsFormKey,
                                    child: AlertDialog(
                                      title: Text('Change Age'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: _ageController,
                                            validator: (age) {
                                              if (age == null || age.isEmpty) {
                                                return "How old are you?";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              // hintText: 'New Name',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF8E8E8E),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  244, 249, 254, 1),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myLightPurple),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              label: Text(
                                                'New Age',
                                                style: TextStyle(
                                                  color: myDarkPurple,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    168, 195, 236, 1),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(16),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            onSaved: (val) {
                                              setState(() {});
                                            },
                                            autovalidateMode:
                                                AutovalidateMode.always,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Close")),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (_settingsFormKey.currentState!
                                                  .validate()) {
                                                _updateUserAge(
                                                    _ageController.text);
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SettingsAuthPage()),
                                                );
                                                final ageUpdatedSnackBar =
                                                    SnackBar(
                                                  content: const Text(
                                                      'Age updated!'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        ageUpdatedSnackBar);
                                              }
                                            },
                                            child: Text("Apply")),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Form(
                                  key: _settingsFormKey,
                                  child: AlertDialog(
                                    title: Text('Change Email'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _newEmailController,
                                          validator: (email) {
                                            if (!EmailValidator.validate(
                                                email!)) {
                                              return 'Please enter a valid email';
                                            } else if (email ==
                                                _currentEmailController.text) {
                                              return 'Please enter a different email';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8E8E8E),
                                              fontSize: 16,
                                              fontFamily: 'Lato',
                                            ),
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                244, 249, 254, 1),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: myLightPurple),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            focusedBorder: InputBorder.none,
                                            label: Text(
                                              'New Email',
                                              style: TextStyle(
                                                color: myDarkPurple,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  168, 195, 236, 1),
                                              fontSize: 16,
                                              fontFamily: 'Lato',
                                            ),
                                            contentPadding: EdgeInsets.all(18),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        // TextFormField(
                                        //   controller: _newPasswordController,
                                        //   validator: (newPassword) {
                                        //     if (newPassword == null ||
                                        //         newPassword.isEmpty) {
                                        //       return 'Please enter your password!';
                                        //     } else if (_newPasswordController
                                        //             .text !=
                                        //         _currentPasswordController.text
                                        //             .trim()) {
                                        //       return 'Password is incorrent!';
                                        //     }
                                        //     return null;
                                        //   },
                                        //   obscureText: true,
                                        //   decoration: InputDecoration(
                                        //     hintText: 'Enter password',
                                        //     hintStyle: TextStyle(
                                        //       color: Color(0xFF8E8E8E),
                                        //       fontSize: 16,
                                        //       fontFamily: 'Lato',
                                        //     ),
                                        //     filled: true,
                                        //     fillColor: Color.fromRGBO(
                                        //         244, 249, 254, 1),
                                        //     enabledBorder: OutlineInputBorder(
                                        //       borderSide: BorderSide(
                                        //           color:
                                        //               Constants.myLightPurple),
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(12)),
                                        //     ),
                                        //     focusedBorder: InputBorder.none,
                                        //     label: Text(
                                        //       'Password',
                                        //       style: TextStyle(
                                        //         color: Constants.myDarkPurple,
                                        //       ),
                                        //     ),
                                        //     labelStyle: TextStyle(
                                        //       color: Color.fromRGBO(
                                        //           168, 195, 236, 1),
                                        //       fontSize: 16,
                                        //       fontFamily: 'Lato',
                                        //     ),
                                        //     // suffixIcon: IconButton(
                                        //     //     onPressed: () {
                                        //     //       setState(() {
                                        //     //         _passEnable = !_passEnable;
                                        //     //       });
                                        //     //     },
                                        //     //     icon: Icon(_passEnable
                                        //     //         ? Icons.visibility
                                        //     //         : Icons.visibility_off)),
                                        //     contentPadding: EdgeInsets.all(18),
                                        //     floatingLabelBehavior:
                                        //         FloatingLabelBehavior.always,
                                        //   ),
                                        //   // obscureText: _passEnable,
                                        // ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close")),
                                      ElevatedButton(
                                          onPressed: () {
                                            if (_settingsFormKey.currentState!
                                                .validate()) {
                                              _updateUserEmail(
                                                  _currentEmailController.text,
                                                  _newEmailController.text,
                                                  _newPasswordController.text);
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SettingsAuthPage()),
                                              );
                                              final emailUpdatedSnackBar =
                                                  SnackBar(
                                                content: const Text(
                                                    'Email updated!'),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      emailUpdatedSnackBar);
                                            }
                                          },
                                          child: Text("Apply")),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Form(
                                    key: _settingsFormKey,
                                    child: AlertDialog(
                                      title: Text('Change Password'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // TextFormField(
                                          //   controller: _currentEmailController,
                                          //   validator: (email) {
                                          //     if (!EmailValidator.validate(
                                          //         email!)) {
                                          //       return 'Please enter a valid email';
                                          //     }
                                          //     return null;
                                          //   },
                                          //   decoration: InputDecoration(
                                          //     hintStyle: TextStyle(
                                          //       color: Color(0xFF8E8E8E),
                                          //       fontSize: 16,
                                          //       fontFamily: 'Lato',
                                          //     ),
                                          //     filled: true,
                                          //     fillColor: Color.fromRGBO(
                                          //         244, 249, 254, 1),
                                          //     enabledBorder: OutlineInputBorder(
                                          //       borderSide: BorderSide(
                                          //           color: Constants
                                          //               .myLightPurple),
                                          //       borderRadius: BorderRadius.all(
                                          //           Radius.circular(12)),
                                          //     ),
                                          //     focusedBorder: InputBorder.none,
                                          //     label: Text(
                                          //       'Current Email',
                                          //       style: TextStyle(
                                          //         color: Constants.myDarkPurple,
                                          //       ),
                                          //     ),
                                          //     labelStyle: TextStyle(
                                          //       color: Color.fromRGBO(
                                          //           168, 195, 236, 1),
                                          //       fontSize: 16,
                                          //       fontFamily: 'Lato',
                                          //     ),
                                          //     contentPadding:
                                          //         EdgeInsets.all(18),
                                          //     floatingLabelBehavior:
                                          //         FloatingLabelBehavior.always,
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller:
                                                _currentPasswordController,
                                            validator: (currentPassword) {
                                              if (currentPassword == null ||
                                                  currentPassword.isEmpty) {
                                                return 'Please enter your current password!';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                color: Color(0xFF8E8E8E),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  244, 249, 254, 1),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myLightPurple),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              label: Text(
                                                'Current Password',
                                                style: TextStyle(
                                                  color: myDarkPurple,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    168, 195, 236, 1),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              contentPadding:
                                                  EdgeInsets.all(18),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            obscureText: true,
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          TextFormField(
                                            controller: _newPasswordController,
                                            validator: (newPassword) {
                                              if (newPassword == null ||
                                                  newPassword.isEmpty) {
                                                return 'Please enter your new password!';
                                              }
                                              return null;
                                            },
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                color: Color(0xFF8E8E8E),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  244, 249, 254, 1),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myLightPurple),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              label: Text(
                                                'New Password',
                                                style: TextStyle(
                                                  color: myDarkPurple,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    168, 195, 236, 1),
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              // suffixIcon: IconButton(
                                              //     onPressed: () {
                                              //       setState(() {
                                              //         _passEnable = !_passEnable;
                                              //       });
                                              //     },
                                              //     icon: Icon(_passEnable
                                              //         ? Icons.visibility
                                              //         : Icons.visibility_off)),
                                              contentPadding:
                                                  EdgeInsets.all(18),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                            // obscureText: _passEnable,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SettingsAuthPage()),
                                              );
                                            },
                                            child: Text("Close")),
                                        ElevatedButton(
                                            onPressed: () async {
                                              // _updateUserPasswordInAuth(_passwordController.text);
                                              if (_settingsFormKey.currentState!
                                                  .validate()) {
                                                Tuple2<bool, String> result =
                                                    await _changePassword(
                                                  _currentPasswordController
                                                      .text,
                                                  _newPasswordController.text,
                                                );
                                                if (result.item1 == true) {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SettingsAuthPage()),
                                                  );
                                                  final passwordUpdatedSnackBar =
                                                      SnackBar(
                                                    content: Text(result.item2),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          passwordUpdatedSnackBar);
                                                } else {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SettingsAuthPage()),
                                                  );
                                                  final passwordNotUpdatedSnackBar =
                                                      SnackBar(
                                                    content: Text(
                                                      result.item2,
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          passwordNotUpdatedSnackBar);
                                                }
                                              }
                                            },
                                            child: Text("Apply")),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.now_widgets,
                                color: Color(0xFF746BA0),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "More",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Lato-Bold',
                                  fontWeight: FontWeight.bold,
                                  // color: Color.fromRGBO(56, 79, 125, 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Privacy & Security'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Close Account'),
                                            IconButton(
                                              onPressed: () {
                                                _showDeleteAccountDialog(
                                                    context, user.uid);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                              ),
                                              color: Colors.redAccent,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close")),
                                    ],
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Privacy & Security',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('About this application'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                            "This is a mobile application that uses recommendation & machine learning techniques to diagnose mental illness, provide selfcare treatments, manage & improve youth mental wellbeing\n"),
                                        Text("Version: Unreleased"),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close")),
                                    ],
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "About",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("FAQs"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text("Data\n"),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close")),
                                    ],
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "FAQs",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF746BA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 2,
                              backgroundColor: Color(0xFF746ba0),
                              shadowColor: Colors.grey[700],
                            ),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lato-Bold',
                                    color: Colors.white,
                                  ),
                                ),
                                // SizedBox(width: 6,),
                                // Icon(Icons.logout),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }
}
