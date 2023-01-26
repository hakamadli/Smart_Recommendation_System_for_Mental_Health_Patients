import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Data extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!;
  late String name;
  static String myId = FirebaseAuth.instance.currentUser!.uid;
  static String myUsername = '';

  Future<String> getCurrentUserData() async {
    var snapshot = await _firestore.collection("users").doc(myId).get();
    myUsername = snapshot.data()!['name'];
    return myUsername;
  }

  @override
  Future<void> onInit() async {
    await getCurrentUserData();
    super.onInit();
  }
}