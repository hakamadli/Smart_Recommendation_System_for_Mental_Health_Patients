import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserDisplayName extends StatelessWidget {
  final String documentID;

  GetUserDisplayName({required this.documentID});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentID).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            '${data['name']}',
            style: const TextStyle(
              // color: Color.fromRGBO(56, 79, 125, 0.8),
              color: Colors.white,
              fontFamily: 'Lato-Bold',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        return Text('...');
      },
    );
  }
}
