import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/question_controller.dart';
import 'components/body.dart';
import 'package:get/get.dart';

class ScreeningTestPage extends StatefulWidget {
  const ScreeningTestPage({super.key});

  @override
  State<ScreeningTestPage> createState() => _ScreeningTestPageState();
}

class _ScreeningTestPageState extends State<ScreeningTestPage> {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   ElevatedButton(
        //       onPressed: _controller.nextQuestion,
        //       child: Text("Skip")),
        // ],
      ),
      body: Body(),
    );
  }
}
