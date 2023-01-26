import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/self_treatment/self_treatment.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/shared/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../authentication/professional_help_auth.dart';
import '../../../utils/constants.dart';
import 'package:get/get.dart';

class DepressionTab extends StatefulWidget {
  const DepressionTab({Key? key}) : super(key: key);

  @override
  State<DepressionTab> createState() => _DepressionTabState();
}

class _DepressionTabState extends State<DepressionTab> {
  final user = FirebaseAuth.instance.currentUser!;
  final scoreRef = FirebaseFirestore.instance.collection('screening_score');
  final Stream<QuerySnapshot> _scoreStream =
      FirebaseFirestore.instance.collection('screening_score').snapshots();
  final _scoreFuture =
      FirebaseFirestore.instance.collection('screening_score').get();

  var depressionScore;
  var depressionSeverity;
  var timestamp;

  Future<void> getScore() async {
    var scoreSnapshot = await scoreRef.doc(user.uid).get();
    if (!scoreSnapshot.exists) {
      depressionScore = 0;
      depressionSeverity = "None";
      timestamp = Timestamp.now();
    } else {
      setState(() {
        depressionScore = scoreSnapshot.get('depressionScore');
        depressionSeverity = scoreSnapshot.get('depressionSeverity');
        timestamp = scoreSnapshot.get('timestamp');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getScore();
    depressionScore = 0;
    depressionSeverity = "None";
    timestamp = Timestamp.now();
  }

  Color severityColor() {
    if (depressionScore == 0) {
      return Colors.grey;
    } else if (depressionScore < 5) {
      return Colors.green;
    } else if (depressionScore < 7) {
      return Colors.blue;
    } else if (depressionScore < 11) {
      return Colors.yellow;
    } else if (depressionScore < 14) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData('Depression', depressionScore, severityColor()),
    ];
    return Scaffold(
      body: StreamBuilder<Object>(
          stream: _scoreStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    SafeArea(
                      child: SfCircularChart(
                        annotations: [
                          CircularChartAnnotation(
                            widget: Text(
                              depressionScore.toString(),
                              style: const TextStyle(
                                fontFamily: 'lato',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: myMediumPurple,
                              ),
                            ),
                          ),
                        ],
                        series: <CircularSeries<ChartData, String>>[
                          RadialBarSeries<ChartData, String>(
                            maximumValue: 21,
                            radius: '100%',
                            gap: '30%',
                            dataSource: chartData,
                            // cornerStyle: CornerStyle.bothCurve,
                            xValueMapper: (ChartData data, _) => data.category,
                            yValueMapper: (ChartData data, _) => data.score,
                            pointColorMapper: (ChartData data, _) => data.color,
                            enableTooltip: true,
                            // dataLabelSettings: DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 16,
                        bottom: 50,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Severity: ",
                                style: TextStyle(
                                  color: myDarkPurple,
                                  fontFamily: 'lato-bold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                depressionSeverity,
                                style: TextStyle(
                                  color: severityColor(),
                                  fontFamily: 'lato-bold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date: ",
                                style: TextStyle(
                                  color: myDarkPurple,
                                  fontFamily: 'lato-bold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd()
                                    .format(timestamp.toDate()),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'lato-bold',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  style: mainDarkOutlinedButton,
                                  onPressed: (() {
                                    Get.to(() => SelfTreatmentPage());
                                  }),
                                  child: const Text(
                                    'View Selfcare',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ),
                                OutlinedButton(
                                  style: mainLightOutlinedButton,
                                  onPressed: (() {
                                    Get.to(() => ProfessionalHelpAuth());
                                  }),
                                  child: const Text(
                                    'Get Professional Help',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: myDarkPurple,
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Loading();
          }),
    );
  }
}

class ChartData {
  ChartData(this.category, this.score, this.color);
  final String category;
  final int score;
  final Color color;
}
