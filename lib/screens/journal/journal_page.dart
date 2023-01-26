import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/journal/components/create.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/journal/resources/styles_manager.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import '../../utils/constants.dart';
import '../../authentication/login_auth.dart';
import '../../shared/loading.dart';
import 'package:intl/intl.dart';
import 'components/edit.dart';
import 'components/snackbar.dart';
import 'components/view.dart';
import 'resources/assets_manager.dart';
import 'resources/font_manager.dart';
import 'resources/route_manager.dart';
import 'resources/values_manager.dart';
import 'package:get/get.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _settingsFormKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> notesStream = firebase
        .collection('journal')
        .where('uid', isEqualTo: userId)
        .snapshots();

    Size size = MediaQuery.of(context).size;

    // navigate to settings
    void navigateToSettings() {
      Navigator.of(context).pushNamed(RouteManager.settingsScreen);
    }

    // navigate to edit screen
    void createNew() {
      Get.to(CreateNoteScreen());
    }

    // view entry
    void viewEntry(DocumentSnapshot note) {
      // Todo: Implement view Entry
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => ViewNoteScreen(note: note),
            ),
          )
          .then((value) => Navigator.of(context).pop());
    }

    // show dialog for delete
    void showDeleteOptions(DocumentSnapshot note, Color color) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Do you want to delete ${note['title']}?',
            style: TextStyle(
              color: color,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  firebase.collection('journal').doc(note.id).delete();
                  if (note['emotion_index'] == 0 || note['emotion_index'] == 1) {
                    firebase.collection('user_mood').doc(user.uid).set({
                      'happy': FieldValue.increment(-1)
                    }, SetOptions(merge: true));
                  } else if (note['emotion_index'] == 2) {
                    firebase.collection('user_mood').doc(user.uid).set({
                      'neutral': FieldValue.increment(-1)
                    }, SetOptions(merge: true));
                  } else if (note['emotion_index'] == 3 || note['emotion_index'] == 4) {
                    firebase.collection('user_mood').doc(user.uid).set({
                      'sad': FieldValue.increment(-1)
                    }, SetOptions(merge: true));
                  }
                  showSnackBar('Note deleted successfully!', context);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: myDarkPurple,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Yes',
                  style: getRegularStyle(
                    color: myDarkPurple,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: myRed,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Cancel',
                  style: getRegularStyle(
                    color: color,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // edit entry
    void editEntry(DocumentSnapshot note) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(note: note),
            ),
          )
          .then((value) => Navigator.of(context).pop());
    }

    // show options
    void showOptions(DocumentSnapshot note, Color color) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => viewEntry(note),
                icon: Icon(
                  Icons.visibility,
                  color: color,
                  size: AppSize.s25,
                ),
                label: Text(
                  'View Note',
                  style: getRegularStyle(
                    color: color,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => editEntry(note),
                icon: Icon(
                  Icons.edit,
                  color: color,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Edit Note',
                  style: getRegularStyle(
                    color: color,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => showDeleteOptions(note, color),
                icon: const Icon(
                  Icons.delete,
                  color: myRed,
                  size: AppSize.s25,
                ),
                label: Text(
                  'Delete Note',
                  style: getRegularStyle(
                    color: color,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF543E7A),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: myMediumPurple,
          onPressed: (() {
            createNew();
          }),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 50, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Journal",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Lato-Bold',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginAuthPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.home,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(30),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                child: StreamBuilder(
                  stream: notesStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "En error occured!",
                          style: getRegularStyle(color: myRedAccent),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Loading(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "Write something!",
                          style: getRegularStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        var note = snapshot.data!.docs[index];
                        var date = DateTime.fromMicrosecondsSinceEpoch(
                            note['date'].microsecondsSinceEpoch);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            height: size.height * 0.15,
                            child: GestureDetector(
                              onTap: () => showOptions(note, myDarkPurple),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: myPeach,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width / 1.5,
                                                child: Text(
                                                  note['title'],
                                                  style: getBoldStyle(
                                                    color: myDarkPurple,
                                                    fontSize: FontSize.s16,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                width: size.width / 1.5,
                                                child: Text(
                                                  note['content'],
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: getRegularStyle(
                                                    color: myMediumPurple,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            DateFormat.yMMMMEEEEd()
                                                .format(date),
                                            style: getRegularStyle(
                                              color: Colors.grey,
                                              fontWeight:
                                                  FontWeightManager.light,
                                              fontSize: FontSize.s12,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: size.height * 0.06,
                                          child: Image.asset(
                                            note['emotion'],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
