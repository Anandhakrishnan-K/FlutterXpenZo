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

//Creating Objects for the Class
final dayBloc = DayBloc();
final dayUpdateBloc = DayUpdateBloc();
final dayTotalCreditBloc = DayTotalCreditBloc();
final dayTotalDebitBloc = DayTotalDebitBloc();

//Creating Empty List
List<Ledger> emptyList = [];

class DayList extends StatefulWidget {
  const DayList({super.key});

  @override
  State<DayList> createState() => _DayListState();
}

class _DayListState extends State<DayList> {
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
                        final item = dayList[index].toString();

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
                                  padding: EdgeInsets.all(height20),
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
                            setState(() {
                              dayList.removeAt(index);
                            });

                            // Display Snack bar when item deleted

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.white,
                                dismissDirection: DismissDirection.endToStart,
                                duration: const Duration(seconds: 1),
                                content: MyText(
                                    content:
                                        'Item ${index.toString()} Delete Sucessfully',
                                    size: fontSizeSmall)));
                          },

                          // list of values to be displayed designed below
                          child: GestureDetector(
                            onDoubleTap: () {
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
                                      height: height100,
                                      width: deviceWidth * 0.9,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                                content: dayList[index]
                                                            .categoryFlag ==
                                                        0
                                                    ? 'Category:    Debit'
                                                    : 'Category:    Credit'),
                                            MyText(
                                                content:
                                                    'Date:    ${dayList[index].day} - ${dayList[index].month}'),
                                            MyText(
                                                content:
                                                    'Created On:  ${dateWithTime.format(DateTime.parse(dayList[index].createdT.toString())).toString()}'),
                                            MyText(
                                              maxlines: 20,
                                              content: dayList[index].notes ==
                                                      ''
                                                  ? 'Notes:   < No Notes >'
                                                  : 'Notes:    ${dayList[index].notes}',
                                              size: fontSizeSmall * 0.9,
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
                                      child: AddCredit(
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
                                                0; //Attachment Flag temp set to 0
                                            ledger.attachmentName = 'NA';
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
                                                '${result.toString()} added to the list | amount: ${ledger.amount} | day: ${ledger.day}');
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
                    content: const MyText(content: 'Add Debit'),
                    onPressed: () {
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
                                          0; //Attachment Flag temp set to 0
                                      ledger.attachmentName = 'NA';
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
