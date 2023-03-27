import 'dart:async';

import 'package:flutter/material.dart';

enum Validate { okay, notOkay }

class ValidatorBloc {
  final indexStateStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get stateSink => indexStateStreamController.sink;
  Stream<bool> get stateStream => indexStateStreamController.stream;

  final indexEventStreamController = StreamController<Validate>();
  StreamSink<Validate> get eventSink => indexEventStreamController.sink;
  Stream<Validate> get eventStream => indexEventStreamController.stream;

  ValidatorBloc() {
    bool temp = true;
    eventStream.listen((event) {
      if (event == Validate.okay) {
        temp = true;
      } else if (event == Validate.notOkay) {
        temp = false;
      }
      stateSink.add(temp);
      debugPrint('Validator Called ${temp.toString()}');
    });
  }
}
