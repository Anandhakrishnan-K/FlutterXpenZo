import 'package:flutter/material.dart';
import 'package:xpenso/Pages/chart_page.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Pages/profile_page.dart';
import 'package:xpenso/Pages/report_page.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

class HomeSliver extends StatefulWidget {
  const HomeSliver({super.key});

  @override
  State<HomeSliver> createState() => _HomeSliverState();
}

class _HomeSliverState extends State<HomeSliver> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: height20, right: height20, top: height10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyText(
                    content: 'Welcome back ,',
                    size: fontSizeSmall,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: height10 / 2,
                  ),
                  MyText(
                    content: '$fname $lname',
                    size: fontSizeBig * 1.2,
                    isHeader: true,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                      (route) => false);
                },
                child: CircleAvatar(
                  radius: height30,
                  child: Image.asset(
                    'assets/icons/man.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: height40,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: height20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/history.png',
                        scale: 7,
                      ),
                      const MyText(content: 'History')
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChartPage(),
                        ),
                        (route) => false);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/charts.png',
                        scale: 7,
                      ),
                      const MyText(content: 'Charts')
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportPage(),
                        ),
                        (route) => false);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/reports.png',
                        scale: 7,
                      ),
                      const MyText(content: 'Reports')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
