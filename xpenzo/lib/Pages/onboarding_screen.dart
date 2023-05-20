// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:xpenso/Pages/profile_page.dart';
import 'package:xpenso/Pages/splash_screen.dart';
import 'package:xpenso/Utils/onboard_screen_template.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

//Page View controller
final pageControllerOnboadring = PageController();
int pageIndex = 0;

class MyOnboardingScreen extends StatefulWidget {
  const MyOnboardingScreen({super.key});

  @override
  State<MyOnboardingScreen> createState() => _MyOnboardingScreenState();
}

class _MyOnboardingScreenState extends State<MyOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: white,
      ),
      body: Container(
        color: white,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageControllerOnboadring,
                children: const [
                  OnboardingFirstScreen(),
                  OnboardingSecondScreen(),
                  OnboardingThirdScreen(),
                  OnboardingFourthScreen(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(height30),
              height: height75,
              child: Stack(
                children: [
                  Visibility(
                      visible: pageIndex == 0 ? false : true,
                      child: Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: MyButton(
                            fillColor: appColor,
                            content: const MyText(content: 'Back'),
                            onPressed: () {
                              setState(() {
                                pageIndex = pageIndex - 1;
                              });
                              pageControllerOnboadring.animateToPage(pageIndex,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.decelerate);
                            }),
                      )),
                  Visibility(
                      visible: pageIndex == 3 ? false : true,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: MyButton(
                            fillColor: appColor,
                            content: const MyText(content: 'Next'),
                            onPressed: () {
                              setState(() {
                                pageIndex = pageIndex + 1;
                              });
                              pageControllerOnboadring.animateToPage(pageIndex,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.decelerate);
                            }),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MyText(content: '${(pageIndex + 1).toString()} / 4'),
                  ),
                  Visibility(
                      visible: pageIndex == 3 ? true : false,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: MyButton(
                            fillColor: appColor,
                            content: const MyText(content: 'Get Started'),
                            onPressed: () {
                              if (fnameControllerOnboard.text.isNotEmpty &&
                                  lnameControllerOnboard.text.isNotEmpty) {
                                user.saveFirstTimeInfo(false);
                                debugPrint(
                                    'Name: ${fnameControllerOnboard.text.toString()} ${lnameControllerOnboard.text.toString()}');
                                user.saveFirstLastName(
                                    fnameControllerOnboard.text.toString(),
                                    lnameControllerOnboard.text.toString());

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MySplashScreen(),
                                    ),
                                    (route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: white,
                                        duration: Duration(seconds: 1),
                                        content: MyText(
                                            content:
                                                'First Name or Last Name are Mandatory')));
                              }
                            }),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
