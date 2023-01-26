import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetHelpHotline extends StatelessWidget {
  final String documentID;

  GetHelpHotline({required this.documentID});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('helpline_and_resources');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Lato-Bold',
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Contact Number: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
                TextSpan(
                  text: '${data['hotline']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xCC384F7D),
                  ),
                ),
              ],
            ),
          );
        }
        return const Text('...');
      },
    );
  }
}
