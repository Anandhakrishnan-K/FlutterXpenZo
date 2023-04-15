import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/bloc_month.dart';
import 'package:xpenso/BLoC/index_bloc.dart';
import 'package:xpenso/BLoC/year_bloc.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/Utils/duration_card.dart';
import 'package:xpenso/Utils/switch_card.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

final yearBolc = YearBloc();
final yearTotalListBloc = YearUpadteBloc();
final yearTotalBloc = YearTotalBloc();
List<MapEntry<DateTime, MapEntry<double, double>>> emptyMonthList = [];
List<MapEntry<DateTime, MapEntry<double, double>>> emptyTotalList1 = [
  MapEntry(DateTime.now(), const MapEntry(0, 0))
];

class YearList extends StatefulWidget {
  const YearList({super.key});
  @override
  State<YearList> createState() => _YearListState();
}

class _YearListState extends State<YearList> {
  bool yes = true;
  @override
  void initState() {
    deleteCacheDir();

    debugPrint('Year List Initiated | loading: $yes');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          yes = false;
        });
        yearTotalListBloc.eventSink.add(YearUpdate.update);
        yearTotalBloc.eventSink.add(YearUpdate.getData);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    yes = true;
    debugPrint('Year List Disposed | lodaing flag set to: $yes');
    super.dispose();
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }

    debugPrint('Cache Cleared');
  }

  Future pickDate(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: height20,
          ),
          StreamBuilder(
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
          Expanded(
            child: Center(
              child: StreamBuilder(
                initialData: emptyMonthList,
                stream: yearTotalListBloc.stateStream,
                builder: (context, snapshot) {
                  List<MapEntry<DateTime, MapEntry<double, double>>> tmpData =
                      snapshot.data!;
                  if (tmpData.isEmpty &&
                      snapshot.connectionState != ConnectionState.waiting) {
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
                                    'No Data Available for ${year.format(dateSelected).toString()}'),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Visibility(
                      visible: yes,
                      replacement: ListView.builder(
                        controller: mainPageDrawer,
                        physics: const BouncingScrollPhysics(),
                        itemCount: tmpData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                dateSelected = DateTime.parse(
                                    tmpData[index].key.toString());
                              });
                              indexBloc.eventSink.add(IndexUpdate.month);
                              monthBolc.eventSink.add(MonthEvent.jump);
                              monthTotalListBloc.eventSink
                                  .add(MonthUpdate.update);
                              monthTotalBloc.eventSink.add(MonthUpdate.getdata);
                              cardPageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear);
                              listPageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: SizedBox(
                              height: height100,
                              child: ListTile(
                                title: Container(
                                  padding: const EdgeInsetsDirectional.all(
                                      height10 / 2),
                                  height: mainTabHeight,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height20))),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: deviceWidth * 0.9 / 4,
                                            child: Center(
                                              child: MyText(
                                                  size: fontSizeBig * 0.8,
                                                  content: month.format(
                                                      DateTime.parse(
                                                          tmpData[index]
                                                              .key
                                                              .toString()))),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            thickness: 1,
                                            indent: height10,
                                            endIndent: height10,
                                          ),
                                          SizedBox(
                                            width: deviceWidth * 0.9 / 3.1,
                                            child: SizedBox(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.currency_rupee,
                                                      size: fontSizeBig,
                                                      color: Colors.green,
                                                    ),
                                                    MyText(
                                                      content: tmpData[index]
                                                          .value
                                                          .key
                                                          .toString(),
                                                      size: fontSizeBig * 0.8,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: height10,
                                                ),
                                                const MyText(
                                                  content: 'Total Income',
                                                  size: fontSizeSmall * 0.8,
                                                )
                                              ],
                                            )),
                                          ),
                                          const VerticalDivider(
                                            thickness: 1,
                                            indent: height10,
                                            endIndent: height10,
                                          ),
                                          SizedBox(
                                            width: deviceWidth * 0.9 / 3.1,
                                            child: SizedBox(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.currency_rupee,
                                                      size: fontSizeBig,
                                                      color: Colors.red,
                                                    ),
                                                    MyText(
                                                      content: tmpData[index]
                                                          .value
                                                          .value
                                                          .toString(),
                                                      size: fontSizeBig * 0.8,
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: height10,
                                                ),
                                                const MyText(
                                                  content: 'Total Expense',
                                                  size: fontSizeSmall * 0.8,
                                                )
                                              ],
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: appColor, size: height30),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
