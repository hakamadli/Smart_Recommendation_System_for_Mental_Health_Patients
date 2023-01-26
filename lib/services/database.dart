import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserName(String name) async {
    return await userCollection.doc(uid).update({
      'name': name,
    });
  }

  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return UserData(
  //     uid: uid,
  //     email: snapshot['email'],
  //     name: snapshot['name'],
  //     age: snapshot['age'],
  //   );
  // }

  // Stream<UserData> get userData {
  //   return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
