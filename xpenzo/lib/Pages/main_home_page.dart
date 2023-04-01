import 'package:flutter/material.dart';
import 'package:xpenso/ListBuilders/day_list1.dart';
import 'package:xpenso/Pages/chart_page.dart';
import 'package:xpenso/Pages/report_page.dart';
import 'package:xpenso/Utils/drawer_widget.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          content: 'Xpenso',
          size: fontSizeBig * 1.2,
          isHeader: true,
        ),
        centerTitle: true,
        backgroundColor: appColor,
        elevation: 0,
      ),

      body: Container(
        color: appColor,
        child: Column(
          children: [
            SizedBox(
              height: mainTabHeight,
              child: Column(
                children: [
                  SizedBox(
                      height: mainTabHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: height100 * 1.3,
                            width: deviceWidth * 0.32,
                            padding: const EdgeInsets.all(height10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (route) => false);
                              },
                              child: Card(
                                  elevation: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/history.gif',
                                        scale: 10,
                                      ),
                                      const MyText(content: 'History')
                                    ],
                                  )),
                            ),
                          ),
                          Container(
                            height: height100 * 1.2,
                            width: deviceWidth * 0.3,
                            padding: const EdgeInsets.all(height10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChartPage(),
                                    ),
                                    (route) => false);
                              },
                              child: Card(
                                  elevation: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/pie-chart.gif',
                                        scale: 10,
                                      ),
                                      const MyText(content: 'Charts')
                                    ],
                                  )),
                            ),
                          ),
                          Container(
                            height: height100 * 1.2,
                            width: deviceWidth * 0.3,
                            padding: const EdgeInsets.all(height10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ReportPage(),
                                    ),
                                    (route) => false);
                              },
                              child: Card(
                                  elevation: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/checklist.gif',
                                        scale: 10,
                                      ),
                                      const MyText(content: 'Reports')
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(height20),
                        topRight: Radius.circular(height20))),
                child: const MainDayList(),
              ),
            )
          ],
        ),
      ),
      //***************************** Drawer Starts Here ******************************/
      drawer: const DrawerWidget(),
    );
  }
}
