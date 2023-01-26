import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/utils/constants.dart';

import '../../api/chat_firebase_api.dart';
import '../../authentication/login_auth.dart';
import '../../models/therapist.dart';
import 'widget/chat_body_widget.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

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
        backgroundColor: myDarkPurple,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 50, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Therapists',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato-Bold',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginAuthPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.home,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                child: StreamBuilder<List<Therapist>>(
                  stream: FirebaseApi.getTherapists(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Loading();
                      default:
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Center(
                            child: buildText('Something Went Wrong Try later'),
                          );
                        } else {
                          final therapists = snapshot.data;

                          if (therapists!.isEmpty) {
                            return Center(
                              child: buildText('No Therapists Found'),
                            );
                          } else {
                            return Column(
                              children: [
                                // ChatHeaderWidget(therapists: therapists),
                                ChatBodyWidget(therapists: therapists),
                              ],
                            );
                          }
                        }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'Lato',
            color: Colors.white,
          ),
        ),
      );
}
