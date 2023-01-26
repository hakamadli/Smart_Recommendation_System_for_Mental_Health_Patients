import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/constants.dart' as Constants;

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0x33000000),
      ),
      child: const Center(
        child: SpinKitWanderingCubes(
          color: Colors.white,
        ),
      ),
    );
  }
}
