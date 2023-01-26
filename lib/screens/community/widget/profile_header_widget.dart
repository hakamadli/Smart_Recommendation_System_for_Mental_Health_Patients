import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/therapist.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/utils/constants.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final String name;
  final Therapist therapist;

  const ProfileHeaderWidget({
    required this.name,
    required this.therapist,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  String therapistName = '';
  String organization = '';
  String specialization = '';
  int exp = 0;
  DateTime accountCreated = DateTime.now();
  final therapistsRef = FirebaseFirestore.instance.collection('therapists');

  Future getTherapistDetails() async {
    await therapistsRef.doc(widget.therapist.uid).get().then((snapshot) => {
          setState(() {
            therapistName = snapshot.data()!['name'];
            organization = snapshot.data()!['organization'];
            exp = snapshot.data()!['exp'];
            specialization = snapshot.data()!['specialization'];
            accountCreated = snapshot.data()!['timestamp'].toDate();
          })
        });
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Therapist's info",
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name: ",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              Text(
                therapistName,
                style:
                    const TextStyle(fontFamily: 'Lato', color: myMediumPurple),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Organization: ",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              Text(
                organization,
                style:
                    const TextStyle(fontFamily: 'Lato', color: myMediumPurple),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Specialization: ",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              Text(
                specialization,
                style:
                    const TextStyle(fontFamily: 'Lato', color: myMediumPurple),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Experience: ",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              Text(
                "$exp years",
                style:
                    const TextStyle(fontFamily: 'Lato', color: myMediumPurple),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Account created: ",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              Text(
                DateFormat.yMMMMEEEEd().format(accountCreated).toString(),
                style:
                    const TextStyle(fontFamily: 'Lato', color: myMediumPurple),
                maxLines: 2,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close",
                  style: TextStyle(color: myDarkPurple),
                ))
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                Expanded(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        getTherapistDetails();
                      },
                      child: buildIcon(Icons.person),
                    ),
                  ],
                ),
                SizedBox(width: 4),
              ],
            )
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: myMediumPurple,
        ),
        child: Icon(icon, size: 30, color: Colors.white),
      );
}
