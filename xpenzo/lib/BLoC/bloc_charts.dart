import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/main.dart';

double batPos = 0.99;
double titPos = 0.5;
double ntoc = 150;
double toc = 160;

enum Charts { monthIn, monthOut, yearIn, yearOut }

class ChartBloc {
  final chartStateStreamController =
      StreamController<List<PieChartSectionData>>.broadcast();
  StreamSink<List<PieChartSectionData>> get stateSink =>
      chartStateStreamController.sink;
  Stream<List<PieChartSectionData>> get stateStream =>
      chartStateStreamController.stream;

  final charteventStreamController = StreamController<Charts>.broadcast();
  StreamSink<Charts> get eventSink => charteventStreamController.sink;
  Stream<Charts> get eventStream => charteventStreamController.stream;

  ChartBloc() {
    eventStream.listen((event) async {
      List<Map<String, dynamic>> data = [];
      List<PieChartSectionData> chartData = [];
      if (event == Charts.monthIn) {
        DateTime date = dateSelected;
        String mMonth = m.format(date).toString();
        String mYear = y.format(date).toString();

        data = await service.getMonthChartData(mMonth, mYear, 1);
        for (int i = 0; i < data.length; i++) {
          int cati = data[i]['category'];
          debugPrint(cati.toString());
          chartData.add(PieChartSectionData(
              color: expenseColorList[cati],
              value: data[i]['sum'],
              badgeWidget: incomeList[cati],
              badgePositionPercentageOffset: batPos,
              titlePositionPercentageOffset: titPos,
              radius: ntoc));
        }
      }
      if (event == Charts.monthOut) {
        DateTime date = dateSelected;
        String mMonth = m.format(date).toString();
        String mYear = y.format(date).toString();

        data = await service.getMonthChartData(mMonth, mYear, 0);
        for (int i = 0; i < data.length; i++) {
          int cati = data[i]['category'];
          chartData.add(PieChartSectionData(
              color: expenseColorList[cati],
              value: data[i]['sum'],
              badgeWidget: expenseList[cati],
              badgePositionPercentageOffset: batPos,
              titlePositionPercentageOffset: titPos,
              radius: ntoc));
        }
      }
      if (event == Charts.yearIn) {
        DateTime date = dateSelected;
        String mYear = y.format(date).toString();

        data = await service.getYearChartData(mYear, 1);
        for (int i = 0; i < data.length; i++) {
          int cati = data[i]['category'];
          chartData.add(PieChartSectionData(
              color: expenseColorList[cati],
              value: data[i]['sum'],
              badgeWidget: incomeList[cati],
              badgePositionPercentageOffset: batPos,
              titlePositionPercentageOffset: titPos,
              radius: ntoc));
        }
      }
      if (event == Charts.yearOut) {
        DateTime date = dateSelected;
        String mYear = y.format(date).toString();

        data = await service.getYearChartData(mYear, 0);
        for (int i = 0; i < data.length; i++) {
          int cati = data[i]['category'];
          chartData.add(PieChartSectionData(
              color: expenseColorList[cati],
              value: data[i]['sum'],
              badgeWidget: expenseList[cati],
              badgePositionPercentageOffset: batPos,
              titlePositionPercentageOffset: titPos,
              radius: ntoc));
        }
      }

      stateSink.add(chartData);
      if (data.isNotEmpty) {
        debugPrint(
            'Chart Bloc Called | Length of List: ${data.length.toString()} | Data @ 0: ${data[0]['category']} | ${data[0]['sum']}');
      } else {
        debugPrint('No data');
      }
    });
  }
}
