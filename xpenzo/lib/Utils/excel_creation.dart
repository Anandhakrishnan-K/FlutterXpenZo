import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

List<MapEntry<DateTime, MapEntry<double, double>>> emptyList = [];

Future<bool> _requestPermission() async {
  if (Platform.isAndroid) {
    final permissionStatus = await Permission.manageExternalStorage.status;
    if (permissionStatus != PermissionStatus.granted) {
      final result = await Permission.manageExternalStorage.request();
      if (result != PermissionStatus.granted) {
        return false;
      }
    }
  }
  return true;
}

Future<void> saveExcelFile(
    List<MapEntry<DateTime, MapEntry<double, double>>> inputList) async {
  // Request the WRITE_EXTERNAL_STORAGE permission at runtime
  if (Platform.isAndroid) {
    if (!(await _requestPermission())) {
      return;
    }
  }
  // Create a new Excel document
  final excel = Excel.createExcel();

  // Add a new sheet to the document

  excel.rename('Sheet1', month.format(inputList[0].key).toString());
  final sheet = excel[month.format(inputList[0].key).toString()];
  final CellStyle headerCellStyle = CellStyle(
    backgroundColorHex: '#457b9d',
    fontColorHex: '#FFFFFF',
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
  );

  // Add some data to the sheet
  sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('C1'));
  sheet.cell(CellIndex.indexByString("A1")).value =
      "Monthly Report - ${m.format(inputList[0].key).toString()}";
  sheet.cell(CellIndex.indexByString("A1")).cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center);
  sheet.cell(CellIndex.indexByString("A2")).value = "Date";
  sheet.cell(CellIndex.indexByString("A2")).cellStyle = headerCellStyle;
  sheet.cell(CellIndex.indexByString("B2")).value = "Income";
  sheet.cell(CellIndex.indexByString("B2")).cellStyle = headerCellStyle;
  sheet.cell(CellIndex.indexByString("C2")).value = "Expense";
  sheet.cell(CellIndex.indexByString("C2")).cellStyle = headerCellStyle;
  double incomeTotal = 0;
  double expenseTotal = 0;
  for (int i = 0; i < inputList.length; i++) {
    incomeTotal += inputList[i].value.key;
    expenseTotal += inputList[i].value.value;
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: i + 2, columnIndex: 0))
        .value = day.format(inputList[i].key);
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: i + 2, columnIndex: 1))
        .value = inputList[i].value.key;
    sheet
        .cell(CellIndex.indexByColumnRow(rowIndex: i + 2, columnIndex: 2))
        .value = inputList[i].value.value;
  }
  int totalRowIndex = inputList.length + 2;

  sheet
      .cell(CellIndex.indexByColumnRow(rowIndex: totalRowIndex, columnIndex: 0))
      .value = "Total";
  sheet
      .cell(CellIndex.indexByColumnRow(rowIndex: totalRowIndex, columnIndex: 0))
      .cellStyle = headerCellStyle;
  sheet
      .cell(CellIndex.indexByColumnRow(rowIndex: totalRowIndex, columnIndex: 1))
      .value = incomeTotal;
  sheet
      .cell(CellIndex.indexByColumnRow(rowIndex: totalRowIndex, columnIndex: 1))
      .cellStyle = headerCellStyle;
  sheet
      .cell(CellIndex.indexByColumnRow(rowIndex: totalRowIndex, columnIndex: 2))
      .value = expenseTotal;
  sheet
      .cell(CellIndex.indexByColumnRow(rowIndex: totalRowIndex, columnIndex: 2))
      .cellStyle = headerCellStyle;

  // Create a file path
  final filePath =
      '/storage/emulated/0/Download/Report_${reportFormat.format(DateTime.now()).toString()}.xlsx';

  // Save the Excel document to the file
  final file = File(filePath);
  await file.writeAsBytes(excel.encode()!);

  // Show a toast message indicating the file was saved
  // Replace this with your preferred way of showing a message to the user
  debugPrint("File saved to $filePath");
}

class CreateExcelReportButton extends StatefulWidget {
  final DateTime? currDate;
  const CreateExcelReportButton({super.key, this.currDate});

  @override
  State<CreateExcelReportButton> createState() =>
      _CreateExcelReportButtonState();
}

class _CreateExcelReportButtonState extends State<CreateExcelReportButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: monthTotalListBloc.stateStream,
        initialData: emptyList,
        builder: (context, snapshot) {
          List<MapEntry<DateTime, MapEntry<double, double>>> tmpList =
              snapshot.data!;
          return MyButton(
              fillColor: transparent,
              content: const MyImageIcon(
                  path: 'assets/icons/excel.png',
                  name: 'Excel',
                  totalSize: height100 * 2,
                  iconSize: height40),
              onPressed: () {
                if (tmpList.isEmpty &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  return ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.white,
                          dismissDirection: DismissDirection.endToStart,
                          duration: Duration(seconds: 2),
                          content: Center(
                            child: MyText(
                              content:
                                  'No Data Available for Preparing Reports',
                              size: fontSizeSmall * 0.85,
                            ),
                          )));
                } else {
                  saveExcelFile(tmpList);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.white,
                      dismissDirection: DismissDirection.endToStart,
                      duration: Duration(seconds: 2),
                      content: Center(
                        child: MyText(
                          content:
                              'Report will be generated, Check your Downloads',
                          size: fontSizeSmall * 0.85,
                        ),
                      )));
                }
              });
        });
  }
}
