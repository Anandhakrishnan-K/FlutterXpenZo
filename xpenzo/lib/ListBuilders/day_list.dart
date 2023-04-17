// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/DataBase/data_model.dart';
import 'package:xpenso/Utils/duration_card.dart';
import 'package:xpenso/Utils/home_sliver.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xpenso/Utils/full_screen_widget.dart';
import 'package:xpenso/main.dart';

//Creating Objects for the Class
final dayBloc = DayBloc();
final dayUpdateBloc = DayUpdateBloc();
final dayTotalCreditBloc = DayTotalCreditBloc();
final dayTotalDebitBloc = DayTotalDebitBloc();

//Creating Empty List
List<Ledger> emptyList = [];

//Object for Image Picker
final picker = ImagePicker();
// ignore: avoid_init_to_null
var pickedFile = null;
// ignore: avoid_init_to_null
var storedImage = null;

//Image Variables
int attachFlag = 0;
String attachName = '';

class DayList extends StatefulWidget {
  final bool mainPage;
  const DayList({super.key, this.mainPage = false});

  @override
  State<DayList> createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  File? image;
  Future<void> putImage() async {
    pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        attachFlag = 1;
      });
    }
  }

  Future<File> saveImage(File tmpImgae) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imgPath = '${appDir.path}/${DateTime.now().toString()}.png';
    setState(() {
      attachName = imgPath;
    });
    final storedImage = await tmpImgae.copy(imgPath);
    debugPrint('Image Saved to Local');
    return storedImage;
  }

  Future<void> getImage(String img) async {
    final imgPath = img;
    if (imgPath != 'NA') {
      debugPrint('Image Retrieved from Local $imgPath');
      setState(() {
        image = File(imgPath);
      });
    } else {
      setState(() {
        image = null;
      });
      debugPrint('No Image available for selected tile');
    }
  }

  Future<void> deleteImage(String img) async {
    try {
      final imgPath = img;
      if (imgPath.isNotEmpty) {
        await File(imgPath).delete();
        debugPrint('Image Deleted Sucessfully $imgPath');
      } else {
        debugPrint('Nothing to delete');
      }
    } catch (e) {
      debugPrint('Image Not Present ${e.toString()}');
    }
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
    debugPrint('Cache Cleared');
  }

  Future pickDate(BuildContext context) async {
    final DateTime? picked = await DatePicker.showSimpleDatePicker(context,
        titleText: 'Pick a Date',
        itemTextStyle: const TextStyle(fontSize: fontSizeBig),
        dateFormat: 'dd-MMM-yyyy',
        looping: true,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));

    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = picked;
        dayBloc.eventSink.add(DayEvent.jump);
        dayUpdateBloc.eventSink.add(DayUpdate.update);
        dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
        dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
      });
    }
  }

  @override
  void initState() {
    deleteCacheDir();
    dayUpdateBloc.eventSink.add(DayUpdate.update);
    debugPrint('From Day List Init State Method | State Initiated');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('From Day List Dispose State Method | State Killed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !widget.mainPage,
          child: const SizedBox(
            height: height20,
          ),
        ),
        Visibility(
          visible: !widget.mainPage,
          child: StreamBuilder(
            stream: dayBloc.stateStream,
            initialData: dateSelected,
            builder: (context, snapshot) {
              DateTime tmpDate = snapshot.data!;
              return DurationCard(
                  onPressedPlus: () {
                    dayBloc.eventSink.add(DayEvent.add);
                    dayUpdateBloc.eventSink.add(DayUpdate.update);
                    dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                    dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
                  },
                  onPressedMinus: () {
                    dayBloc.eventSink.add(DayEvent.minus);
                    dayUpdateBloc.eventSink.add(DayUpdate.update);
                    dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                    dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
                  },
                  onPressedJump: () {
                    dayBloc.eventSink.add(DayEvent.jump0);
                    dayUpdateBloc.eventSink.add(DayUpdate.update);
                    dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                    dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
                    pickDate(context);
                  },
                  content:
                      '${day.format(tmpDate)} (${weekDay.format(tmpDate).toString()})');
            },
          ),
        ),
        Visibility(
          visible: !widget.mainPage,
          child: const SizedBox(
            height: height20,
          ),
        ),
        Expanded(
          child: Center(
            child: StreamBuilder(
              stream: dayUpdateBloc.stateStream,
              initialData: emptyList,
              builder: (context, snapshot) {
                List<Ledger> dayList = snapshot.data!;
                if (dayList.isEmpty &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  return SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: widget.mainPage
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: widget.mainPage,
                              child: const SizedBox(
                                height: height20,
                              )),
                          const MyImageIcon(
                            color: Colors.grey,
                            totalSize: height100 * 1.5,
                            iconSize: height100 * 1.3,
                            path: 'assets/icons/embarrassed.png',
                            nameVis: false,
                          ),
                          const SizedBox(
                            height: height20,
                          ),
                          MyText(
                              color: Colors.grey,
                              content:
                                  'No Data Available for ${day.format(dateSelected).toString()}'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: deviceWidth / 20),
                    child: ListView.builder(
                      controller: mainPageDrawer,
                      physics: const BouncingScrollPhysics(),
                      itemCount: dayList.length,
                      itemBuilder: (context, index) {
                        final item = dayList[index].id.toString();

                        // Dismissable Widget Startes Here
                        return Dismissible(
                          // Backgroung when the list tile is dragged
                          background: Padding(
                            padding: const EdgeInsets.only(top: height10),
                            child: Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                  color: exRed,
                                  borderRadius:
                                      BorderRadius.circular(height10)),
                              child: const Padding(
                                  padding: EdgeInsets.only(right: height40),
                                  child: Icon(Icons.delete)),
                            ),
                          ),

                          // To display Alert Box when dismissed whether to confirm / Delete
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const MyText(
                                    content: 'Are you sure to delete ?',
                                    size: fontSizeBig,
                                  ),
                                  content: const MyText(
                                    maxlines: 2,
                                    content:
                                        'This will be permanent action and cannot be reverted',
                                    size: fontSizeSmall,
                                  ),
                                  actions: [
                                    MyButton(
                                        content: const MyText(content: 'Back'),
                                        height: height50,
                                        textSize: fontSizeSmall,
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        }),
                                    MyButton(
                                        content:
                                            const MyText(content: 'Confirm'),
                                        height: height50,
                                        textSize: fontSizeSmall,
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        }),
                                  ],
                                );
                              },
                            );
                          },

                          // Dismiss Action assigning
                          key: Key(item),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            if (dayList[index].attachmentFlag != 0) {
                              deleteImage(
                                  dayList[index].attachmentName.toString());
                            }
                            service.deleteData(item);
                            dayUpdateBloc.eventSink.add(DayUpdate.update);
                            dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                            dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
                            getBalanceBloc.eventSink.add(GetBal.get);
                            isBalBloc.eventSink.add(GetBal.check);

                            // Display Snack bar when item deleted

                            debugPrint('Deteted Sucessfully');

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    elevation: 0,
                                    width: deviceWidth * 0.75,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.white,
                                    dismissDirection:
                                        DismissDirection.endToStart,
                                    duration: Duration(seconds: 1),
                                    content: Center(
                                      child: MyText(
                                          content: 'Record Deleted Sucessfully',
                                          size: fontSizeSmall * 0.85),
                                    )));
                          },

                          // list of values to be displayed designed below
                          child: GestureDetector(
                            onTap: () {
                              getImage(
                                  dayList[index].attachmentName.toString());
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      MyButton(
                                          content:
                                              const MyText(content: 'Update'),
                                          onPressed: () {}),
                                      MyButton(
                                          content:
                                              const MyText(content: 'Close'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                    title: Center(
                                      child: MyText(
                                        isHeader: true,
                                        content:
                                            'Amount:   ${dayList[index].amount.toString()}',
                                        color: dayList[index].categoryFlag == 0
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    content: SizedBox(
                                      height: image != null
                                          ? height100 * 4
                                          : height100 * 1.5,
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                                size: fontSizeSmall * 0.9,
                                                content: dayList[index]
                                                            .categoryFlag ==
                                                        0
                                                    ? 'Category:    Debit'
                                                    : 'Category:    Credit'),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            MyText(
                                                size: fontSizeSmall * 0.9,
                                                content:
                                                    'Date:    ${dayList[index].day} - ${dayList[index].month} - ${dayList[index].year}'),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            MyText(
                                                size: fontSizeSmall * 0.9,
                                                content:
                                                    'Created On:  ${dateWithTime.format(DateTime.parse(dayList[index].createdT.toString())).toString()}'),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            MyText(
                                              maxlines: 20,
                                              content: dayList[index].notes ==
                                                      ''
                                                  ? 'Notes:   < No Notes >'
                                                  : 'Notes:    ${dayList[index].notes}',
                                              size: fontSizeSmall * 0.9,
                                            ),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            Visibility(
                                              visible:
                                                  image != null ? true : false,
                                              child: const MyText(
                                                maxlines: 20,
                                                content: 'Bill:',
                                                size: fontSizeSmall * 0.9,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            Visibility(
                                              visible:
                                                  image != null ? true : false,
                                              child: SizedBox(
                                                width: deviceWidth * 0.85,
                                                child: image != null
                                                    ? InstaImageViewer(
                                                        disableSwipeToDismiss:
                                                            true,
                                                        child: Image.file(
                                                          image!,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: height10),
                              child: SizedBox(
                                height: height80,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: deviceWidth / 8,
                                          child: dayList[index].categoryFlag ==
                                                  0
                                              ? expenseList[
                                                  dayList[index].categoryIndex!]
                                              : incomeList[dayList[index]
                                                  .categoryIndex!]),
                                      const SizedBox(
                                        width: deviceWidth / 16,
                                      ),
                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: height10 / 2,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_rounded,
                                                  color: Colors.black,
                                                  size: fontSizeSmall,
                                                ),
                                                MyText(
                                                  content:
                                                      ' ${dayList[index].amount.toString()}',
                                                  size: fontSizeSmall,
                                                  isHeader: true,
                                                ),
                                                const SizedBox(
                                                  width: deviceWidth / 16,
                                                ),
                                                Icon(
                                                  dayList[index].categoryFlag ==
                                                          0
                                                      ? Icons.arrow_upward
                                                      : Icons.arrow_downward,
                                                  color: dayList[index]
                                                              .categoryFlag ==
                                                          0
                                                      ? Colors.red
                                                      : Colors.green,
                                                  size: fontSizeBig,
                                                ),
                                                const SizedBox(
                                                  width: deviceWidth / 16,
                                                ),
                                                Visibility(
                                                  visible: dayList[index]
                                                              .attachmentFlag ==
                                                          1
                                                      ? true
                                                      : false,
                                                  child: const Icon(
                                                    Icons.attach_file_outlined,
                                                    color: black,
                                                    size: fontSizeBig,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            // SizedBox(
                                            //   height: height20,
                                            //   width: deviceWidth * 0.6,
                                            //   child: MyText(
                                            //     content:
                                            //         'Created on: ${day.format(DateTime.parse(dayList[index].createdT!)).toString()}',
                                            //     size: fontSizeSmall * 0.8,
                                            //   ),
                                            // ),
                                            SizedBox(
                                              height: height20,
                                              width: deviceWidth * 0.6,
                                              child: MyText(
                                                content: dayList[index].notes ==
                                                        ''
                                                    ? '< No Notes >'
                                                    : '${dayList[index].notes}',
                                                size: fontSizeSmall * 0.9,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
