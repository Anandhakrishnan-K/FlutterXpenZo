import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xpenso/BLoC/bloc_charts.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/bloc_month.dart';
import 'package:xpenso/BLoC/year_bloc.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/Pages/main_home_page.dart';
import 'package:xpenso/Utils/duration_card.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

//Object for Chart Bloc
final chartBloc = ChartBloc();
//Empty List
List<Map<String, dynamic>> emtChartList = [];

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    chartBloc.eventSink.add(Charts.monthIn);
    // chartBloc.eventSink.add(Charts.monthOut);
    // chartBloc.eventSink.add(Charts.yearIn);
    // chartBloc.eventSink.add(Charts.yearOut);
    super.initState();
  }

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

  String type = 'Income';
  String duration = 'Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        color: white,
        child: Column(
          children: [
            const SizedBox(
              height: height20,
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
                        pickDate(context);
                      },
                      content: year.format(tmpDate));
                },
              ),
            ),
            const SizedBox(
              height: height30,
            ),
            Visibility(
              visible: type == 'Income' ? true : false,
              child: Expanded(
                child: Center(
                  child: StreamBuilder(
                      initialData: emtChartList,
                      stream: chartBloc.stateStream,
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>> tmpList = snapshot.data!;
                        return SfCircularChart(
                          tooltipBehavior: TooltipBehavior(enable: true),
                          title: ChartTitle(
                              text: '$type Chart',
                              textStyle: GoogleFonts.poppins(
                                  fontSize: fontSizeSmall,
                                  fontWeight: FontWeight.w500)),
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.right,
                          ),
                          series: [
                            PieSeries<Map<String, dynamic>, String>(
                                explode: true,
                                explodeIndex: 0,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                dataSource: tmpList,
                                xValueMapper: (Map<String, dynamic> data, _) =>
                                    data['category'],
                                yValueMapper: (Map<String, dynamic> data, _) =>
                                    data['sum'])
                          ],
                        );
                      }),
                ),
              ),
            ),
            Visibility(
              visible: type == 'Expense' ? true : false,
              child: Expanded(
                child: Center(
                  child: StreamBuilder(
                      initialData: emtChartList,
                      stream: chartBloc.stateStream,
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>> tmpList = snapshot.data!;
                        return SfCircularChart(
                          tooltipBehavior: TooltipBehavior(enable: true),
                          title: ChartTitle(
                              text: '$type Chart',
                              textStyle: GoogleFonts.poppins(
                                  fontSize: fontSizeSmall,
                                  fontWeight: FontWeight.w500)),
                          legend: Legend(
                            isVisible: true,
                            position: LegendPosition.right,
                          ),
                          series: [
                            PieSeries<Map<String, dynamic>, String>(
                                explode: true,
                                explodeIndex: 0,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                dataSource: tmpList,
                                xValueMapper: (Map<String, dynamic> data, _) =>
                                    data['category'],
                                yValueMapper: (Map<String, dynamic> data, _) =>
                                    data['sum'])
                          ],
                        );
                      }),
                ),
              ),
            ),
            SizedBox(
              height: height100 * 1.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: height20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RadioListTile(
                            autofocus: true,
                            selectedTileColor: appColor,
                            activeColor: appColor,
                            title: const MyText(content: 'Income'),
                            value: 'Income',
                            groupValue: type,
                            onChanged: (value) {
                              chartBloc.eventSink.add(Charts.yearIn);
                              setState(() {
                                type = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: const MyText(content: 'Expense'),
                            value: 'Expense',
                            activeColor: appColor,
                            groupValue: type,
                            onChanged: (value) {
                              chartBloc.eventSink.add(Charts.yearOut);
                              setState(() {
                                type = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RadioListTile(
                            autofocus: true,
                            selectedTileColor: appColor,
                            activeColor: appColor,
                            title: const MyText(content: 'Month'),
                            value: 'Month',
                            groupValue: duration,
                            onChanged: (value) {
                              setState(() {
                                monthBolc.eventSink.add(MonthEvent.jump0);
                                duration = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: const MyText(content: 'Year'),
                            value: 'Year',
                            activeColor: appColor,
                            groupValue: duration,
                            onChanged: (value) {
                              setState(() {
                                yearBolc.eventSink.add(YearEvent.jump0);
                                duration = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: height75,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(height20),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
