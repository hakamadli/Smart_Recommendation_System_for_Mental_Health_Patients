import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../utils/utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String uid;
  final String email;
  final String name;
  final int age;
  final DateTime lastMessageTime;

  // static Function(Map<String, dynamic> json) fromJson;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
    required this.lastMessageTime,
  });

  User copyWith({
    String? uid,
    String? email,
    String? name,
    String? lastMessageTime,
  }) =>
      User(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        age: age,
        lastMessageTime: lastMessageTime != null
            ? Utils.fromStringToDateTime(lastMessageTime)
            : this.lastMessageTime,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        uid: json['uid'],
        email: json['email'],
        name: json['name'],
        age: json['age'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      age: doc['age'],
      lastMessageTime: doc['lastMessageTime'].toDate(),
    );
  }
}
