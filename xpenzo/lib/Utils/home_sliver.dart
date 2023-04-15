import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/Pages/chart_page.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Pages/profile_page.dart';
import 'package:xpenso/Pages/report_page.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

final getBalanceBloc = GetBalanceBloc();
const String goodStr =
    'Looks like you\'ve got your expenses under control. Well done!';
const String okStr =
    'Your expense plan is good, but with a few tweaks, it could be great!';
const String badStr =
    'It\'s time to tighten the purse strings a bit. Let\'s work on your expense plan together.';

class HomeSliver extends StatefulWidget {
  const HomeSliver({super.key});

  @override
  State<HomeSliver> createState() => _HomeSliverState();
}

double totalBal = 0.0;

class _HomeSliverState extends State<HomeSliver> {
  @override
  void initState() {
    getBalanceBloc.eventSink.add(GetBal.get);
    super.initState();
  }

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
          ),
          const SizedBox(
            height: height30,
          ),
          Container(
            padding: const EdgeInsets.all(height10) * 1.5,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(height10)),
            height: height100 * 1.1,
            child: StreamBuilder(
                stream: getBalanceBloc.stateStream,
                initialData: totalBal,
                builder: (context, snapshot) {
                  totalBal = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const MyText(
                            content: 'Available Balance:      ',
                            isHeader: true,
                            size: fontSizeBig,
                          ),
                          Icon(
                            Icons.currency_rupee,
                            size: fontSizeBig,
                            color: totalBal > 0
                                ? Colors.green
                                : totalBal == 0
                                    ? Colors.amber
                                    : Colors.red,
                          ),
                          MyText(
                            color: totalBal > 0
                                ? Colors.green
                                : totalBal == 0
                                    ? Colors.amber
                                    : Colors.red,
                            content: totalBal.toStringAsFixed(2),
                            size: fontSizeBig,
                            isHeader: true,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: height10,
                      ),
                      MyText(
                        content: totalBal > 0
                            ? goodStr
                            : totalBal == 0
                                ? okStr
                                : badStr,
                        maxlines: 2,
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}