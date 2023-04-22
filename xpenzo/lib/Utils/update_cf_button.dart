// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xpenso/BLoC/bloc_attach.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/BLoC/bloc_duration.dart';
import 'package:xpenso/BLoC/validation_bloc.dart';
import 'package:xpenso/DataBase/data_model.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/Utils/add_cf_sheet.dart';
import 'package:xpenso/Utils/home_sliver.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:xpenso/main.dart';

class UpdateButton extends StatefulWidget {
  final int id;
  final double amount;
  final int catFlg;
  final int catIndex;
  final int attachFlg;
  final String notes;
  final String attName;
  final String day;
  final String month;
  final String year;
  final String createdT;

  const UpdateButton(
      {super.key,
      required this.amount,
      required this.catIndex,
      required this.attachFlg,
      required this.notes,
      required this.attName,
      required this.catFlg,
      required this.day,
      required this.month,
      required this.year,
      required this.createdT,
      required this.id});

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  bool isAttChange = false;
  Future<File> saveImage(File tmpImgae) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imgPath = '${appDir.path}/${DateTime.now().toString()}.png';
      setState(() {
        attachName = imgPath;
      });
      final storedImage = await tmpImgae.copy(imgPath);
      debugPrint('Image Saved to Local');
      return storedImage;
    } catch (e) {
      const storedImage = null;
      debugPrint('Image Not Present ${e.toString()}');
      return storedImage;
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

  @override
  Widget build(BuildContext context) {
    return MyButton(
        borderColor: Colors.grey.shade300,
        content: const MyText(content: 'Update'),
        onPressed: () {
          setState(() {
            isAttChange = false;
            attachFlag = widget.attachFlg;
            attachName = widget.attName;
            amountController.text = widget.amount.toString();
            notesController.text = widget.notes;
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
                    //Calling Add CF Function Here
                    child: AddCredit(
                      catIndex: widget.catIndex,
                      isUpdate: true,
                      amt: widget.amount.toString(),
                      notes: widget.notes,
                      atFlag: attachFlag,
                      //Uplaod images
                      onPressedAt: () {
                        //putImage();
                        attachmentBloc.eventSink.add(Attachment.add);
                      },
                      onPressedRm: () {
                        attachmentBloc.eventSink.add(Attachment.remove);
                        deleteImage(widget.attName);
                        setState(() {
                          isAttChange = true;
                        });
                      },
                      iscredit: widget.catFlg == 1 ? true : false,
                      list: widget.catFlg == 1 ? incomeList : expenseList,
                      submitButtonName:
                          widget.catFlg == 1 ? 'Update Credit' : 'Update Debit',
                      onPressed: () async {
                        // ignore: prefer_typing_uninitialized_variables
                        var localImageFile;

                        try {
                          attachFlag == 1 && isAttChange == true
                              ? {
                                  localImageFile =
                                      await saveImage(File(pickedFile.path)),
                                  debugPrint(
                                      'Image path: ${localImageFile.path}'),
                                }
                              : {
                                  debugPrint('No Bills (Images) to be uploaded')
                                };
                        } catch (e) {
                          debugPrint('Path is Empty $e');
                        }
                        setState(() {
                          amountController.text.isEmpty
                              ? amountValid = false
                              : amountValid = true;
                        });
                        amountController.text.isEmpty
                            ? validatorBloc.eventSink.add(Validate.notOkay)
                            : validatorBloc.eventSink.add(Validate.okay);

                        if (amountValid == true) {
                          Ledger ledger = Ledger();
                          ledger.id = widget.id;
                          ledger.amount = double.parse(amountController.text);
                          ledger.notes = notesController.text;
                          ledger.categoryFlag =
                              widget.catFlg; //Credit = 1 | Debit =0
                          ledger.categoryIndex = catIndex;
                          ledger.category = catIndex == 1
                              ? incomeNameList[catIndex]
                              : expenseNameList[catIndex];
                          ledger.attachmentFlag =
                              attachFlag; //Attachment Flag temp set to 0
                          ledger.attachmentName =
                              attachFlag == 1 ? attachName : 'NA';
                          ledger.day = widget.day;
                          ledger.month = widget.month;
                          ledger.year = widget.year;
                          ledger.createdT = widget.createdT;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.white,
                                  dismissDirection: DismissDirection.endToStart,
                                  duration: Duration(seconds: 1),
                                  content: Center(
                                    child: MyText(
                                      content: 'Record Updated Successfully',
                                      size: fontSizeSmall * 0.85,
                                    ),
                                  )));
                          var result = await service.updateCF(ledger);
                          dayUpdateBloc.eventSink.add(DayUpdate.update);
                          dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
                          dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
                          getBalanceBloc.eventSink.add(GetBal.get);
                          isBalBloc.eventSink.add(GetBal.check);
                          deleteCacheDir();
                          debugPrint(
                              '${result.toString()} Updated | amount: ${ledger.amount} | day: ${ledger.day} | Attachment: ${ledger.attachmentName}');
                        }
                      },
                    ));
              },
            );
          });
        });
  }
}
