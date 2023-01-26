import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/utils/constants.dart';
import '../components/note_content.dart';
import '../components/note_title.dart';
import '../components/snackbar.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';
import '../resources/values_manager.dart';
import 'package:intl/intl.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key, required this.note}) : super(key: key);
  final DocumentSnapshot note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState(note: note);
}

enum TextDirection {
  right,
  left,
  justify,
  center,
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  _EditNoteScreenState({Key? key, required this.note});
  final DocumentSnapshot note;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var date = DateTime.now();
  bool isLoading = false;

  bool isBold = false;
  bool isItalics = false;
  bool isUnderlined = false;
  bool isJustified = true;
  bool isLeftAligned = false;
  bool isRightAligned = false;
  bool isCentered = false;

  // set details
  Future<void> setNoteDetails() async {
    var noteSnapshot = await FirebaseFirestore.instance
        .collection('journal')
        .doc(note.id)
        .get();
    setState(() {
      _titleController.text = noteSnapshot.get('title');
      _contentController.text = noteSnapshot.get('content');
      date = DateTime.fromMicrosecondsSinceEpoch(
          noteSnapshot.get('date').microsecondsSinceEpoch);
      isBold = noteSnapshot.get('isBold');
      isItalics = noteSnapshot.get('isItalics');
      isUnderlined = noteSnapshot.get('isUnderlined');
      isJustified = noteSnapshot.get('isJustified');
      isLeftAligned = noteSnapshot.get('isLeftAligned');
      isRightAligned = noteSnapshot.get('isRightAligned');
      isCentered = noteSnapshot.get('isCentered');
      currentEmotionIndex = noteSnapshot.get('emotion_index');
      emotionIndex = noteSnapshot.get('emotion_index');
    });
  }

  @override
  void initState() {
    super.initState();
    setNoteDetails();
  }

  // toggle bold
  void toggleBold() {
    setState(() {
      isBold = !isBold;
    });
  }

  // toggle underline
  void toggleUnderline() {
    setState(() {
      isUnderlined = !isUnderlined;
    });
  }

  // toggle Italics
  void toggleItalics() {
    setState(() {
      isItalics = !isItalics;
    });
  }

  // toggle between justify,left-aligned and right-aligned
  void toggleTextDirection(TextDirection direction) {
    switch (direction) {
      case TextDirection.right:
        setState(() {
          isRightAligned = true;
          isJustified = false;
          isLeftAligned = false;
          isCentered = false;
        });
        break;

      case TextDirection.center:
        setState(() {
          isRightAligned = false;
          isJustified = false;
          isLeftAligned = false;
          isCentered = true;
        });
        break;

      case TextDirection.left:
        setState(() {
          isRightAligned = false;
          isJustified = false;
          isLeftAligned = true;
          isCentered = false;
        });
        break;

      case TextDirection.justify:
        setState(() {
          isRightAligned = false;
          isJustified = true;
          isLeftAligned = false;
          isCentered = false;
        });
        break;
    }
  }

  var currentEmotionIndex;
  var emotionIndex;
  final List<String> emotions = [
    AssetManager.happy,
    AssetManager.smile,
    AssetManager.eh,
    AssetManager.sad,
    AssetManager.aww,
  ];

