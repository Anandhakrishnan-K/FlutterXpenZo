import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/profile_picture_bloc.dart';
import 'package:xpenso/Pages/chart_page.dart';
import 'package:xpenso/Pages/profile_page.dart';
import 'package:xpenso/Pages/report_page.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

final getBalanceBloc = GetBalanceBloc();
final isBalBloc = IsBalBloc();
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
    isBalBloc.eventSink.add(GetBal.check);
    setUserDetails();
    profileUpdateBloc.eventSink.add(ProfileUpdate.update);
    super.initState();
  }

  Future<void> setUserDetails() async {
    String tmpF = await user.getFirstName();
    String tmpL = await user.getLastName();
    String tmpP = await user.getProfilePath();
    setState(() {
      fname = tmpF;
      lname = tmpL;
      profilePath = tmpP;
    });
    debugPrint('$fname , $lname , $profilePath');
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
                child: StreamBuilder(
                    stream: profileUpdateBloc.stateStream,
                    initialData: profilePic,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        File tmpProfilePic = snapshot.data!;
                        return SizedBox(
                          child: CircleAvatar(
                            backgroundImage:
                                profilePath == 'assets/icons/man.png'
                                    ? null
                                    : FileImage(tmpProfilePic),
                            radius: deviceWidth * 0.1,
                          ),
                        );
                      } else {
                        return SizedBox(
                          child: CircleAvatar(
                            radius: deviceWidth * 0.1,
                            child: profilePath == 'assets/icons/man.png'
                                ? Image.asset(profilePath)
                                : null,
                          ),
                        );
                      }
                    }),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChartPage(),
                        ));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportPage(),
                        ));
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
                      StreamBuilder(
                          stream: isBalBloc.stateStream,
                          initialData: true,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: !snapshot.data!,
                              child: MyText(
                                content: totalBal > 0
                                    ? goodStr
                                    : totalBal == 0
                                        ? okStr
                                        : badStr,
                                maxlines: 2,
                              ),
                            );
                          }),
                      StreamBuilder(
                          stream: isBalBloc.stateStream,
                          initialData: true,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: snapshot.data!,
                              child: const MyText(
                                content:
                                    'Welcome lets add some credit or debit',
                                maxlines: 2,
                              ),
                            );
                          })
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
