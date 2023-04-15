import 'package:flutter/material.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/Utils/add_cf_buttons.dart';
import 'package:xpenso/Utils/expense_card.dart';
import 'package:xpenso/Utils/home_sliver.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

//Getting User Name
String fname = 'Anandhakrishnan';
String lname = 'K';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  bool navBar = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  expandedHeight: MediaQuery.of(context).size.height * 0.5,
                  collapsedHeight: MediaQuery.of(context).size.height * 0.075,
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
                              height: MediaQuery.of(context).size.height * 0.15,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const AddCFButtons());
  }
}

class NoOverScrollGlowBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
