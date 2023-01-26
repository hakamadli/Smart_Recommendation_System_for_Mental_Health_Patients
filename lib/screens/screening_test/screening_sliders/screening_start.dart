// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class ScreeningStart extends StatefulWidget {
  @override
  _ScreeningStartState createState() => _ScreeningStartState();
}

class _ScreeningStartState extends State<ScreeningStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 3,),
              Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                  width: 311,
                  height: 311,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/heart2.png'),
                        opacity: 0.1,
                        fit: BoxFit.fitWidth),
                  ),
                ),
                Container(
                    width: 184,
                    height: 184,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/heart2.png'),
                          opacity: 0.2,
                          fit: BoxFit.fitWidth),
                    )),
                Container(
                    width: 184,
                    height: 184,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/heart1.png'),
                          fit: BoxFit.fitWidth),
                    )),
              ]),
              SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                // height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Are you a person who has: ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            '• Feeling of sadness or down?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            '• Confused thinking or reduced ability to concentrate?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            '• Significant tiredness, low energy or problems sleeping?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'If your answer is "Yes" to any of the above, kindly assess your mental health status',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: myLightPurple,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Spacer(flex: 3,),
            ]),
      ),
    );
  }
}