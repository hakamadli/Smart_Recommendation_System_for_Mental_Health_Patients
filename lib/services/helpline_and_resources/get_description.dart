import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetHelpDescription extends StatelessWidget {
  final String documentID;

  GetHelpDescription({required this.documentID});

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
          return Text(
            '${data['description']}',
            style: TextStyle(
              fontFamily: 'Lato-Bold',
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.brown[700],
            ),
          );
        }
        return const Text('');
      },
    );
  }
}
