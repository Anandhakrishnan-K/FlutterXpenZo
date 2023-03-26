import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xpenso/DataBase/data_model.dart';
import 'package:xpenso/DataBase/db_connnection.dart';
import 'package:xpenso/constants/constant_variables.dart';

enum DayUpdate { update, credit, debit }

final List<Ledger> tmpData = [];
int totalDayCredit = 0;
int totalDayDebit = 0;
final service = Services();

//*************************** Day List BLoC ******************************/
class DayUpdateBloc {
  final dayStateStreamController = StreamController<List<Ledger>>.broadcast();
  StreamSink<List<Ledger>> get stateSink => dayStateStreamController.sink;
  Stream<List<Ledger>> get stateStream => dayStateStreamController.stream;

  final dayEventStreamController = StreamController<DayUpdate>();
  StreamSink<DayUpdate> get eventSink => dayEventStreamController.sink;
  Stream<DayUpdate> get eventStream => dayEventStreamController.stream;

  DayUpdateBloc() {
    eventStream.listen((event) async {
      if (event == DayUpdate.update) {
        DateTime tmp = dateSelected;
        String dayDay = d.format(tmp).toString();
        String monthDay = m.format(tmp).toString();
        String yearDay = y.format(tmp).toString();

        tmpData.clear();
        var data = await service.getData(dayDay, monthDay, yearDay);
        data.forEach((ledger) {
          var dataModel = Ledger();
          dataModel.id = ledger['id'];
          dataModel.amount = ledger['amount'];
          dataModel.notes = ledger['notes'];
          dataModel.categoryIndex = ledger['categoryIndex'];
          dataModel.categoryFlag = ledger['categoryFlag'];
          dataModel.day = ledger['day'];
          dataModel.month = ledger['month'];
          dataModel.year = ledger['year'];
          dataModel.createdT = ledger['createdT'];
          dataModel.attachmentFlag = ledger['attachmentFlag'];
          dataModel.attachmentName = ledger['attachmentName'];

          tmpData.add(dataModel);
        });
        debugPrint(
            'Day Upadte Function called and current date : $tmp | Total Records: ${tmpData.length.toString()}');
      }

      stateSink.add(tmpData);
    });
  }

  void dispose() {
    debugPrint('Day List BLoC killed');
    dayEventStreamController.close();
    dayStateStreamController.close();
  }
}

//************************* Day Total Credit BLoC *********************************/
class DayTotalCreditBloc {
  final dayStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get stateSink => dayStateStreamController.sink;
  Stream<int> get stateStream => dayStateStreamController.stream;

  final dayEventStreamController = StreamController<DayUpdate>();
  StreamSink<DayUpdate> get eventSink => dayEventStreamController.sink;
  Stream<DayUpdate> get eventStream => dayEventStreamController.stream;

  DayTotalCreditBloc() {
    eventStream.listen((event) async {
      if (event == DayUpdate.credit) {
        DateTime tmp = dateSelected;
        String dayDay = d.format(tmp).toString();
        String monthDay = m.format(tmp).toString();
        String yearDay = y.format(tmp).toString();
        List<Map<String, dynamic>> data =
            await service.getDayTotal(dayDay, monthDay, yearDay, '1');

        //Null Check
        if (data.isNotEmpty && data[0]['sum'] != null) {
          totalDayCredit = int.parse(data[0]['sum'].toString());
        } else {
          totalDayCredit = 0;
        }
        debugPrint(
            'Day Upadte Function called and current date : $tmp | Total Credit: ${totalDayCredit.toString()}');
      }
      stateSink.add(totalDayCredit);
    });
  }
  void dispose() {
    debugPrint('Day Credit BLoC killed');
    dayEventStreamController.close();
    dayStateStreamController.close();
  }
}

//************************* Day Total Debit BLoC *********************************/
class DayTotalDebitBloc {
  final dayStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get stateSink => dayStateStreamController.sink;
  Stream<int> get stateStream => dayStateStreamController.stream;

  final dayEventStreamController = StreamController<DayUpdate>();
  StreamSink<DayUpdate> get eventSink => dayEventStreamController.sink;
  Stream<DayUpdate> get eventStream => dayEventStreamController.stream;

  DayTotalDebitBloc() {
    eventStream.listen((event) async {
      if (event == DayUpdate.debit) {
        DateTime tmp = dateSelected;
        String dayDay = d.format(tmp).toString();
        String monthDay = m.format(tmp).toString();
        String yearDay = y.format(tmp).toString();
        List<Map<String, dynamic>> data =
            await service.getDayTotal(dayDay, monthDay, yearDay, '0');

        //Null Check
        if (data.isNotEmpty && data[0]['sum'] != null) {
          totalDayDebit = int.parse(data[0]['sum'].toString());
        } else {
          totalDayDebit = 0;
        }

        debugPrint(
            'Day Upadte Function called and current date : $tmp | Total Debit: ${totalDayDebit.toString()}');
      }
      stateSink.add(totalDayDebit);
    });
  }
  void dispose() {
    debugPrint('Day Debit BLoC killed');
    dayEventStreamController.close();
    dayStateStreamController.close();
  }
}
