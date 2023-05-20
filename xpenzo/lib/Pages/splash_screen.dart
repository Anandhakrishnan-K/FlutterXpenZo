import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(milliseconds: 2000),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainHomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
          child: Container(
        color: appColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                child: Center(
              child: MyText(
                content: 'Xpenso',
                size: fontSizeBig * 2,
                color: white,
                isHeader: true,
              ),
            )),
            SizedBox(
              child: Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                    color: white, size: height40),
              ),
            )
          ],
        ),
      )),
    );
  }
}
