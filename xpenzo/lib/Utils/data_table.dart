import 'package:flutter/material.dart';
import 'package:xpenso/BLoC/bloc_month.dart';
import 'package:xpenso/BLoC/year_bloc.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

List<MapEntry<DateTime, MapEntry<double, double>>> emptyList = [];

class DataTableCF extends StatefulWidget {
  const DataTableCF({super.key});

  @override
  State<DataTableCF> createState() => _DataTableCFState();
}

class _DataTableCFState extends State<DataTableCF> {
  @override
  void initState() {
    monthTotalListBloc.eventSink.add(MonthUpdate.update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: monthTotalListBloc.stateStream,
          initialData: emptyList,
          builder: (context, snapshot) {
            List<MapEntry<DateTime, MapEntry<double, double>>> tmpData =
                snapshot.data!;

            List<DataRow> dataList = tmpData.map((entry) {
              return DataRow(
                cells: [
                  DataCell(Text(day.format(entry.key).toString())),
                  DataCell(Text(entry.value.key.toString())),
                  DataCell(Text(entry.value.value.toString())),
                ],
              );
            }).toList();

            if (tmpData.isEmpty &&
                snapshot.connectionState != ConnectionState.waiting) {
              return SizedBox(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: height100 * 1.5,
                      ),
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
                              'No Data Available for ${month.format(dateSelected).toString()}'),
                    ],
                  ),
                ),
              );
            } else {
              double totalIncome = 0;
              double totalExpense = 0;
              for (int i = 0; i < tmpData.length; i++) {
                totalIncome += tmpData[i].value.key;
                totalExpense += tmpData[i].value.value;
              }
              return DataTable(
                  // headingRowColor:
                  //     MaterialStateColor.resolveWith((states) => appColor),
                  headingRowHeight: height100,
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(
                        label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        MyText(
                          content: 'Date',
                          isHeader: true,
                        ),
                        SizedBox(
                          height: height10,
                        ),
                        MyText(content: '(Total)')
                      ],
                    )),
                    DataColumn(
                        label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyText(
                          content: 'Income',
                          isHeader: true,
                        ),
                        const SizedBox(
                          height: height10,
                        ),
                        MyText(content: '(${totalIncome.toString()})')
                      ],
                    )),
                    DataColumn(
                        label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyText(
                          content: 'Expense',
                          isHeader: true,
                        ),
                        const SizedBox(
                          height: height10,
                        ),
                        MyText(content: '(${totalExpense.toString()})')
                      ],
                    )),
                  ],
                  rows: dataList);
            }
          }),
    );
  }
}

class DataTableCFYear extends StatefulWidget {
  const DataTableCFYear({super.key});

  @override
  State<DataTableCFYear> createState() => _DataTableCFYearState();
}

class _DataTableCFYearState extends State<DataTableCFYear> {
  @override
  void initState() {
    yearTotalListBloc.eventSink.add(YearUpdate.update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: yearTotalListBloc.stateStream,
          initialData: emptyList,
          builder: (context, snapshot) {
            List<MapEntry<DateTime, MapEntry<double, double>>> tmpData =
                snapshot.data!;

            List<DataRow> dataList = tmpData.map((entry) {
              return DataRow(
                cells: [
                  DataCell(Text(month.format(entry.key).toString())),
                  DataCell(Text(entry.value.key.toString())),
                  DataCell(Text(entry.value.value.toString())),
                ],
              );
            }).toList();
            if (tmpData.isEmpty &&
                snapshot.connectionState != ConnectionState.waiting) {
              return SizedBox(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: height100 * 1.5,
                      ),
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
                              'No Data Available for ${year.format(dateSelected).toString()}'),
                    ],
                  ),
                ),
              );
            } else {
              double totalIncome = 0;
              double totalExpense = 0;
              for (int i = 0; i < tmpData.length; i++) {
                totalIncome += tmpData[i].value.key;
                totalExpense += tmpData[i].value.value;
              }
              return DataTable(
                  // headingRowColor:
                  //     MaterialStateColor.resolveWith((states) => appColor),
                  headingRowHeight: height100,
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(
                        label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        MyText(
                          content: 'Date',
                          isHeader: true,
                        ),
                        SizedBox(
                          height: height10,
                        ),
                        MyText(content: '(Total)')
                      ],
                    )),
                    DataColumn(
                        label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyText(
                          content: 'Income',
                          isHeader: true,
                        ),
                        const SizedBox(
                          height: height10,
                        ),
                        MyText(content: '(${totalIncome.toString()})')
                      ],
                    )),
                    DataColumn(
                        label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MyText(
                          content: 'Expense',
                          isHeader: true,
                        ),
                        const SizedBox(
                          height: height10,
                        ),
                        MyText(content: '(${totalExpense.toString()})')
                      ],
                    )),
                  ],
                  rows: dataList);
            }
          }),
    );
  }
}
