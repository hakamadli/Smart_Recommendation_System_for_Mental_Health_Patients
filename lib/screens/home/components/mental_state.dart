import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/screening_result_auth.dart';

class MentalStateSection extends StatefulWidget {
  const MentalStateSection({super.key});

  @override
  State<MentalStateSection> createState() => _MentalStateSectionState();
}

class _MentalStateSectionState extends State<MentalStateSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreAuthPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            image: AssetImage('assets/images/meditation_banner.jpg'),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: (Colors.grey[400])!,
              blurRadius: 10,
              offset: const Offset(
                0,
                3,
              ),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
        width: MediaQuery.of(context).size.width,
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "DASS-21 Score",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lato-Bold',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF543E7A),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const Text(
                    "Measures your level of Depression, Anxiety and Stress",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato-Bold',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF746BA0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
