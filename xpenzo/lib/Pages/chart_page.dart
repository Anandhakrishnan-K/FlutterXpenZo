import 'package:flutter/material.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/drawer_widget.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
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
            content: const MyText(content: 'Go To Home'),
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
