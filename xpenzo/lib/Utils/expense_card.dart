import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_day_update.dart';
import 'package:xpenso/ListBuilders/day_list.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class ExpensecardDay extends StatefulWidget {
  const ExpensecardDay({super.key});

  @override
  State<ExpensecardDay> createState() => _ExpensecardDayState();
}

class _ExpensecardDayState extends State<ExpensecardDay> {
  @override
  void initState() {
    dayTotalCreditBloc.eventSink.add(DayUpdate.credit);
    dayTotalDebitBloc.eventSink.add(DayUpdate.debit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(height20),
      height: mainTabHeight,
      child: Container(
        decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(height20))),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: deviceWidth * 0.9 / 2.1,
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          size: fontSizeBig,
                          color: Colors.green,
                        ),
                        StreamBuilder(
                          initialData: 0,
                          stream: dayTotalCreditBloc.stateStream,
                          builder: (context, snapshot) {
                            return MyText(
                              content: snapshot.data!.toString(),
                              size: fontSizeBig,
                              color: Colors.green,
                              isHeader: true,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: height10,
                    ),
                    const MyText(
                      content: 'Total Income',
                      size: fontSizeSmall * 0.9,
                    )
                  ],
                )),
              ),
              const VerticalDivider(
                thickness: 1,
                indent: height10,
                endIndent: height10,
              ),
              SizedBox(
                width: deviceWidth * 0.9 / 2.1,
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          size: fontSizeBig,
                          color: Colors.red,
                        ),
                        StreamBuilder(
                          initialData: 0,
                          stream: dayTotalDebitBloc.stateStream,
                          builder: (context, snapshot) {
                            return MyText(
                              content: snapshot.data!.toString(),
                              size: fontSizeBig,
                              color: Colors.red,
                              isHeader: true,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: height10,
                    ),
                    const MyText(
                      content: 'Total Expense',
                      size: fontSizeSmall * 0.9,
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseCardMonth extends StatefulWidget {
  const ExpenseCardMonth({super.key});

  @override
  State<ExpenseCardMonth> createState() => _ExpenseCardMonthState();
}

class _ExpenseCardMonthState extends State<ExpenseCardMonth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(height20),
      height: mainTabHeight,
      child: Container(
        decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(height20))),
        child: const Center(
          child: Text('Month'),
        ),
      ),
    );
  }
}

class ExpenseCardYear extends StatefulWidget {
  const ExpenseCardYear({super.key});

  @override
  State<ExpenseCardYear> createState() => _ExpenseCardYearState();
}

class _ExpenseCardYearState extends State<ExpenseCardYear> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(height20),
      height: mainTabHeight,
      child: Container(
        decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(height20))),
        child: const Center(
          child: Text('Year'),
        ),
      ),
    );
  }
}
