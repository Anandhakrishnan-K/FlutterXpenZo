import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/validation_bloc.dart';
import 'package:xpenso/DataBase/data_model.dart';
import 'package:xpenso/Utils/add_cf_sheet.dart';
import 'package:xpenso/Utils/duration_card.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

//Creating Objects for the Class
final dayBloc = DayBloc();
final dayUpdateBloc = DayUpdateBloc();
final dayTotalCreditBloc = DayTotalCreditBloc();
final dayTotalDebitBloc = DayTotalDebitBloc();

//Creating Empty List
List<Ledger> emptyList = [];

//Object for Image Picker
int imageCount = 0;
final picker = ImagePicker();

//Image Variables
int attachFlag = 0;
String attachName = '';

class DayList extends StatefulWidget {
  const DayList({super.key});

  @override
  State<DayList> createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  File? image;
  Future<void> putImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        attachFlag = 1;
      });
      final localImageFile = await saveImage(File(pickedFile.path));
      debugPrint('Image path: ${localImageFile.path}');
    }
  }

  Future<File> saveImage(File tmpImgae) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageFile = await compressImage(tmpImgae);
    final imgPath = '${appDir.path}/${DateTime.now().toString()}.png';
    setState(() {
      attachName = imgPath;
    });
    final storedImage = await imageFile.copy(imgPath);
    debugPrint('Image Saved to Local');
    return storedImage;
  }

  Future<File> compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      '${imageFile.parent.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      quality: 50,
    );
    return result!;
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
        const SizedBox(
          height: height20,
        ),
        StreamBuilder(
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
        const SizedBox(
          height: height10,
        ),
        Expanded(
          child: Center(
            child: StreamBuilder(
              stream: dayUpdateBloc.stateStream,
              initialData: emptyList,
              builder: (context, snapshot) {
                List<Ledger> dayList = snapshot.data!;
                if (dayList.isEmpty) {
                  return SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyImageIcon(
                              color: Colors.grey,
                              totalSize: height100 * 1.5,
                              iconSize: height100 * 1.3,
                              path: 'assets/icons/embarrassed.png',
                              name: 'OOPS!!'),
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
                                        content:
                                            const MyText(content: 'Confirm'),
                                        height: height50,
                                        textSize: fontSizeSmall,
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        }),
                                    MyButton(
                                        content: const MyText(content: 'Back'),
                                        height: height50,
                                        textSize: fontSizeSmall,
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        })
                                  ],
                                );
                              },
                            );
                          },

                          // Dismiss Action assigning
                          key: Key(item),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            service.deleteData(item);
                            dayUpdateBloc.eventSink.add(DayUpdate.update);
                            dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                            dayTotalDebitBloc.eventSink.add(DayUpdate.debit);

                            // Display Snack bar when item deleted

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.white,
                                    dismissDirection:
                                        DismissDirection.endToStart,
                                    duration: Duration(seconds: 1),
                                    content: MyText(
                                        content: 'Record Deleted Sucessfully',
                                        size: fontSizeSmall)));
                          },

                          // list of values to be displayed designed below
                          child: GestureDetector(
                            onDoubleTap: () {
                              getImage(
                                  dayList[index].attachmentName.toString());
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
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
                                      height: height100 * 4,
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
                                            const MyText(
                                              maxlines: 20,
                                              content: 'Bill:',
                                              size: fontSizeSmall * 0.9,
                                            ),
                                            const SizedBox(
                                              height: height10,
                                            ),
                                            SizedBox(
                                              height: height100 * 3,
                                              width: deviceWidth * 0.85,
                                              child: image != null
                                                  ? Image.file(
                                                      image!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const Center(
                                                      child: MyImageIcon(
                                                          color: Colors.grey,
                                                          totalSize:
                                                              height100 * 1.5,
                                                          iconSize:
                                                              height100 * 1.3,
                                                          path:
                                                              'assets/icons/embarrassed.png',
                                                          name: 'No Bills!!'),
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
                              padding:
                                  const EdgeInsets.only(top: height10 / 1.5),
                              child: Container(
                                height: height80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(height10),
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              MainAxisAlignment.start,
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
        Container(
          padding: const EdgeInsets.only(top: height10),
          width: deviceWidth * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: durationCardHeight,
                width: deviceWidth * 0.4,
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(height10)),
                child: MyButton(
                    fillColor: transparent,
                    content: const MyText(
                      content: 'Add Credit',
                    ),
                    onPressed: () {
                      amountController.clear();
                      notesController.clear();
                      setState(() {
                        attachFlag = 0;
                        attachName = 'NA';
                        amountValid = true;
                        selectedIndex1 = List.filled(30, false);
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(height20),
                                  topRight: Radius.circular(height20))),
                          isDismissible: false,
                          isScrollControlled: true,
                          elevation: height20,
                          context: context,
                          builder: (context) {
                            return StreamBuilder(
                                initialData: true,
                                stream: validatorBloc.stateStream,
                                builder: (context, snapshot) {
                                  return Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,

                                      //************* Add CF | Add Credit Calling here *************/
                                      child: AddCredit(
                                        //Uplaod images
                                        onPressedAt: () {
                                          putImage();
                                        },
                                        iscredit: true,
                                        list: incomeList,
                                        submitButtonName: 'Add credit / Income',
                                        onPressed: () async {
                                          setState(() {
                                            amountController.text.isEmpty
                                                ? amountValid = false
                                                : amountValid = true;
                                          });
                                          amountController.text.isEmpty
                                              ? validatorBloc.eventSink
                                                  .add(Validate.notOkay)
                                              : validatorBloc.eventSink
                                                  .add(Validate.okay);
                                          if (amountValid == true) {
                                            Ledger ledger = Ledger();
                                            ledger.amount = int.parse(
                                                amountController.text);
                                            ledger.notes = notesController.text;
                                            ledger.categoryFlag =
                                                1; //Credit: 1 | Debit 0
                                            ledger.categoryIndex = catIndex;
                                            ledger.day = d
                                                .format(dateSelected)
                                                .toString();
                                            ledger.month = m
                                                .format(dateSelected)
                                                .toString();
                                            ledger.year = y
                                                .format(dateSelected)
                                                .toString();
                                            ledger.createdT =
                                                DateTime.now().toString();
                                            ledger.attachmentFlag =
                                                attachFlag; //Attachment Flag temp set to 0
                                            ledger.attachmentName =
                                                attachFlag == 1
                                                    ? attachName
                                                    : 'NA';
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    dismissDirection:
                                                        DismissDirection
                                                            .endToStart,
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: MyText(
                                                      content:
                                                          'Credit Amount: ${ledger.amount} added successfully',
                                                      size: fontSizeSmall,
                                                    )));
                                            var result =
                                                await service.saveData(ledger);
                                            dayUpdateBloc.eventSink
                                                .add(DayUpdate.update);
                                            dayTotalCreditBloc.eventSink
                                                .add(DayUpdate.credit);
                                            dayTotalDebitBloc.eventSink
                                                .add(DayUpdate.debit);

                                            debugPrint(
                                                '${result.toString()} added to the list | amount: ${ledger.amount} | day: ${ledger.day} | Image: ${ledger.attachmentName}');
                                          } else {
                                            debugPrint(
                                                'Form Validation not sucessfull ${snapshot.data.toString()}');
                                          }
                                        },
                                      ));
                                });
                          },
                        );
                      });
                    }),
              ),
              Container(
                height: durationCardHeight,
                width: deviceWidth * 0.4,
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(height10)),
                child: MyButton(
                    fillColor: transparent,

                    //************* Add CF | Add Debit Calling here *************/
                    content: const MyText(content: 'Add Debit'),
                    onPressed: () {
                      attachFlag = 0;
                      attachName = 'NA';
                      amountController.clear();
                      notesController.clear();
                      setState(() {
                        amountValid = true;
                        selectedIndex1 = List.filled(30, false);
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(height20),
                                  topRight: Radius.circular(height20))),
                          isDismissible: false,
                          isScrollControlled: true,
                          elevation: height20,
                          context: context,
                          builder: (context) {
                            return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: AddCredit(
                                  //Uplaod images
                                  onPressedAt: () {
                                    putImage();
                                  },
                                  iscredit: true,
                                  list: expenseList,
                                  submitButtonName: 'Add Debit / Expense',
                                  onPressed: () async {
                                    setState(() {
                                      amountController.text.isEmpty
                                          ? amountValid = false
                                          : amountValid = true;
                                    });
                                    amountController.text.isEmpty
                                        ? validatorBloc.eventSink
                                            .add(Validate.notOkay)
                                        : validatorBloc.eventSink
                                            .add(Validate.okay);

                                    if (amountValid == true) {
                                      Ledger ledger = Ledger();
                                      ledger.amount =
                                          int.parse(amountController.text);
                                      ledger.notes = notesController.text;
                                      ledger.categoryFlag =
                                          0; //Credit = 1 | Debit =0
                                      ledger.categoryIndex = catIndex;
                                      ledger.day =
                                          d.format(dateSelected).toString();
                                      ledger.month =
                                          m.format(dateSelected).toString();
                                      ledger.year =
                                          y.format(dateSelected).toString();
                                      ledger.createdT =
                                          DateTime.now().toString();
                                      ledger.attachmentFlag =
                                          attachFlag; //Attachment Flag temp set to 0
                                      ledger.attachmentName =
                                          attachFlag == 1 ? attachName : 'NA';
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.white,
                                              dismissDirection:
                                                  DismissDirection.endToStart,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: MyText(
                                                content:
                                                    'Debit Amount: ${ledger.amount} added successfully',
                                                size: fontSizeSmall,
                                              )));
                                      var result =
                                          await service.saveData(ledger);
                                      dayUpdateBloc.eventSink
                                          .add(DayUpdate.update);
                                      dayTotalCreditBloc.eventSink
                                          .add(DayUpdate.credit);
                                      dayTotalDebitBloc.eventSink
                                          .add(DayUpdate.debit);
                                      debugPrint(
                                          '${result.toString()} added to the list | amount: ${ledger.amount} | day: ${ledger.day}');
                                    }
                                  },
                                ));
                          },
                        );
                      });
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: height20,
        ),
      ],
    );
  }
}
