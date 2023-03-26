import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/main.dart';

enum MonthUpdate { update, getdata }

class MonthTotalListBloc {
  final monthStateStreamController = StreamController<
      List<MapEntry<DateTime, MapEntry<int, int>>>>.broadcast();
  StreamSink<List<MapEntry<DateTime, MapEntry<int, int>>>> get stateSink =>
      monthStateStreamController.sink;
  Stream<List<MapEntry<DateTime, MapEntry<int, int>>>> get stateStream =>
      monthStateStreamController.stream;

  final monthEventStreamController = StreamController<MonthUpdate>();
  StreamSink<MonthUpdate> get eventSink => monthEventStreamController.sink;
  Stream<MonthUpdate> get eventStream => monthEventStreamController.stream;

  MonthTotalListBloc() {
    eventStream.listen((event) async {
      DateTime date = dateSelected;
      List<DateTime> tmpList = [];
      List<MapEntry<DateTime, MapEntry<int, int>>> monthMappedList = [];
      int n = DateTime(date.year, date.month + 1, 0).day;
      for (int i = 1; i <= n; i++) {
        tmpList.add(DateTime(date.year, date.month, i));
      }
      int credittmp = 0;
      int debitTmp = 0;
      if (event == MonthUpdate.update) {
        for (int i = 0; i < tmpList.length; i++) {
          String mDay = d.format(tmpList[i]).toString();
          String mMonth = m.format(tmpList[i]).toString();
          String mYear = y.format(tmpList[i]).toString();
          List<Map<String, dynamic>> data =
              await service.getDayTotal(mDay, mMonth, mYear, '1');

          //Null Check
          if (data.isNotEmpty && data[0]['sum'] != null) {
            credittmp = int.parse(data[0]['sum'].toString());
          } else {
            credittmp = 0;
          }

          data = await service.getDayTotal(mDay, mMonth, mYear, '0');

          //Null Check
          if (data.isNotEmpty && data[0]['sum'] != null) {
            debitTmp = int.parse(data[0]['sum'].toString());
          } else {
            debitTmp = 0;
          }

          if (credittmp != 0 || debitTmp != 0) {
            monthMappedList
                .add(MapEntry(tmpList[i], MapEntry(credittmp, debitTmp)));
          }
        }
        stateSink.add(monthMappedList);
        if (monthMappedList.isNotEmpty) {
          debugPrint(
              'Mapped List length: ${monthMappedList.length} | Value @ 0 | date: ${monthMappedList[0].key} | credit: ${monthMappedList[0].value.key} | debit: ${monthMappedList[0].value.value}');
        } else {
          debugPrint('Mapped List: No data');
        }
      }
    });
  }
}

//**************************** For Getting Monthly Expense Day wise *********************/

// class MonthTotalDebitListBloc {
//   final monthStateStreamController = StreamController<List<int>>.broadcast();
//   StreamSink<List<int>> get stateSink => monthStateStreamController.sink;
//   Stream<List<int>> get stateStream => monthStateStreamController.stream;

//   final monthEventStreamController = StreamController<MonthUpdate>();
//   StreamSink<MonthUpdate> get eventSink => monthEventStreamController.sink;
//   Stream<MonthUpdate> get eventStream => monthEventStreamController.stream;

//   MonthTotalDebitListBloc() {
//     eventStream.listen((event) async {
//       DateTime date = dateSelected;
//       List<DateTime> tmpList = [];
//       int n = DateTime(date.year, date.month + 1, 0).day;
//       for (int i = 1; i <= n; i++) {
//         tmpList.add(DateTime(date.year, date.month, i));
//       }
//       List<int> debitMonthList = [];
//       int tmp = 0;
//       if (event == MonthUpdate.debit) {
//         for (int i = 0; i < tmpList.length; i++) {
//           String mDay = d.format(tmpList[i]).toString();
//           String mMonth = m.format(tmpList[i]).toString();
//           String mYear = y.format(tmpList[i]).toString();
//           List<Map<String, dynamic>> data =
//               await service.getDayTotal(mDay, mMonth, mYear, '0');

//           //Null Check
//           if (data.isNotEmpty && data[0]['sum'] != null) {
//             tmp = int.parse(data[0]['sum'].toString());
//           } else {
//             tmp = 0;
//           }
//           debitMonthList.add(tmp);
//         }
//         debugPrint(
//             'Update Month credit List BLoc | Total Length: ${debitMonthList.length.toString()} | Date @ 0 ${tmpList[0].toString()} | amount @ 0 ${debitMonthList[0].toString()}');
//         stateSink.add(debitMonthList);
//       }
//     });
//   }
// }

class MonthTotalBloc {
  final monthStateStreamController = StreamController<
      List<MapEntry<DateTime, MapEntry<int, int>>>>.broadcast();
  StreamSink<List<MapEntry<DateTime, MapEntry<int, int>>>> get stateSink =>
      monthStateStreamController.sink;
  Stream<List<MapEntry<DateTime, MapEntry<int, int>>>> get statestream =>
      monthStateStreamController.stream;

  final monthEventStreamController = StreamController<MonthUpdate>();
  StreamSink<MonthUpdate> get eventSink => monthEventStreamController.sink;
  Stream<MonthUpdate> get eventStream => monthEventStreamController.stream;

  MonthTotalBloc() {
    int totalCredit;
    int totalDebit;
    eventStream.listen((event) async {
      List<MapEntry<DateTime, MapEntry<int, int>>> mappedMonthTotal = [];
      if (event == MonthUpdate.getdata) {
        DateTime date = dateSelected;
        String dMonth = m.format(date).toString();
        String dYear = y.format(date).toString();
        List<Map<String, dynamic>> tmpdata =
            await service.getMonthTotal(dMonth, dYear, '1');
        if (tmpdata.isNotEmpty && tmpdata[0]['sum'] != null) {
          totalCredit = tmpdata[0]['sum'];
        } else {
          totalCredit = 0;
        }
        tmpdata = await service.getMonthTotal(dMonth, dYear, '0');
        if (tmpdata.isNotEmpty && tmpdata[0]['sum'] != null) {
          totalDebit = tmpdata[0]['sum'];
        } else {
          totalDebit = 0;
        }
        mappedMonthTotal.add(MapEntry(date, MapEntry(totalCredit, totalDebit)));
      }
      stateSink.add(mappedMonthTotal);
      debugPrint(
          'Total For date: ${mappedMonthTotal[0].key} | credit: ${mappedMonthTotal[0].value.key} | debit: ${mappedMonthTotal[0].value.value}');
    });
  }
}
