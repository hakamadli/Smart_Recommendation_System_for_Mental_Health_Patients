import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetHelpName extends StatelessWidget {
  final String documentID;

  GetHelpName({required this.documentID});

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
            '${data['helpName']}',
            style: TextStyle(
              fontFamily: 'Lato-Bold',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.brown[800],
            ),
          );
        }
        return Text('');
      },
    );
  }
}
