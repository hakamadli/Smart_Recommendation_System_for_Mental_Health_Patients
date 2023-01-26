import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/screening_result_auth.dart';
import '../models/screening/questions.dart';

// We use get package for our state management

class QuestionController extends GetxController
    // ignore: deprecated_member_use
    with
        // ignore: deprecated_member_use
        SingleGetTickerProviderMixin {
  // Lets animated our progress bar

  late AnimationController _animationController;
  late Animation _animation;
  // so that we can access our animation outside
  Animation get animation => this._animation;

  late PageController _pageController;
  PageController get pageController => this._pageController;

  List<Question> _questions = dass21
      .map(
        (question) => Question(
          id: question['id'],
          question: question['question'],
          options: question['options'],
        ),
      )
      .toList();
  List<Question> get questions => this._questions;
  final DateTime timestamp = DateTime.now();

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  bool _isTeen = false;
  bool get isTeen => this._isTeen;

  bool _isYoungAdult = false;
  bool get isYoungAdult => _isYoungAdult;

  bool _isAdult = false;
  bool get isAdult => _isAdult;

  late int _selectedAns;
  int get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  // int _numOfCorrectAns = 0;
  // int get numOfCorrectAns => this._numOfCorrectAns;

  int _depressionScore = 0;
  int get depressionScore => this._depressionScore;

  String _depressionSeverity = '';
  String get depressionSeverity => this._depressionSeverity;

  int _totalDepressionScore = 0;
  int get totalDepressionScore => this._totalDepressionScore;

  int _anxietyScore = 0;
  int get anxietyScore => this._anxietyScore;

  String _anxietySeverity = '';
  String get anxietySeverity => this._anxietySeverity;

  int _totalAnxietyScore = 0;
  int get totalAnxietyScore => this._totalAnxietyScore;

  int _stressScore = 0;
  int get stressScore => this._stressScore;

  String _stressSeverity = '';
  String get stressSeverity => this._stressSeverity;

  int _totalStressScore = 0;
  int get totalStressScore => this._totalStressScore;

  TextEditingController _ageController = TextEditingController();

  var yearNow = DateTime.now().year;

  late int _age;
  int get age => this._age;

  String uid = FirebaseAuth.instance.currentUser?.uid as String;

  Future<int> getUserAge() async {
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);
    await userRef.get().then((snapshot) {
      _age = snapshot.data()!['age'];
    });
    setUserAgeGroup(_age);
    return _age;
  }

  void setUserAgeGroup(int age) {
    if (_age <= 21) {
      _isTeen = true;
    } else if (_age > 21 && _age <= 30) {
      _isYoungAdult = true;
    } else {
      _isAdult = true;
    }
  }

  void resetAnswers() {
    _isAnswered = false;
    _questionNumber = 1.obs;
  }

  // called immediately after the widget is allocated memory
  @override
  Future<void> onInit() async {
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn
    _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    await getUserAge();
    setUserAgeGroup(_age);
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _selectedAns = selectedIndex;

    if (_questionNumber.value == 3 ||
        _questionNumber.value == 5 ||
        _questionNumber.value == 10 ||
        _questionNumber.value == 13 ||
        _questionNumber.value == 16 ||
        _questionNumber.value == 17 ||
        _questionNumber.value == 21) {
      if (_selectedAns == 0) {
        _depressionScore = _depressionScore + 3;
      } else if (_selectedAns == 1) {
        _depressionScore = _depressionScore + 2;
      } else if (_selectedAns == 2) {
        _depressionScore = _depressionScore + 1;
      } else if (_selectedAns == 3) {
        _depressionScore = _depressionScore + 0;
      }
    } else if (_questionNumber.value == 2 ||
        _questionNumber.value == 4 ||
        _questionNumber.value == 7 ||
        _questionNumber.value == 9 ||
        _questionNumber.value == 15 ||
        _questionNumber.value == 19 ||
        _questionNumber.value == 20) {
      if (_selectedAns == 0) {
        _anxietyScore = _anxietyScore + 3;
      } else if (_selectedAns == 1) {
        _anxietyScore = _anxietyScore + 2;
      } else if (_selectedAns == 2) {
        _anxietyScore = _anxietyScore + 1;
      } else if (_selectedAns == 3) {
        _anxietyScore = _anxietyScore + 0;
      }
    } else if (_questionNumber.value == 1 ||
        _questionNumber.value == 6 ||
        _questionNumber.value == 8 ||
        _questionNumber.value == 11 ||
        _questionNumber.value == 12 ||
        _questionNumber.value == 14 ||
        _questionNumber.value == 18) {
      if (_selectedAns == 0) {
        _stressScore = _stressScore + 3;
      } else if (_selectedAns == 1) {
        _stressScore = _stressScore + 2;
      } else if (_selectedAns == 2) {
        _stressScore = _stressScore + 1;
      } else if (_selectedAns == 3) {
        _stressScore = _stressScore + 0;
      }
    }

    if (_depressionScore < 5) {
      _depressionSeverity = "Normal";
    } else if (_depressionScore < 7) {
      _depressionSeverity = "Mild";
    } else if (_depressionScore < 11) {
      _depressionSeverity = "Moderate";
    } else if (_depressionScore < 14) {
      _depressionSeverity = "Severe";
    } else {
      _depressionSeverity = "Extremely Severe";
    }

    if (_anxietyScore < 4) {
      _anxietySeverity = "Normal";
    } else if (_anxietyScore < 6) {
      _anxietySeverity = "Mild";
    } else if (_anxietyScore < 8) {
      _anxietySeverity = "Moderate";
    } else if (_anxietyScore < 10) {
      _anxietySeverity = "Severe";
    } else {
      _anxietySeverity = "Extremely Severe";
    }

    if (_stressScore < 8) {
      _stressSeverity = "Normal";
    } else if (_stressScore < 10) {
      _stressSeverity = "Mild";
    } else if (_stressScore < 13) {
      _stressSeverity = "Moderate";
    } else if (_stressScore < 17) {
      _stressSeverity = "Severe";
    } else {
      _stressSeverity = "Extremely Severe";
    }

    // It will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  Future<void> nextQuestion() async {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      await updateStats(
        _isTeen,
        _isYoungAdult,
        _isAdult,
        _depressionScore,
        _anxietyScore,
        _stressScore,
      );

      await updateScore(uid, _depressionScore, _anxietyScore, _stressScore,
              _depressionSeverity, _anxietySeverity, _stressSeverity, timestamp)
          .then((value) => Get.to(() => ScoreAuthPage()));
    }
  }

  updateStats(bool userIsTeen, bool userIsYoungAdult, bool userIsAdult,
      int depressionScore, int anxietyScore, int stressScore) {
    if (userIsTeen) {
      log("I am a Teen");
      if (_depressionScore >= 7) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('depressionStats_$yearNow')
            .set({'teenWithDepression': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
      if (_anxietyScore >= 6) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('anxietyStats_$yearNow')
            .set({'teenWithAnxiety': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
      if (_stressScore >= 10) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('stressStats_$yearNow')
            .set({'teenWithStress': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
    } else if (userIsYoungAdult) {
      log("I am a Young Adult");
      if (_depressionScore >= 7) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('depressionStats_$yearNow')
            .set({'youngAdultWithDepression': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
      if (_anxietyScore >= 6) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('anxietyStats_$yearNow')
            .set({'youngAdultWithAnxiety': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
      if (_stressScore >= 10) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('stressStats_$yearNow')
            .set({'youngAdultWithStress': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
    } else {
      log("I am an Adult");
      if (_depressionScore >= 7) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('depressionStats_$yearNow')
            .set({'adultWithDepression': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
      if (_anxietyScore >= 6) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('anxietyStats_$yearNow')
            .set({'adultWithAnxiety': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
      if (_stressScore >= 10) {
        FirebaseFirestore.instance
            .collection('mental_statistics')
            .doc('stressStats_$yearNow')
            .set({'adultWithStress': FieldValue.increment(1), 'year': yearNow},
                SetOptions(merge: true));
      }
    }
  }

  Future updateScore(
      String uid,
      int depressionScore,
      int anxietyScore,
      int stressScore,
      String depressionSeverity,
      String anxietySeverity,
      String stressSeverity,
      DateTime timestamp) async {
    await FirebaseFirestore.instance
        .collection('screening_score')
        .doc(uid)
        .set({
      'depressionScore': _depressionScore,
      'anxietyScore': _anxietyScore,
      'stressScore': _stressScore,
      'depressionSeverity': _depressionSeverity,
      'anxietySeverity': _anxietySeverity,
      'stressSeverity': _stressSeverity,
      'timestamp': timestamp,
    });
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}
