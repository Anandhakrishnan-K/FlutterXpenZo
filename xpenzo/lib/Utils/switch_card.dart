import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/bloc_month.dart';
import 'package:xpenso/BLoC/index_bloc.dart';
import 'package:xpenso/BLoC/year_bloc.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

final indexBloc = IndexUpdateBloc();

class SwitchCard extends StatefulWidget {
  const SwitchCard({super.key});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  void initState() {
    debugPrint('Switch Tabs Init State | State Initiated');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0,
      stream: indexBloc.stateStream,
      builder: (context, snapshot) {
        int temp = snapshot.data!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyButton(
              content: MyText(
                content: 'Day',
                size: temp == 0 ? fontSizeBig * 1.15 : fontSizeBig,
                color: temp == 0 ? white : black,
                isHeader: true,
              ),
              onPressed: () {
                debugPrint('From Here ${temp.toString()}');
                indexBloc.eventSink.add(IndexUpdate.day);
                debugPrint('Done');
                cardPageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
                listPageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
                dayBloc.eventSink.add(DayEvent.jump0);
                dayUpdateBloc.eventSink.add(DayUpdate.update);
                dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
              },
              fillColor: transparent,
            ),
            MyButton(
              content: MyText(
                content: 'Month',
                size: temp == 1 ? fontSizeBig * 1.15 : fontSizeBig,
                color: temp == 1 ? white : black,
                isHeader: true,
              ),
              onPressed: () {
                monthBolc.eventSink.add(MonthEvent.jump0);
                monthTotalListBloc.eventSink.add(MonthUpdate.update);
                monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                debugPrint('From Here ${temp.toString()}');
                indexBloc.eventSink.add(IndexUpdate.month);
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
                size: temp == 2 ? fontSizeBig * 1.15 : fontSizeBig,
                color: temp == 2 ? white : black,
                isHeader: true,
              ),
              onPressed: () async {
                yearBolc.eventSink.add(YearEvent.jump0);
                yearTotalBloc.eventSink.add(YearUpdate.getData);
                yearTotalListBloc.eventSink.add(YearUpdate.update);
                cardPageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
                listPageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
                // cardPageController.jumpToPage(2);
                // listPageController.jumpToPage(2);
                indexBloc.eventSink.add(IndexUpdate.year);
              },
              fillColor: transparent,
            ),
          ],
        );
      },
    );
  }
}
