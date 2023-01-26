import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/self_treatment/self_treatment.dart';
import '../../../../authentication/login_auth.dart';
import '../../../../utils/constants.dart';

class ViewRemediesPage extends StatefulWidget {
  const ViewRemediesPage({Key? key, required this.treatment}) : super(key: key);
  final DocumentSnapshot treatment;

  @override
  State<ViewRemediesPage> createState() =>
      _ViewRemediesPageState(treatment: treatment);
}

class _ViewRemediesPageState extends State<ViewRemediesPage> {
  _ViewRemediesPageState({Key? key, required this.treatment});
  final DocumentSnapshot treatment;

  @override
  void initState() {
    super.initState();
    getRemedies();
  }

  int _currentPage = 0;
  int _pageIndex = 0;
  int _remedyIndex = 3;
  PageController _pageController = PageController();

  void getRemedies() {
    FirebaseFirestore.instance
        .collection('treatment_remedies')
        .where('treatmentID', isEqualTo: treatment.id)
        .get()
        .then((snapshot) => snapshot.docs.forEach((result) {
              setState(() {
                final data = result.data();
                _remedyTitles.add(data['remedyTitle']);
                _remedyDesc.add(data['remedyDescription']);
                _pageIndex++;
              });

              // print(_remedyTitles);
              // print(_remedyDesc);
            }));
  }

  final List<Widget> _pages = [];
  final List<String> _remedyTitles = [];
  final List<String> _remedyDesc = [];

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              onPageChanged: _onChanged,
              controller: _pageController,
              itemCount: _remedyTitles.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _remedyTitles[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16,),
                        Text(
                          _remedyDesc[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Remedies",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Lato-Bold',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: (() {
                      Get.to(() => SelfTreatmentPage());
                    }),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List<Widget>.generate(_remedyTitles.length, (int index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 10,
                      width: (index == _currentPage) ? 30 : 10,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: (index == _currentPage)
                            ? Colors.white
                            : myLightPurple,
                      ),
                    );
                  }),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: (_currentPage == (_remedyTitles.length - 1))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (() {
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 800),
                                    curve: Curves.easeInOutQuint);
                              }),
                              icon: const Icon(
                                Icons.navigate_before,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            OutlinedButton(
                              style: getStartedOutlinedButton,
                              onPressed: () {
                                Get.to(() => SelfTreatmentPage());
                              },
                              child: const Text(
                                "Done",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Lato',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: (() {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutQuint);
                          }),
                          icon: const Icon(
                            Icons.navigate_next,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
