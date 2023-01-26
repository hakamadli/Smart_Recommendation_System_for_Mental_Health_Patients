import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/utils.dart';

class TherapistField {
  static final String lastMessageTime = 'lastMessageTime';
}

class Therapist {
  final String uid;
  final String email;
  final String name;
  final String organization;
  final String specialization;
  final int exp;
  final DateTime lastMessageTime;

  Therapist({
    required this.uid,
    required this.email,
    required this.name,
    required this.organization,
    required this.specialization,
    required this.exp,
    required this.lastMessageTime,
  });

  Therapist copyWith({
    String? uid,
    String? email,
    String? name,
    String? organization,
    String? specialization,
    int? exp,
    String? lastMessageTime,
  }) =>
      Therapist(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        organization: organization ?? this.organization,
        specialization: specialization ?? this.specialization,
        exp: exp ?? this.exp,
        lastMessageTime: lastMessageTime != null
            ? Utils.fromStringToDateTime(lastMessageTime)
            : this.lastMessageTime,
      );

  static Therapist fromJson(Map<String, dynamic> json) => Therapist(
        uid: json['uid'],
        email: json['email'],
        name: json['name'],
        organization: json['organization'],
        specialization: json['specialization'],
        exp: json['exp'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'organization': organization,
        'specialization': specialization,
        'exp': exp,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };

  factory Therapist.fromDocument(DocumentSnapshot doc) {
    return Therapist(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      organization: doc['organization'],
      specialization: doc['specialization'],
      exp: doc['exp'],
      lastMessageTime: doc['lastMessageTime'].toDate(),
    );
  }
}
