import 'dart:async';

import 'package:flutter/material.dart';

enum IndexUpdate { day, month, year }

class IndexUpdateBloc {
  final indexStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get stateSink => indexStateStreamController.sink;
  Stream<int> get stateStream => indexStateStreamController.stream;

  final indexEventStreamController = StreamController<IndexUpdate>();
  StreamSink<IndexUpdate> get eventSink => indexEventStreamController.sink;
  Stream<IndexUpdate> get eventStream => indexEventStreamController.stream;

  IndexUpdateBloc() {
    int temp = 0;
    eventStream.listen((event) {
      if (event == IndexUpdate.day) {
        temp = 0;
      } else if (event == IndexUpdate.month) {
        temp = 1;
      } else if (event == IndexUpdate.year) {
        temp = 2;
      }
      stateSink.add(temp);
      debugPrint('PageIndex BLoC called | Index updated to ${temp.toString()}');
    });
  }
}
