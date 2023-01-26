// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/settings_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/home/components/journal_section.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/home/components/mental_state.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/home/components/mood_graph.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/home/components/nav_box.dart';
import '../../services/user_data/get_user_displayname.dart';
import '../../shared/loading.dart';
import 'package:ionicons/ionicons.dart';
import '../../utils/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final usersRef = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void dispose() {
    super.dispose();
  }

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

  String userDocID = '';

  Future getUserDocID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((document) {
                Map<String, dynamic> data = document.data();
                userDocID = document.reference.id;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(
      //     color: Color.fromRGBO(56, 79, 125, 0.8),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     "Hello,",
      //     style: TextStyle(
      //       color: Color.fromRGBO(56, 79, 125, 0.8),
      //       fontFamily: 'Lato-Bold',
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(
      //         Icons.settings,
      //         color: Color.fromRGBO(56, 79, 125, 0.8),
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => SettingsAuthPage(),
      //           ),
      //         );
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(
      //         Icons.logout,
      //         color: Color.fromRGBO(56, 79, 125, 0.8),
      //       ),
      //       onPressed: () {
      //         FirebaseAuth.instance.signOut();
      //       },
      //     ),
      //   ],
      // ),
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: myDarkPurple,
              // decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/Bg.png'),
              // ),
              // ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .78,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: StreamBuilder(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Welcome, ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Lato-Bold',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsAuthPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GetUserDisplayName(documentID: user.uid),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  NavBox(),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 16, top: 8),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Features for you",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Lato-Bold',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF543E7A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  MentalStateSection(),
                                  JournalSection(),
                                ],
                              ),
                            ),
                            MoodGraph(),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
