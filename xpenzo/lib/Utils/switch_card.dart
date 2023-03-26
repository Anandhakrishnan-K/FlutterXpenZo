import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

class SwitchCard extends StatefulWidget {
  const SwitchCard({super.key});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyButton(
          content: MyText(
            content: 'Day',
            size: durationIndex == 0 ? fontSizeBig * 1.15 : fontSizeBig,
            color: durationIndex == 0 ? white : black,
            isHeader: true,
          ),
          onPressed: () {
            dayBloc.eventSink.add(DayEvent.jump0);
            dayUpdateBloc.eventSink.add(DayUpdate.update);
            dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
            dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
            setState(() {
              durationIndex = 0;
              listindex = 0;
            });
            cardPageController.animateToPage(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
            listPageController.animateToPage(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          },
          fillColor: transparent,
        ),
        MyButton(
          content: MyText(
            content: 'Month',
            size: durationIndex == 1 ? fontSizeBig * 1.15 : fontSizeBig,
            color: durationIndex == 1 ? white : black,
            isHeader: true,
          ),
          onPressed: () {
            setState(() {
              durationIndex = 1;
              listindex = 1;
            });
            cardPageController.animateToPage(1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
            listPageController.animateToPage(1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          },
          fillColor: transparent,
        ),
        MyButton(
          content: MyText(
            content: 'Year',
            size: durationIndex == 2 ? fontSizeBig * 1.15 : fontSizeBig,
            color: durationIndex == 2 ? white : black,
            isHeader: true,
          ),
          onPressed: () {
            setState(() {
              durationIndex = 2;
              listindex = 2;
            });
            cardPageController.animateToPage(2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
            listPageController.animateToPage(2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          },
          fillColor: transparent,
        ),
      ],
    );
  }
}
