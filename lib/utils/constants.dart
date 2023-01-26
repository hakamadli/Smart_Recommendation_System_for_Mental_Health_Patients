import 'package:flutter/material.dart';

const Color myDarkBlue = Color.fromRGBO(56, 79, 125, 0.8);
const Color myDarkPurple = Color(0xFF543E7A);
const Color myMediumPurple = Color(0xFF746BA0);
const Color myLightPurple = Color(0xFFd4c6dc);
const Color myPeach = Color(0xFFfeebe4);
const Color myRedAccent = Color(0xFFff9eaf);
const Color myRed = Color(0xFFf0626e);


ButtonStyle pinkButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(254, 192, 193, 1),
  minimumSize: const Size(327, 54),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
);

ButtonStyle whiteButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(244, 249, 254, 1),
  minimumSize: const Size(327, 54),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
);

ButtonStyle darkButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF543E7A),
  minimumSize: const Size(327, 54),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
);

ButtonStyle lightButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF746BA0),
  minimumSize: const Size(327, 54),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
);

ButtonStyle darkOutlinedButton = OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  elevation: 2,
  backgroundColor: const Color(0xFF746ba0),
  shadowColor: Colors.grey[700],
);

ButtonStyle lightOutlinedButton = OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  elevation: 2,
  backgroundColor: const Color.fromRGBO(244, 249, 254, 1),
  shadowColor: Colors.grey[700],
);

ButtonStyle mainDarkOutlinedButton = OutlinedButton.styleFrom(
  minimumSize: const Size(260, 40),
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  elevation: 2,
  backgroundColor: const Color(0xFF746ba0),
  shadowColor: Colors.grey[700],
);

ButtonStyle mainLightOutlinedButton = OutlinedButton.styleFrom(
  minimumSize: const Size(260, 40),
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  elevation: 2,
  backgroundColor: const Color.fromRGBO(244, 249, 254, 1),
  shadowColor: Colors.grey[700],
);

ButtonStyle getStartedOutlinedButton = OutlinedButton.styleFrom(
  minimumSize: const Size(100, 40),
  padding: const EdgeInsets.symmetric(horizontal: 20),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  elevation: 2,
  backgroundColor: const Color(0xFF746ba0),
  shadowColor: Colors.grey[700],
);

const kSecondaryColor = Color(0xFF8B94BC);
const kGreenColor = Color(0xFF6AC259);
const kRedColor = Color(0xFFE92E30);
const kGrayColor = Color(0xFFC1C1C1);
const kBlackColor = Color(0xFF101010);
const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFF8B94BC), Color.fromRGBO(254, 192, 193, 1)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double kDefaultPadding = 20.0;