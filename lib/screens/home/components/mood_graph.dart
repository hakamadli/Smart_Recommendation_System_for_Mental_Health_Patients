import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../utils/constants.dart';
import '../../journal/resources/styles_manager.dart';

final DateTime timestampNow = DateTime.now();

class MoodGraph extends StatefulWidget {
  const MoodGraph({Key? key}) : super(key: key);

  @override
  State<MoodGraph> createState() => _MoodGraphState();
}

class _MoodGraphState extends State<MoodGraph> {
  final user = FirebaseAuth.instance.currentUser!;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final moodRef = FirebaseFirestore.instance.collection('user_mood');
  final Stream<QuerySnapshot> moodStream =
      FirebaseFirestore.instance.collection('user_mood').snapshots();
  final Stream<DocumentSnapshot> docStream = FirebaseFirestore.instance
      .collection('user_mood')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  var happyCount;
  var neutralCount;
  var sadCount;
  var date;

  @override
  void initState() {
    super.initState();
    happyCount = 0;
    neutralCount = 0;
    sadCount = 0;
    getMoodCount();
  }

  Future getMoodCount() async {
    try {
      var moodSnapshot = await moodRef.doc(user.uid).get();
      setState(() {
        happyCount = moodSnapshot.get('happy');
        neutralCount = moodSnapshot.get('neutral');
        sadCount = moodSnapshot.get('sad');
        date = moodSnapshot.get('date');
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  String getEmotion() {
    if (happyCount > neutralCount && happyCount > sadCount) {
      return "assets/images/mood/happy.png";
    } else if (neutralCount > happyCount && neutralCount > sadCount) {
      return "assets/images/mood/eh.png";
    } else if (sadCount > happyCount && sadCount > neutralCount) {
      return "assets/images/mood/sad.png";
    } else if (neutralCount == sadCount && neutralCount != happyCount) {
      return "assets/images/mood/eh.png";
    } else if (happyCount == 0 && neutralCount == 0 && sadCount == 0) {
      return "assets/images/mood/mood_empty.png";
    } else if (sadCount == happyCount) {
      return "assets/images/mood/eh.png";
    } else if (happyCount == neutralCount) {
      return "assets/images/mood/smile.png";
    }
    return "assets/images/mood/happy.png";
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData('Happy', happyCount, Colors.green),
      ChartData('Neutral', neutralCount, Colors.yellow),
      ChartData('Sad', sadCount, myRedAccent),
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: StreamBuilder<QuerySnapshot>(
          stream: moodStream,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "En error occured!",
                  style: getRegularStyle(color: myRedAccent),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Loading(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: const Text(
                    "Your emotional state",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Lato-Bold',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF543E7A),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SafeArea(
                        child: SfCircularChart(
                          // title: ChartTitle(text: "Mood"),
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                              widget: Image.asset(
                                getEmotion(),
                                width: 70,
                              ),
                            ),
                          ],
                          legend: Legend(isVisible: true),
                          series: <CircularSeries<ChartData, String>>[
                            DoughnutSeries<ChartData, String>(
                              // maximumValue: 21,
                              radius: '100%',
                              startAngle: 270,
                              endAngle: 90,
                              // gap: '30%',
                              dataSource: chartData,
                              // cornerStyle: CornerStyle.bothCurve,
                              xValueMapper: (ChartData data, _) => data.mood,
                              yValueMapper: (ChartData data, _) => data.count,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              enableTooltip: true,
                              // dataLabelSettings: DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class ChartData {
  ChartData(this.mood, this.count, this.color);
  final String mood;
  final num count;
  final Color color;
}
