import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xpenso/Pages/profile_page.dart';

enum ProfileUpdate { update }

class ProfileUpdateBloc {
  final profileStateStreamController = StreamController<File?>.broadcast();
  StreamSink<File?> get stateSink => profileStateStreamController.sink;
  Stream<File?> get stateStream => profileStateStreamController.stream;

  final profileEventStreamController = StreamController<ProfileUpdate>();
  StreamSink<ProfileUpdate> get eventSink => profileEventStreamController.sink;
  Stream<ProfileUpdate> get eventStream => profileEventStreamController.stream;

  ProfileUpdateBloc() {
    eventStream.listen((event) async {
      String tmp = '';
      File? image;
      if (event == ProfileUpdate.update) {
        tmp = await user.getProfilePath();
        final imgPath = tmp;
        if (imgPath != 'assets/icons/man.png') {
          debugPrint('Image Retrieved from Local $imgPath');

          image = File(imgPath);
        } else {
          image = null;

          debugPrint('No Image available for selected tile');
        }
      }
      stateSink.add(image);
      debugPrint('Profile Picture Update Bloc Called');
    });
  }
}
