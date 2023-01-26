import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/professional_help_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/screening_result_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/screening_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/settings_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/community/chats_page.dart';
import '../../../shared/loading.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';
import 'package:get/get.dart';

import '../../self_treatment/self_treatment.dart';

class NavBox extends StatefulWidget {
  const NavBox({super.key});

  @override
  State<NavBox> createState() => _NavBoxState();
}

class _NavBoxState extends State<NavBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: (Colors.grey[400])!,
            blurRadius: 10,
            offset: Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 16, bottom: 16),
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            child: GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreeningAuthPage(),
                  ),
                );
              }),
              child: Column(
                children: const [
                  Icon(
                    // CupertinoIcons.square_grid_2x2_fill,
                    Icons.now_widgets_outlined,
                    color: Color(0xFF543E7A),
                    size: 30,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Assess',
                  ),
                ],
              ),
            ),
          ),
          FittedBox(
            child: GestureDetector(
              onTap: (() {
                Get.to(() => SelfTreatmentPage());
              }),
              child: Column(
                children: const [
                  Icon(
                    Ionicons.sparkles_outline,
                    color: Color(0xFF543E7A),
                    size: 30,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Selfcare',
                  ),
                ],
              ),
            ),
          ),
          FittedBox(
            child: GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfessionalHelpAuth(),
                  ),
                );
              }),
              child: Column(
                children: const [
                  Icon(
                    Ionicons.heart_outline,
                    color: Color(0xFF543E7A),
                    size: 30,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Get Help',
                  ),
                ],
              ),
            ),
          ),
          FittedBox(
            child: GestureDetector(
              onTap: (() {
                Get.to(() => ChatsPage());
              }),
              child: Column(
                children: const [
                  Icon(
                    Ionicons.chatbubble_ellipses_outline,
                    color: Color(0xFF543E7A),
                    size: 30,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Community',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
