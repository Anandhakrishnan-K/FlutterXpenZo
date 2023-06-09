import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
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
import 'package:fl_chart/fl_chart.dart';

//Object for Chart Bloc
final chartBloc = ChartBloc();
final chartSummaryBloc = ChartSummaryBloc();
//Empty List
List<PieChartSectionData> emtChartList = [];
List<MapEntry<int, double>> emtChartSummaryList = [];

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    chartBloc.eventSink.add(Charts.monthIn);
    chartSummaryBloc.eventSink.add(Charts.monthIn);
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

      if (duration == 'Month' && type == 'Income') {
        chartBloc.eventSink.add(Charts.monthIn);
        chartSummaryBloc.eventSink.add(Charts.monthIn);
      }

      if (duration == 'Month' && type == 'Expense') {
        chartBloc.eventSink.add(Charts.monthOut);
        chartSummaryBloc.eventSink.add(Charts.monthOut);
      }

      if (duration == 'Year' && type == 'Income') {
        chartBloc.eventSink.add(Charts.yearIn);
        chartSummaryBloc.eventSink.add(Charts.yearIn);
      }

      if (duration == 'Year' && type == 'Expense') {
        chartBloc.eventSink.add(Charts.yearOut);
        chartSummaryBloc.eventSink.add(Charts.yearOut);
      }
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

      if (duration == 'Month' && type == 'Income') {
        chartBloc.eventSink.add(Charts.monthIn);
        chartSummaryBloc.eventSink.add(Charts.monthIn);
      }

      if (duration == 'Month' && type == 'Expense') {
        chartBloc.eventSink.add(Charts.monthOut);
        chartSummaryBloc.eventSink.add(Charts.monthOut);
      }

      if (duration == 'Year' && type == 'Income') {
        chartBloc.eventSink.add(Charts.yearIn);
        chartSummaryBloc.eventSink.add(Charts.yearIn);
      }

      if (duration == 'Year' && type == 'Expense') {
        chartBloc.eventSink.add(Charts.yearOut);
        chartSummaryBloc.eventSink.add(Charts.yearOut);
      }
    }
  }

  String type = 'Income';
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
          title: SizedBox(
            height: height50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    elevation: 1,
                    value: type,
                    onChanged: (String? newValue) {
                      setState(() {
                        type = newValue!;
                      });
                      if (duration == 'Month' && type == 'Income') {
                        chartBloc.eventSink.add(Charts.monthIn);
                        chartSummaryBloc.eventSink.add(Charts.monthIn);
                      }

                      if (duration == 'Month' && type == 'Expense') {
                        chartBloc.eventSink.add(Charts.monthOut);
                        chartSummaryBloc.eventSink.add(Charts.monthOut);
                      }

                      if (duration == 'Year' && type == 'Income') {
                        chartBloc.eventSink.add(Charts.yearIn);
                        chartSummaryBloc.eventSink.add(Charts.yearIn);
                      }

                      if (duration == 'Year' && type == 'Expense') {
                        chartBloc.eventSink.add(Charts.yearOut);
                        chartSummaryBloc.eventSink.add(Charts.yearOut);
                      }
                    },
                    items: <String>['Income', 'Expense']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  width: deviceWidth * 0.1,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    elevation: 1,
                    value: duration,
                    onChanged: (String? newValue) {
                      dayBloc.eventSink.add(DayEvent.jump0);
                      setState(() {
                        duration = newValue!;
                      });
                      if (duration == 'Month' && type == 'Income') {
                        chartBloc.eventSink.add(Charts.monthIn);
                        chartSummaryBloc.eventSink.add(Charts.monthIn);
                      }

                      if (duration == 'Month' && type == 'Expense') {
                        chartBloc.eventSink.add(Charts.monthOut);
                        chartSummaryBloc.eventSink.add(Charts.monthOut);
                      }

                      if (duration == 'Year' && type == 'Income') {
                        chartBloc.eventSink.add(Charts.yearIn);
                        chartSummaryBloc.eventSink.add(Charts.yearIn);
                      }

                      if (duration == 'Year' && type == 'Expense') {
                        chartBloc.eventSink.add(Charts.yearOut);
                        chartSummaryBloc.eventSink.add(Charts.yearOut);
                      }
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
              ],
            ),
          ),
          backgroundColor: white,
          elevation: 0,
          toolbarHeight: height50,
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
                          if (duration == 'Month' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.monthIn);
                            chartSummaryBloc.eventSink.add(Charts.monthIn);
                          }

                          if (duration == 'Month' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.monthOut);
                            chartSummaryBloc.eventSink.add(Charts.monthOut);
                          }

                          if (duration == 'Year' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.yearIn);
                            chartSummaryBloc.eventSink.add(Charts.yearIn);
                          }

                          if (duration == 'Year' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.yearOut);
                            chartSummaryBloc.eventSink.add(Charts.yearOut);
                          }
                        },
                        onPressedMinus: () {
                          monthBolc.eventSink.add(MonthEvent.minus);
                          monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                          monthTotalListBloc.eventSink.add(MonthUpdate.update);
                          if (duration == 'Month' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.monthIn);
                            chartSummaryBloc.eventSink.add(Charts.monthIn);
                          }

                          if (duration == 'Month' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.monthOut);
                            chartSummaryBloc.eventSink.add(Charts.monthOut);
                          }

                          if (duration == 'Year' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.yearIn);
                            chartSummaryBloc.eventSink.add(Charts.yearIn);
                          }

                          if (duration == 'Year' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.yearOut);
                            chartSummaryBloc.eventSink.add(Charts.yearOut);
                          }
                        },
                        onPressedJump: () {
                          monthBolc.eventSink.add(MonthEvent.jump0);
                          monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                          monthTotalListBloc.eventSink.add(MonthUpdate.update);
                          if (duration == 'Month' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.monthIn);
                            chartSummaryBloc.eventSink.add(Charts.monthIn);
                          }

                          if (duration == 'Month' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.monthOut);
                            chartSummaryBloc.eventSink.add(Charts.monthOut);
                          }

                          if (duration == 'Year' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.yearIn);
                            chartSummaryBloc.eventSink.add(Charts.yearIn);
                          }

                          if (duration == 'Year' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.yearOut);
                            chartSummaryBloc.eventSink.add(Charts.yearOut);
                          }
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
                          if (duration == 'Month' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.monthIn);
                            chartSummaryBloc.eventSink.add(Charts.monthIn);
                          }

                          if (duration == 'Month' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.monthOut);
                            chartSummaryBloc.eventSink.add(Charts.monthOut);
                          }

                          if (duration == 'Year' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.yearIn);
                            chartSummaryBloc.eventSink.add(Charts.yearIn);
                          }

                          if (duration == 'Year' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.yearOut);
                            chartSummaryBloc.eventSink.add(Charts.yearOut);
                          }
                        },
                        onPressedMinus: () {
                          yearBolc.eventSink.add(YearEvent.minus);
                          yearTotalBloc.eventSink.add(YearUpdate.getData);
                          yearTotalListBloc.eventSink.add(YearUpdate.update);
                          if (duration == 'Month' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.monthIn);
                            chartSummaryBloc.eventSink.add(Charts.monthIn);
                          }

                          if (duration == 'Month' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.monthOut);
                            chartSummaryBloc.eventSink.add(Charts.monthOut);
                          }

                          if (duration == 'Year' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.yearIn);
                            chartSummaryBloc.eventSink.add(Charts.yearIn);
                          }

                          if (duration == 'Year' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.yearOut);
                            chartSummaryBloc.eventSink.add(Charts.yearOut);
                          }
                        },
                        onPressedJump: () {
                          yearBolc.eventSink.add(YearEvent.jump0);
                          yearTotalBloc.eventSink.add(YearUpdate.getData);
                          yearTotalListBloc.eventSink.add(YearUpdate.update);
                          if (duration == 'Month' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.monthIn);
                            chartSummaryBloc.eventSink.add(Charts.monthIn);
                          }

                          if (duration == 'Month' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.monthOut);
                            chartSummaryBloc.eventSink.add(Charts.monthOut);
                          }

                          if (duration == 'Year' && type == 'Income') {
                            chartBloc.eventSink.add(Charts.yearIn);
                            chartSummaryBloc.eventSink.add(Charts.yearIn);
                          }

                          if (duration == 'Year' && type == 'Expense') {
                            chartBloc.eventSink.add(Charts.yearOut);
                            chartSummaryBloc.eventSink.add(Charts.yearOut);
                          }
                          pickYear(context);
                        },
                        content: year.format(tmpDate));
                  },
                ),
              ),
              const SizedBox(
                height: height30,
              ),
              Expanded(
                child: Center(
                  child: StreamBuilder(
                      initialData: emtChartList,
                      stream: chartBloc.stateStream,
                      builder: (context, snapshot) {
                        List<PieChartSectionData> tmpList = snapshot.data!;
                        if (tmpList.isEmpty &&
                            snapshot.connectionState !=
                                ConnectionState.waiting) {
                          return SizedBox(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const MyImageIcon(
                                      color: Colors.grey,
                                      totalSize: height100 * 1.5,
                                      iconSize: height100 * 1.3,
                                      path: 'assets/icons/embarrassed.png',
                                      name: 'OOPS!!'),
                                  const SizedBox(
                                    height: height20,
                                  ),
                                  MyText(
                                      color: Colors.grey,
                                      content:
                                          'No Data Available for ${month.format(dateSelected).toString()}'),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                startDegreeOffset: 180,
                                sectionsSpace: 3,
                                centerSpaceRadius: 5,
                                sections: tmpList,
                              ),
                              swapAnimationCurve: Curves.easeIn,
                              swapAnimationDuration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: height20,
              ),
              StreamBuilder(
                  stream: chartSummaryBloc.stateStream,
                  initialData: emtChartSummaryList,
                  builder: (context, snapshot) {
                    List<MapEntry<int, double>> tmpChartSummaryList =
                        snapshot.data!;
                    return SizedBox(
                      height: height100 * 3,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tmpChartSummaryList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(height10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: deviceWidth * 0.25,
                                ),
                                Icon(
                                  Icons.pie_chart,
                                  size: fontSizeBig * 1.2,
                                  color: expenseColorList[
                                      tmpChartSummaryList[index].key],
                                ),
                                const SizedBox(
                                  width: deviceWidth * 0.1,
                                ),
                                MyText(
                                    size: fontSizeSmall * 0.9,
                                    content: type == 'Income'
                                        ? '${incomeNameList[tmpChartSummaryList[index].key]} : ${((tmpChartSummaryList[index].value) * 100).toStringAsFixed(2)} %'
                                        : '${expenseNameList[tmpChartSummaryList[index].key]} : ${((tmpChartSummaryList[index].value) * 100).toStringAsFixed(2)} %'),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
              const SizedBox(
                height: height20,
              ),
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

//FOR Trial Purpose

// List<int> a = [1, 3, 0, 6, 2, 4, 7, 5, 8];
// double batPos = 0.99;
// double titPos = 0.5;
// double ntoc = 150;
// double toc = 160;

// PieChartSectionData(
//             color: expenseColorList[0],
//             value: 25,
//             badgeWidget: expenseList[0],
//             badgePositionPercentageOffset: batPos,
//             radius: isTouched ? toc : ntoc,
//             titlePositionPercentageOffset: titPos,
//             borderSide: isTouched
//                 ? const BorderSide(color: Colors.black, width: 1)
//                 : const BorderSide(color: white),
//           )