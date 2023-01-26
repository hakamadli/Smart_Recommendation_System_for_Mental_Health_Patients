import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/journal_auth.dart';

class JournalSection extends StatefulWidget {
  const JournalSection({super.key});

  @override
  State<JournalSection> createState() => _JournalSectionState();
}

class _JournalSectionState extends State<JournalSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalAuthPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            image: AssetImage('assets/images/journal_banner2.png'),
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
                  "Journal",
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const Text(
                    "Record your feeling and mood change",
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
