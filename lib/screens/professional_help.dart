// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import '../../authentication/login_auth.dart';
import '../../shared/snackbar.dart';
import '../../utils/constants.dart';
import '../../shared/resources/font_manager.dart';
import '../../shared/resources/styles_manager.dart';
import '../../shared/resources/values_manager.dart';
import 'package:get/get.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final Stream<QuerySnapshot> _helplineStream = FirebaseFirestore.instance
      .collection('helpline_and_resources')
      .snapshots();

  List<String> helpIDs = [];

  Future getHelpID() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('helpline_and_resources')
        .get();

    setState(() {
      snapshot.docs.forEach((element) {
        helpIDs.add(element.reference.id);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getHelpID();
  }

  @override
  Widget build(BuildContext context) {
    void showDeleteOptions(DocumentSnapshot resource, Color color) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Do you want to delete ${resource['helpName']}?',
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
                  FirebaseFirestore.instance
                      .collection('helpline_and_resources')
                      .doc(resource.id)
                      .delete();
                  showSnackBar('Resource deleted successfully!', context);
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

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.fitWidth),
        color: myDarkPurple,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 16, top: 50, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Helpline & Resources',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato-Bold',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                    icon: Icon(
                      Icons.home,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _helplineStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "En error occured!",
                        style: getRegularStyle(color: myRedAccent),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Loading();
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No data available",
                        style: getRegularStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var helpData = snapshot.data!.docs[index];
                      return Container(
                        margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        padding: EdgeInsets.all(15),
                        // constraints: BoxConstraints(
                        //   minHeight: 150,
                        // ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Text(
                                helpData['helpName'],
                                style: TextStyle(
                                  fontFamily: 'Lato-Bold',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Lato-Bold',
                                    fontSize: 16,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Contact Number: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: helpData['hotline'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xCC384F7D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Lato-Bold',
                                    fontSize: 16,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Email: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: helpData['helpEmail'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xCC384F7D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Lato-Bold',
                                    fontSize: 16,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Website: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[700],
                                      ),
                                    ),
                                    TextSpan(
                                      text: helpData['website'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xCC384F7D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              child: Text(
                                helpData['description'],
                                style: TextStyle(
                                  fontFamily: 'Lato-Bold',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.brown[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
