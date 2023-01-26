import 'package:flutter/material.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/login_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/authentication/screening_test_auth.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/screening_sliders/screening_guide.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/screening_sliders/screening_start.dart';
import 'package:smart_recommendation_system_for_mental_health_patients/screens/screening_test/screening_test.dart';
import '../../../utils/constants.dart';

class ScreeningSliderPage extends StatefulWidget {
  const ScreeningSliderPage({super.key});

  @override
  State<ScreeningSliderPage> createState() => _ScreeningSliderPageState();
}

class _ScreeningSliderPageState extends State<ScreeningSliderPage> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  List<Widget> _pages = [
    ScreeningStart(),
    ScreeningGuide(),
  ];

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
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginAuthPage(),
                        ),
                      );
                    }),
                    icon: const Icon(
                      Icons.home,
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
                  children: List<Widget>.generate(_pages.length, (int index) {
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
                  child: (_currentPage == (_pages.length - 1))
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScreeningAuthPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Let's start!",
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
