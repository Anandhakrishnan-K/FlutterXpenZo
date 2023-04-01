import 'package:flutter/material.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/drawer_widget.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
      ),
      body: Center(
        child: MyButton(
            fillColor: appColor,
            width: deviceWidth * 0.5,
            content: const MyText(content: 'About'),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainHomePage(),
                  ),
                  (route) => false);
            }),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
