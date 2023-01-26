import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/utils/constants.dart';
import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'edit.dart';
import '../resources/values_manager.dart';
import 'package:intl/intl.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({Key? key, required this.note}) : super(key: key);
  final DocumentSnapshot note;

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState(note: note);
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  _ViewNoteScreenState({Key? key, required this.note});
  final DocumentSnapshot note;

  @override
  void initState() {
    super.initState();
  }

  // late Stream documentStream =
  //     FirebaseFirestore.instance.collection('journal').doc(note.id).snapshots();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> notesStream = firebase
        .collection('journal')
        .where('uid', isEqualTo: userId)
        .snapshots();
    Stream<DocumentSnapshot> documentStream = FirebaseFirestore.instance
        .collection('journal')
        .doc(note.id)
        .snapshots();
    var date = DateTime.fromMicrosecondsSinceEpoch(
        widget.note['date'].microsecondsSinceEpoch);

    // navigate to edit screen
    void navigateToEdit() {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(note: widget.note),
            ),
          )
          .then((value) => setState(() {}));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: myMediumPurple,
        onPressed: () => navigateToEdit(),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: AppSize.s35,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.only(left: 18),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        title: Text(
          'View Note',
          style: getRegularStyle(
            color: Colors.white,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      body: StreamBuilder<Object>(
          stream: documentStream,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: myPeach,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, right: 16),
                                child: Text(
                                  snapshot.data.get('title'),
                                  style: getMediumStyle(
                                    color: myDarkPurple,
                                    fontSize: FontSize.s28,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd().format(date),
                                style: getRegularStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        Image.asset(
                          snapshot.data.get('emotion'),
                          height: 60,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: myPeach,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 40,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Text(
                          snapshot.data.get('content'),
                          textAlign: snapshot.data.get('isJustified')
                              ? TextAlign.justify
                              : snapshot.data.get('isLeftAligned')
                                  ? TextAlign.left
                                  : snapshot.data.get('isRightAligned')
                                      ? TextAlign.right
                                      : snapshot.data.get('isJustified')
                                          ? TextAlign.center
                                          : TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: FontSize.s16,
                            fontWeight: snapshot.data.get('isBold')
                                ? FontWeightManager.bold
                                : FontWeightManager.normal,
                            decoration: snapshot.data.get('isUnderlined')
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            fontStyle: snapshot.data.get('isItalics')
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return Loading();
          }),
    );
  }
}
