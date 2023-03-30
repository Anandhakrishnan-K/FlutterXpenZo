import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xpenso/ListBuilders/day_list.dart';

enum Attachment { add, remove }

class AttachmentBloc {
  final attStateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get stateSink => attStateStreamController.sink;
  Stream<int> get stateStream => attStateStreamController.stream;

  final attEventStreamController = StreamController<Attachment>();
  StreamSink<Attachment> get eventSink => attEventStreamController.sink;
  Stream<Attachment> get eventStream => attEventStreamController.stream;

  AttachmentBloc() {
    eventStream.listen((event) async {
      if (event == Attachment.add) {
        pickedFile = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 20);
        if (pickedFile != null) {
          attachFlag = 1;
        } else {
          attachFlag = 0;
        }
        debugPrint(
            'Image Loaded in temp | flag set to ${attachFlag.toString()}');
      } else if (event == Attachment.remove) {
        attachFlag = 0;
      }
      stateSink.add(attachFlag);
      debugPrint('Attachment Flag: ${attachFlag.toString()}');
    });
  }
}