  Widget emotionBox(String emotion, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        currentEmotionIndex = index;
      }),
      child: CircleAvatar(
        backgroundColor:
            currentEmotionIndex == index ? myRedAccent : Colors.transparent,
        child: Image.asset(
          emotion,
          height: 30,
        ),
      ),
    );
  }

  // save note
  void saveNote() {
    FocusScope.of(context).unfocus();

    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar("Whoops, don't leave anything empty!", context);
      return;
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        FirebaseFirestore.instance
            .collection('journal')
            .doc(widget.note.id)
            .update({
          'uid': uid,
          'date': date,
          'title': _titleController.text.trim(),
          'content': _contentController.text.trim(),
          'emotion': emotions[currentEmotionIndex],
          'emotion_index': currentEmotionIndex,
          'isBold': isBold,
          'isItalics': isItalics,
          'isUnderlined': isUnderlined,
          'isJustified': isJustified,
          'isLeftAligned': isLeftAligned,
          'isRightAligned': isRightAligned,
          'isCentered': isCentered,
        });
        Timer(const Duration(seconds: 4), () {
          Navigator.of(context).pop();
          showSnackBar('Note edited!', context);
        });
        switch (emotionIndex) {
          case 0:
            {
              if (currentEmotionIndex == 0 || currentEmotionIndex == 1) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 2) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(-1),
                  'neutral': FieldValue.increment(1),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 3 || currentEmotionIndex == 4) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(-1),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(1),
                  'date': date,
                }, SetOptions(merge: true));
              }
            }
            break;
          case 1:
            {
              if (currentEmotionIndex == 0 || currentEmotionIndex == 1) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 2) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(-1),
                  'neutral': FieldValue.increment(1),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 3 || currentEmotionIndex == 4) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(-1),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(1),
                  'date': date,
                }, SetOptions(merge: true));
              }
            }
            break;
          case 2:
            {
              if (currentEmotionIndex == 0 || currentEmotionIndex == 1) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(1),
                  'neutral': FieldValue.increment(-1),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 2) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 3 || currentEmotionIndex == 4) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(-1),
                  'sad': FieldValue.increment(1),
                  'date': date,
                }, SetOptions(merge: true));
              }
            }
            break;
          case 3:
            {
              if (currentEmotionIndex == 0 || currentEmotionIndex == 1) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(1),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(-1),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 2) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(1),
                  'sad': FieldValue.increment(-1),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 3 || currentEmotionIndex == 4) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              }
            }
            break;
          case 4:
            {
              if (currentEmotionIndex == 0 || currentEmotionIndex == 1) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(1),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(-1),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 2) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(1),
                  'sad': FieldValue.increment(-1),
                  'date': date,
                }, SetOptions(merge: true));
              } else if (currentEmotionIndex == 3 || currentEmotionIndex == 4) {
                FirebaseFirestore.instance
                    .collection('user_mood')
                    .doc(uid)
                    .set({
                  'happy': FieldValue.increment(0),
                  'neutral': FieldValue.increment(0),
                  'sad': FieldValue.increment(0),
                  'date': date,
                }, SetOptions(merge: true));
              }
            }
            break;
        }
      } on FirebaseException catch (e) {
        showSnackBar('An error occurred! ${e.message}', context);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(myDarkPurple),
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          WidgetsBinding.instance.window.viewInsets.bottom > 0.0
              ? FloatingActionButton(
                  backgroundColor: myDarkPurple,
                  onPressed: () => FocusScope.of(context).unfocus(),
                  child: const Icon(
                    Icons.keyboard,
                    color: Colors.white,
                    size: AppSize.s35,
                  ),
                )
              : const SizedBox.shrink(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          DateFormat.yMMMMEEEEd().format(date),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      NoteTitle(
                        titleController: _titleController,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: myPeach,
                  ),
                  child: formattingWidget(myDarkPurple),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
                child: NoteContent(
                  color: Colors.black87,
                  contentController: _contentController,
                  isBold: isBold,
                  isUnderlined: isUnderlined,
                  isItalics: isItalics,
                  isJustified: isJustified,
                  isLeftAligned: isLeftAligned,
                  isRightAligned: isRightAligned,
                  isCentered: isCentered,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: bottomEmotionSelector(
        size,
        Colors.white,
        myDarkPurple,
      ),
    );
  }

  // EXTRACTED METHODS

  // appbar
  AppBar buildAppBar(Color color) {
    return AppBar(
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
      actions: [
        !isLoading
            ? IconButton(
                padding: const EdgeInsets.only(right: 18),
                onPressed: () => saveNote(),
                icon: const Icon(
                  Icons.save,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(color: Colors.white),
                    height: 18,
                    width: 18,
                  ),
                ),
              ),
      ],
      title: Text(
        'Edit note',
        style: getRegularStyle(
          color: Colors.white,
          fontWeight: FontWeightManager.medium,
          fontSize: FontSize.s18,
        ),
      ),
    );
  }

  // Container for emotions
  Container bottomEmotionSelector(Size size, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 55,
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mood',
            style: getMediumStyle(
              color: color,
              fontSize: FontSize.s16,
            ),
          ),
          // SizedBox(width: 50,),
          SizedBox(
            width: size.width / 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emotions.length,
              itemBuilder: (context, index) => emotionBox(
                emotions[index],
                index,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // sized box that hold formatting tools
  Container formattingWidget(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.left),
            child: Icon(
              Icons.format_align_left,
              size: AppSize.s30,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.center),
            child: Icon(
              Icons.format_align_center,
              size: AppSize.s30,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.justify),
            child: Icon(
              Icons.format_align_justify,
              size: AppSize.s30,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.right),
            child: Icon(
              Icons.format_align_right,
              size: AppSize.s30,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleBold(),
            child: Icon(
              Icons.format_bold,
              size: AppSize.s30,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleItalics(),
            child: Icon(
              Icons.format_italic,
              size: AppSize.s30,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleUnderline(),
            child: Icon(
              Icons.format_underline,
              size: AppSize.s30,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
