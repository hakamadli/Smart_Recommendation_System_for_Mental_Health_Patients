import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDoc {
  final String documentID;

  UserDoc({required this.documentID});

  getNickname() {
    DocumentReference users =
        FirebaseFirestore.instance.collection('users').doc(documentID);

    final Future<DocumentSnapshot<Map<String, dynamic>>> data =
        users.get() as Future<DocumentSnapshot<Map<String, dynamic>>>;

    return data;

    // return FutureBuilder<DocumentSnapshot>(
    //   future: users.get(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data =
    //           snapshot.data!.data() as Map<String, dynamic>;
    //       return data['name'];
    //     }
    //     return Text('...');
    //   },
    // );
  }
}
