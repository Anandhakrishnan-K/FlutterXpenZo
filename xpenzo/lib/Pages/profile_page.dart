import 'package:flutter/material.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            content: const MyText(content: 'User Profile Page'),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainHomePage(),
                  ),
                  (route) => false);
            }),
      ),
    );
  }
}
