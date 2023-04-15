// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpenso/BLoC/bloc_attach.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/BLoC/validation_bloc.dart';
import 'package:xpenso/DataBase/data_model.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/Utils/add_cf_sheet.dart';
import 'package:xpenso/Utils/home_sliver.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

import '../BLoC/bloc_duration.dart';

class AddCFButtons extends StatefulWidget {
  const AddCFButtons({super.key});

  @override
  State<AddCFButtons> createState() => _AddCFButtonsState();
}

class _AddCFButtonsState extends State<AddCFButtons> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      padding: const EdgeInsets.all(height20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: durationCardHeight,
            width: deviceWidth * 0.4,
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(height10)),
            child: MyButton(
                borderColor: Colors.grey.shade400,
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
                                  padding: MediaQuery.of(context).viewInsets,

                                  //************* Add CF | Add Credit Calling here *************/
                                  child: AddCredit(
                                    atFlag: attachFlag,
                                    //Uplaod images
                                    onPressedAt: () {
                                      //putImage();
                                      attachmentBloc.eventSink
                                          .add(Attachment.add);
                                    },
                                    onPressedRm: () {
                                      attachmentBloc.eventSink
                                          .add(Attachment.remove);
                                    },
                                    iscredit: true,
                                    list: incomeList,
                                    submitButtonName: 'Add credit / Income',
                                    onPressed: () async {
                                      // ignore: prefer_typing_uninitialized_variables
                                      var localImageFile;
                                      attachFlag == 1
                                          ? {
                                              localImageFile = await saveImage(
                                                  File(pickedFile.path)),
                                              debugPrint(
                                                  'Image path: ${localImageFile.path}'),
                                            }
                                          : {
                                              debugPrint(
                                                  'No Bills (Images) to be uploaded')
                                            };
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
                                            double.parse(amountController.text);
                                        ledger.notes = notesController.text;
                                        ledger.categoryFlag =
                                            1; //Credit: 1 | Debit 0
                                        ledger.categoryIndex = catIndex;
                                        ledger.category =
                                            incomeNameList[catIndex];
                                        ledger.day =
                                            d.format(dateSelected).toString();
                                        ledger.month =
                                            m.format(dateSelected).toString();
                                        ledger.year =
                                            y.format(dateSelected).toString();
                                        ledger.createdT =
                                            DateTime.now().toString();
                                        ledger.attachmentFlag = attachFlag;
                                        ledger.attachmentName =
                                            attachFlag == 1 ? attachName : 'NA';
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                elevation: 0,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Colors.white,
                                                dismissDirection:
                                                    DismissDirection.endToStart,
                                                duration:
                                                    const Duration(seconds: 1),
                                                content: Center(
                                                  child: MyText(
                                                    content:
                                                        'Credit Amount: ${ledger.amount} added successfully',
                                                    size: fontSizeSmall * 0.85,
                                                  ),
                                                )));
                                        var result =
                                            await service.saveData(ledger);
                                        dayUpdateBloc.eventSink
                                            .add(DayUpdate.update);
                                        dayTotalCreditBloc.eventSink
                                            .add(DayUpdate.credit);
                                        dayTotalDebitBloc.eventSink
                                            .add(DayUpdate.debit);
                                        getBalanceBloc.eventSink
                                            .add(GetBal.get);

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
                color: appColor, borderRadius: BorderRadius.circular(height10)),
            child: MyButton(
                borderColor: Colors.grey.shade400,
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
                              atFlag: attachFlag,
                              //Uplaod images
                              onPressedAt: () {
                                //putImage();
                                attachmentBloc.eventSink.add(Attachment.add);
                              },
                              onPressedRm: () {
                                attachmentBloc.eventSink.add(Attachment.remove);
                              },
                              iscredit: true,
                              list: expenseList,
                              submitButtonName: 'Add Debit / Expense',
                              onPressed: () async {
                                // ignore: prefer_typing_uninitialized_variables
                                var localImageFile;
                                attachFlag == 1
                                    ? {
                                        localImageFile = await saveImage(
                                            File(pickedFile.path)),
                                        debugPrint(
                                            'Image path: ${localImageFile.path}'),
                                      }
                                    : {
                                        debugPrint(
                                            'No Bills (Images) to be uploaded')
                                      };
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
                                      double.parse(amountController.text);
                                  ledger.notes = notesController.text;
                                  ledger.categoryFlag =
                                      0; //Credit = 1 | Debit =0
                                  ledger.categoryIndex = catIndex;
                                  ledger.category = expenseNameList[catIndex];
                                  ledger.day =
                                      d.format(dateSelected).toString();
                                  ledger.month =
                                      m.format(dateSelected).toString();
                                  ledger.year =
                                      y.format(dateSelected).toString();
                                  ledger.createdT = DateTime.now().toString();
                                  ledger.attachmentFlag =
                                      attachFlag; //Attachment Flag temp set to 0
                                  ledger.attachmentName =
                                      attachFlag == 1 ? attachName : 'NA';
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.white,
                                          dismissDirection:
                                              DismissDirection.endToStart,
                                          duration: const Duration(seconds: 1),
                                          content: Center(
                                            child: MyText(
                                              content:
                                                  'Debit Amount: ${ledger.amount} added successfully',
                                              size: fontSizeSmall * 0.85,
                                            ),
                                          )));
                                  var result = await service.saveData(ledger);
                                  dayUpdateBloc.eventSink.add(DayUpdate.update);
                                  dayTotalCreditBloc.eventSink
                                      .add(DayUpdate.credit);
                                  dayTotalDebitBloc.eventSink
                                      .add(DayUpdate.debit);
                                  getBalanceBloc.eventSink.add(GetBal.get);
                                  debugPrint(
                                      '${result.toString()} added to the list | amount: ${ledger.amount} | day: ${ledger.day} | Attachment: ${ledger.attachmentName}');
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
    );
  }
}
