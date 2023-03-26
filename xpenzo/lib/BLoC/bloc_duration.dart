import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';

DateTime date = dateSelected;

enum MonthEvent { add, minus, jump, jump0 }

class MonthBloc {
  final monthStateStreameController = StreamController<DateTime>.broadcast();
  StreamSink<DateTime> get stateSink => monthStateStreameController.sink;
  Stream<DateTime> get stateStream => monthStateStreameController.stream;

  final monthEventStreamController = StreamController<MonthEvent>();
  StreamSink<MonthEvent> get eventSink => monthEventStreamController.sink;
  Stream<MonthEvent> get eventStream => monthEventStreamController.stream;

  MonthBloc() {
    eventStream.listen((event) {
      if (event == MonthEvent.add) {
        date = DateTime(date.year, date.month + 1, date.day);
      } else if (event == MonthEvent.minus) {
        date = DateTime(date.year, date.month - 1, date.day);
      } else if (event == MonthEvent.jump) {
      } else if (event == MonthEvent.jump0) {
        date = DateTime.now();
      }
      dateSelected = date;
      debugPrint(
          'From Month Bloc | Date Modified to : ${date.toString()} } | Original Date : ${dateSelected.toString()}');
      stateSink.add(date);
    });
  }
}

enum DayEvent { add, minus, jump, jump0 }

class DayBloc {
  final dayStateStreameController = StreamController<DateTime>.broadcast();
  StreamSink<DateTime> get stateSink => dayStateStreameController.sink;
  Stream<DateTime> get stateStream => dayStateStreameController.stream;

  final dayEventStreamController = StreamController<DayEvent>();
  StreamSink<DayEvent> get eventSink => dayEventStreamController.sink;
  Stream<DayEvent> get eventStream => dayEventStreamController.stream;

  DayBloc() {
    eventStream.listen((event) {
      if (event == DayEvent.add) {
        date = DateTime(date.year, date.month, date.day + 1);
      } else if (event == DayEvent.minus) {
        date = DateTime(date.year, date.month, date.day - 1);
      } else if (event == DayEvent.jump) {
        date = dateSelected;
      } else if (event == DayEvent.jump0) {
        date = DateTime.now();
      }
      dateSelected = date;
      debugPrint('From Day Bloc | Date Modified to : ${date.toString()}');
      stateSink.add(date);
    });
  }
}

enum YearEvent { add, minus, jump, jump0 }

class YearBloc {
  final yearStateStreameController = StreamController<DateTime>.broadcast();
  StreamSink<DateTime> get stateSink => yearStateStreameController.sink;
  Stream<DateTime> get stateStream => yearStateStreameController.stream;

  final yearEventStreamController = StreamController<YearEvent>();
  StreamSink<YearEvent> get eventSink => yearEventStreamController.sink;
  Stream<YearEvent> get eventStream => yearEventStreamController.stream;

  YearBloc() {
    eventStream.listen((event) {
      if (event == YearEvent.add) {
        date = DateTime(date.year + 1, date.month, date.day);
      } else if (event == YearEvent.minus) {
        date = DateTime(date.year - 1, date.month, date.day);
      } else if (event == YearEvent.jump) {
      } else if (event == YearEvent.jump0) {
        date = DateTime.now();
      }
      dateSelected = date;
      debugPrint(
          'From Year Bloc | Date Modified to : ${date.toString()} } | Original Date : ${dateSelected.toString()}');
      stateSink.add(date);
    });
  }
}
