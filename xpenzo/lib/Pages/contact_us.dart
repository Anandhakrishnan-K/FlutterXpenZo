import 'package:flutter/material.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/drawer_widget.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
            content: const MyText(content: 'Contact Us'),
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
