// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/login_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/result_tabs/anxiety_tab.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/result_tabs/depression_tab.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/result_tabs/stress_tab.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';

class ScreeningResultPage extends StatefulWidget {
  const ScreeningResultPage({super.key});

  @override
  State<ScreeningResultPage> createState() => _ScreeningResultPageState();
}

class _ScreeningResultPageState extends State<ScreeningResultPage> {
  int _currentPageIndex = 1;
  final user = FirebaseAuth.instance.currentUser!;
  final usersRef = FirebaseFirestore.instance.collection('screening_score');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('screening_score').snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 411,
      height: 844,
      decoration: const BoxDecoration(
        color: Color(0xFF543E7A),
        // image: DecorationImage(
        //     image: AssetImage('assets/images/Bg.png'), fit: BoxFit.cover),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder<Object>(
              stream: _usersStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 16, top: 25, right: 16),
                        child: Container(
                          padding: const EdgeInsets.only(top: 25, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "What's your score?",
                                style: TextStyle(
                                  fontSize: 24,
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
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: const [
                              TabBar(
                                indicatorColor: Color(0xFF543E7A),
                                labelColor: Color(0xFF543E7A),
                                unselectedLabelColor: Color(0xFFd4c5dc),
                                tabs: [
                                  Tab(
                                    child: Text(
                                      "Depression",
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "Anxiety",
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "Stress",
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  DepressionTab(),
                                  AnxietyTab(),
                                  StressTab(),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } return Loading();
              }),
        ),
      ),
    );
  }
}
