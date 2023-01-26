import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data.dart';
import '../models/message.dart';
import '../models/therapist.dart';
import '../models/user.dart';
import '../utils/utils.dart';

class FirebaseApi {
  final user = FirebaseAuth.instance.currentUser!;
  static Stream<List<Therapist>> getTherapists() => FirebaseFirestore.instance
      .collection('therapists')
      .orderBy(TherapistField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(Therapist.fromJson));

  static Future uploadMessage(String uid, String message, String ownerID) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$uid/messages');
    final refMessages2 =
        FirebaseFirestore.instance.collection('chats/$ownerID/messages');

    final newMessage = Message(
      idUser: Data.myId,
      username: Data.myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());
    await refMessages2.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('therapists');
    await refUsers.doc(uid).update({TherapistField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String uid) =>
      FirebaseFirestore.instance
          .collection('chats/$uid/messages')
          // .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<Therapist> therapists) async {
    final refUsers = FirebaseFirestore.instance.collection('therapists');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final therapist in therapists) {
        final userDoc = refUsers.doc();
        final newUser = therapist.copyWith(uid: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }
}
