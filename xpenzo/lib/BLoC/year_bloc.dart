import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/main.dart';

enum YearUpdate {
  update,
  getData,
}

class YearUpadteBloc {
  final yearStateStreamController = StreamController<
      List<MapEntry<DateTime, MapEntry<double, double>>>>.broadcast();
  StreamSink<List<MapEntry<DateTime, MapEntry<double, double>>>>
      get stateSink => yearStateStreamController.sink;
  Stream<List<MapEntry<DateTime, MapEntry<double, double>>>> get stateStream =>
      yearStateStreamController.stream;

  final yearEventStreamController = StreamController<YearUpdate>();
  StreamSink<YearUpdate> get eventSink => yearEventStreamController.sink;
  Stream<YearUpdate> get eventStream => yearEventStreamController.stream;

  YearUpadteBloc() {
    double tmpCredit;
    double tmpDebit;
    eventStream.listen((event) async {
      DateTime date = dateSelected;
      List<MapEntry<DateTime, MapEntry<double, double>>> mappedYearList = [];
      List<DateTime> tmpDateList = [];
      for (int i = 1; i <= 12; i++) {
        tmpDateList.add(DateTime(date.year, i, 1));
      }

      if (event == YearUpdate.update) {
        for (int i = 0; i < 12; i++) {
          String mYear = m.format(tmpDateList[i]).toString();
          String yYear = y.format(tmpDateList[i]).toString();

          List<Map<String, dynamic>> data =
              await service.getMonthTotal(mYear, yYear, '1');

          if (data.isNotEmpty && data[0]['sum'] != null) {
            tmpCredit = double.parse(data[0]['sum'].toString());
          } else {
            tmpCredit = 0;
          }
          data = await service.getMonthTotal(mYear, yYear, '0');

          if (data.isNotEmpty && data[0]['sum'] != null) {
            tmpDebit = double.parse(data[0]['sum'].toString());
          } else {
            tmpDebit = 0;
          }

          if (tmpCredit != 0 || tmpDebit != 0) {
            mappedYearList
                .add(MapEntry(tmpDateList[i], MapEntry(tmpCredit, tmpDebit)));
          }
        }
        stateSink.add(mappedYearList);
        if (mappedYearList.isNotEmpty) {
          debugPrint(
              'Year Mapped List | length: ${mappedYearList.length} | Value @ 0 Date: ${mappedYearList[0].key} | Credit: ${mappedYearList[0].value.key} | Debit: ${mappedYearList[0].value.value}');
        } else {
          debugPrint('Year List Called : Returns Empty List');
        }
      }
    });
  }
}

class YearTotalBloc {
  final monthStateStreamController = StreamController<
      List<MapEntry<DateTime, MapEntry<double, double>>>>.broadcast();
  StreamSink<List<MapEntry<DateTime, MapEntry<double, double>>>>
      get stateSink => monthStateStreamController.sink;
  Stream<List<MapEntry<DateTime, MapEntry<double, double>>>> get stateStream =>
      monthStateStreamController.stream;

  final monthEventStreamController = StreamController<YearUpdate>();
  StreamSink<YearUpdate> get eventSink => monthEventStreamController.sink;
  Stream<YearUpdate> get eventStream => monthEventStreamController.stream;

  YearTotalBloc() {
    double totalCredit;
    double totalDebit;
    eventStream.listen((event) async {
      List<MapEntry<DateTime, MapEntry<double, double>>> mappedYearTotal = [];
      if (event == YearUpdate.getData) {
        DateTime date = dateSelected;
        String dYear = y.format(date).toString();
        List<Map<String, dynamic>> tmpdata =
            await service.getYearTotal(dYear, '1');
        if (tmpdata.isNotEmpty && tmpdata[0]['sum'] != null) {
          totalCredit = tmpdata[0]['sum'];
        } else {
          totalCredit = 0;
        }
        tmpdata = await service.getYearTotal(dYear, '0');
        if (tmpdata.isNotEmpty && tmpdata[0]['sum'] != null) {
          totalDebit = tmpdata[0]['sum'];
        } else {
          totalDebit = 0;
        }
        mappedYearTotal.add(MapEntry(date, MapEntry(totalCredit, totalDebit)));
      }
      stateSink.add(mappedYearTotal);
      debugPrint(
          'Total For date: ${mappedYearTotal[0].key} | credit: ${mappedYearTotal[0].value.key} | debit: ${mappedYearTotal[0].value.value}');
    });
  }
}
