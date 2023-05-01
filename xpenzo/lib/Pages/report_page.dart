import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/bloc_month.dart';
import 'package:xpenso/BLoC/year_bloc.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/data_table.dart';
import 'package:xpenso/Utils/duration_card.dart';
import 'package:xpenso/constants/constant_variables.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Future pickDate(BuildContext context) async {
    final DateTime? picked = await DatePicker.showSimpleDatePicker(context,
        dateFormat: 'MMM-yyyy',
        titleText: 'Pick a Month',
        itemTextStyle: const TextStyle(fontSize: fontSizeBig),
        looping: true,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = picked;
        monthBolc.eventSink.add(MonthEvent.jump);
        monthTotalBloc.eventSink.add(MonthUpdate.getdata);
        monthTotalListBloc.eventSink.add(MonthUpdate.update);
      });
    }
  }

  Future pickYear(BuildContext context) async {
    final DateTime? picked = await DatePicker.showSimpleDatePicker(context,
        dateFormat: 'yyyy',
        titleText: 'Pick a Year',
        looping: true,
        itemTextStyle: const TextStyle(fontSize: fontSizeBig),
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = picked;
        yearBolc.eventSink.add(YearEvent.jump);
        yearTotalBloc.eventSink.add(YearUpdate.getData);
        yearTotalListBloc.eventSink.add(YearUpdate.update);
      });
    }
  }

  String duration = 'Month';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dayBloc.eventSink.add(DayEvent.jump0);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainHomePage(),
            ),
            (route) => false);
        debugPrint('Coming Back to Main Home Page by back Button');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                dayBloc.eventSink.add(DayEvent.jump0);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainHomePage(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          title: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: 1,
              value: duration,
              onChanged: (String? newValue) {
                dayBloc.eventSink.add(DayEvent.jump0);
                setState(() {
                  duration = newValue!;
                });
              },
              items: <String>['Month', 'Year']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          toolbarHeight: height50,
          backgroundColor: transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: height30,
              ),
              Visibility(
                visible: duration == 'Month' ? true : false,
                child: StreamBuilder(
                  stream: monthBolc.stateStream,
                  initialData: dateSelected,
                  builder: (context, snapshot) {
                    DateTime tmpDate = snapshot.data!;
                    return DurationCard(
                        onPressedPlus: () {
                          monthBolc.eventSink.add(MonthEvent.add);
                          monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                          monthTotalListBloc.eventSink.add(MonthUpdate.update);
                        },
                        onPressedMinus: () {
                          monthBolc.eventSink.add(MonthEvent.minus);
                          monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                          monthTotalListBloc.eventSink.add(MonthUpdate.update);
                        },
                        onPressedJump: () {
                          monthBolc.eventSink.add(MonthEvent.jump0);
                          monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                          monthTotalListBloc.eventSink.add(MonthUpdate.update);
                          pickDate(context);
                        },
                        content: month.format(tmpDate));
                  },
                ),
              ),
              Visibility(
                visible: duration == 'Year' ? true : false,
                child: StreamBuilder(
                  stream: yearBolc.stateStream,
                  initialData: DateTime.now(),
                  builder: (context, snapshot) {
                    DateTime tmpDate = snapshot.data!;
                    return DurationCard(
                        onPressedPlus: () {
                          yearBolc.eventSink.add(YearEvent.add);
                          yearTotalBloc.eventSink.add(YearUpdate.getData);
                          yearTotalListBloc.eventSink.add(YearUpdate.update);
                        },
                        onPressedMinus: () {
                          yearBolc.eventSink.add(YearEvent.minus);
                          yearTotalBloc.eventSink.add(YearUpdate.getData);
                          yearTotalListBloc.eventSink.add(YearUpdate.update);
                        },
                        onPressedJump: () {
                          yearBolc.eventSink.add(YearEvent.jump0);
                          yearTotalBloc.eventSink.add(YearUpdate.getData);
                          yearTotalListBloc.eventSink.add(YearUpdate.update);
                          pickYear(context);
                        },
                        content: year.format(tmpDate));
                  },
                ),
              ),
              const SizedBox(
                height: height30,
              ),
              // Visibility(
              //     visible: duration == 'Month' ? true : false,
              //     child: StreamBuilder(
              //         stream: monthBolc.stateStream,
              //         initialData: DateTime.now(),
              //         builder: (context, snapshot) {
              //           return MyText(
              //               content:
              //                   'Displaying data for ${month.format(snapshot.data!).toString()}');
              //         })),
              // Visibility(
              //     visible: duration == 'Year' ? true : false,
              //     child: StreamBuilder(
              //         stream: yearBolc.stateStream,
              //         initialData: DateTime.now(),
              //         builder: (context, snapshot) {
              //           return MyText(
              //               content:
              //                   'Displaying data for ${year.format(snapshot.data!).toString()}');
              //         })),
              // const SizedBox(
              //   height: height30,
              // ),
              Visibility(
                  visible: duration == 'Month' ? true : false,
                  child: const Expanded(child: DataTableCF())),
              Visibility(
                  visible: duration == 'Year' ? true : false,
                  child: const Expanded(child: DataTableCFYear())),
            ],
          ),
        ),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(height20),
        //   child: FloatingActionButton(
        //     elevation: 10,
        //     backgroundColor: appColor,
        //     onPressed: () {
        //       dayBloc.eventSink.add(DayEvent.jump0);
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const MainHomePage(),
        //           ),
        //           (route) => false);
        //     },
        //     child: Image.asset(
        //       'assets/icons/back.png',
        //       scale: 20,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
