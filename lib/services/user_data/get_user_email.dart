import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserEmail extends StatelessWidget {
  final String documentID;

  GetUserEmail({required this.documentID});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['email']}',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromRGBO(56, 79, 125, 0.8),
              fontFamily: 'Lato-Bold',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        return Text('...');
      },
    );
  }
}
