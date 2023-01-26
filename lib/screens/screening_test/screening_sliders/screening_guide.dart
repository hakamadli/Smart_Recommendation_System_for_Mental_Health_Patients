import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class ScreeningGuide extends StatefulWidget {
  const ScreeningGuide({super.key});

  @override
  State<ScreeningGuide> createState() => _ScreeningGuideState();
}

class _ScreeningGuideState extends State<ScreeningGuide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(
                  flex: 2,
                ),
                SizedBox(
                  width: 320,
                  // height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'DASS-21',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato-Bold',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'DEPRESSION, ANXIETY AND STRESS SCALE - 21 ITEMS',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato-Bold',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'PLEASE READ EACH STATEMENT AND PICK A NUMBER 0, 1, 2 OR 3 WHICH INDICATES HOW MUCH THE STATEMENT APPLIED TO YOU OVER THE PAST WEEK. THERE ARE NO RIGHT OR WRONG ANSWERES. DO NOT SPEND TOO MUCH TIME ON ANY STATEMENT.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato-Bold',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'THE RATING SCALE IS AS FOLLOWS:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato-Bold',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: const [
                          Text(
                            '0 ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '- ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: myLightPurple,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'DID NOT APPLY TO ME AT ALL (NEVER)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: myLightPurple,
                                fontFamily: 'Lato-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: const [
                          Text(
                            '1 ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '- ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: myLightPurple,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'APPLIED TO ME TO SOME DEGREE, OR SOME OF THE TIME (SOMETIMES)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: myLightPurple,
                                fontFamily: 'Lato-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: const [
                          Text(
                            '2 ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '- ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: myLightPurple,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'APPLIED TO ME TO A CONSIDERABLE DEGREE OR A GOOD PART OF TIME (OFTEN)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: myLightPurple,
                                fontFamily: 'Lato-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: const [
                          Text(
                            '3 ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '- ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: myLightPurple,
                              fontFamily: 'Lato-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'APPLIED TO ME VERY MUCH OR MOST OF THE TIME (ALMOST ALWAYS)',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: myLightPurple,
                                fontFamily: 'Lato-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
              ]),
        ),
      ),
    );
  }
}
