import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/main.dart';

enum Charts { monthIn, monthOut, yearIn, yearOut }

class ChartBloc {
  final chartStateStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  StreamSink<List<Map<String, dynamic>>> get stateSink =>
      chartStateStreamController.sink;
  Stream<List<Map<String, dynamic>>> get stateStream =>
      chartStateStreamController.stream;

  final charteventStreamController = StreamController<Charts>.broadcast();
  StreamSink<Charts> get eventSink => charteventStreamController.sink;
  Stream<Charts> get eventStream => charteventStreamController.stream;

  ChartBloc() {
    eventStream.listen((event) async {
      List<Map<String, dynamic>> data = [];
      if (event == Charts.monthIn) {
        DateTime date = dateSelected;
        String mMonth = m.format(date).toString();
        String mYear = y.format(date).toString();

        data = await service.getMonthChartData(mMonth, mYear, 1);
      }
      if (event == Charts.monthOut) {
        DateTime date = dateSelected;
        String mMonth = m.format(date).toString();
        String mYear = y.format(date).toString();

        data = await service.getMonthChartData(mMonth, mYear, 0);
      }
      if (event == Charts.yearIn) {
        DateTime date = dateSelected;
        String mYear = y.format(date).toString();

        data = await service.getYearChartData(mYear, 1);
      }
      if (event == Charts.yearOut) {
        DateTime date = dateSelected;
        String mYear = year.format(date).toString();

        data = await service.getYearChartData(mYear, 0);
      }

      stateSink.add(data);
      if (data.isNotEmpty) {
        debugPrint(
            'Chart Bloc Called | Length of List: ${data.length.toString()} | Data @ 0: ${data[0]['category']} | ${data[0]['sum']}');
      } else {
        debugPrint('No data');
      }
    });
  }
}
