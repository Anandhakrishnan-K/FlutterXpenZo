// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
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
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: height20),
        child: Column(
          children: [
            SizedBox(
              child: CircleAvatar(
                radius: deviceWidth * 0.2,
                child: Image.asset('assets/icons/man.png'),
              ),
            ),
            const SizedBox(
              height: height30,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox(
                    width: deviceWidth * 0.4,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          label: Center(child: MyText(content: 'First Name'))),
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.4,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          label: Center(child: MyText(content: 'Last Name'))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: height30,
            ),
            const SizedBox(
              width: deviceWidth,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    label: Center(child: MyText(content: 'User Id'))),
              ),
            ),
            const SizedBox(
              height: height30,
            ),
            const SizedBox(
              width: deviceWidth,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    label: Center(child: MyText(content: 'Email Id'))),
              ),
            ),
            const SizedBox(
              height: height30,
            ),
            const SizedBox(
              width: deviceWidth,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    label: Center(child: MyText(content: 'Mobile No'))),
              ),
            ),
            const SizedBox(
              height: height30,
            ),
            MyButton(
                fillColor: appColor,
                width: deviceWidth,
                height: height50 * 1.2,
                content: const MyText(content: 'Update Details'),
                onPressed: () {}),
            const SizedBox(
              height: height30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(content: MyText(content: 'About'), onPressed: () {}),
                MyText(content: '.'),
                MyButton(
                    content: MyText(content: 'Contact Us'), onPressed: () {}),
                MyText(content: '.'),
                MyButton(content: MyText(content: 'Help'), onPressed: () {}),
                // MyText(content: '.'),
                // MyText(content: 'Version V0.1')
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(height10),
        child: FloatingActionButton(
          elevation: 10,
          backgroundColor: appColor,
          onPressed: () {
            dayBloc.eventSink.add(DayEvent.jump0);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainHomePage(),
                ),
                (route) => false);
          },
          child: Image.asset(
            'assets/icons/back.png',
            scale: 20,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}
