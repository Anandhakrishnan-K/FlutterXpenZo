import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/Pages/profile_page.dart';
import 'package:xpenso/Utils/add_cf_buttons.dart';
import 'package:xpenso/Utils/expense_card.dart';
import 'package:xpenso/Utils/home_sliver.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  void initState() {
    dayBloc.eventSink.add(DayEvent.jump0);
    debugPrint('Main Home Page Initiated');
    setUserDetails();
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
    debugPrint('From Main Home Page $fname , $lname , $profilePath');
  }

  bool navBar = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const MyText(
                content: 'Exit',
              ),
              content: const MyText(
                content: 'Are you sure to close this application ?',
                maxlines: 2,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(height10),
                  child: MyButton(
                    borderColor: Colors.grey.shade300,
                    content: const MyText(content: 'No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(height10),
                  child: MyButton(
                    borderColor: Colors.grey.shade300,
                    content: const MyText(content: 'Yes'),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: NoOverScrollGlowBehavior(),
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: white,
                    elevation: 0,
                    pinned: true,
                    expandedHeight: deviceHeight * 0.5,
                    collapsedHeight: kToolbarHeight,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      background: const HomeSliver(),
                      centerTitle: true,
                      titlePadding: const EdgeInsets.all(0),
                      title: Container(
                        color: white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.05, vertical: height10),
                        child: const MyText(
                          isHeader: true,
                          content: 'Todays Transactions',
                          size: fontSizeBig,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.89,
                        color: white,
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: const ExpensecardDayMainPage()),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: const DayList(
                                mainPage: true,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const AddCFButtons()),
    );
  }
}

class NoOverScrollGlowBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
