import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:xpenso/constants/constant_variables.dart';

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

Future<void> savePDFFile(
    List<MapEntry<DateTime, MapEntry<double, double>>> inputList) async {
  double incomeTotal = 0;
  double expenseTotal = 0;
  for (int i = 0; i < inputList.length; i++) {
    incomeTotal += inputList[i].value.key;
    expenseTotal += inputList[i].value.value;
  }
  final header = ['Date', 'Income', 'Expense'];
  final data = inputList
      .map((e) => [day.format(e.key), e.value.key, e.value.value])
      .toList();
  // Request the WRITE_EXTERNAL_STORAGE permission at runtime
  if (Platform.isAndroid) {
    if (!(await _requestPermission())) {
      return;
    }
  }
  // Creating the PDF Document
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
    build: (context) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Header(
                  padding: const pw.EdgeInsets.all(height10),
                  textStyle: const pw.TextStyle(fontSize: fontSizeBig * 1.2),
                  text:
                      'Monthly Report - ${month.format(inputList[0].key).toString()}'),
            ),
            pw.SizedBox(height: height20),
            pw.Text('Date: ${day.format(DateTime.now()).toString()}'),
            pw.SizedBox(height: height10),
            pw.Text('Income: ${incomeTotal.toStringAsFixed(2)}'),
            pw.SizedBox(height: height10),
            pw.Text('Expense: ${expenseTotal.toStringAsFixed(2)}'),
            pw.SizedBox(height: height20),
            pw.Text('Summary:'),
            pw.SizedBox(height: height10),
            pw.Table.fromTextArray(
                headers: header,
                data: data,
                headerStyle: pw.TextStyle(color: PdfColor.fromHex('#FFFFFF')),
                headerCellDecoration:
                    pw.BoxDecoration(color: PdfColor.fromHex('#457b9d'))),
          ]);
    },
  ));

  // Create a file path
  final filePath =
      '/storage/emulated/0/Download/Report_${reportFormat.format(DateTime.now()).toString()}.pdf';

  // Save the Excel document to the file
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Show a toast message indicating the file was saved
  // Replace this with your preferred way of showing a message to the user
  debugPrint("File saved to $filePath");
}

Future<void> savePDFFileYear(
    List<MapEntry<DateTime, MapEntry<double, double>>> inputList) async {
  double incomeTotal = 0;
  double expenseTotal = 0;
  for (int i = 0; i < inputList.length; i++) {
    incomeTotal += inputList[i].value.key;
    expenseTotal += inputList[i].value.value;
  }
  final header = ['Date', 'Income', 'Expense'];
  final data = inputList
      .map((e) => [month.format(e.key), e.value.key, e.value.value])
      .toList();
  // Request the WRITE_EXTERNAL_STORAGE permission at runtime
  if (Platform.isAndroid) {
    if (!(await _requestPermission())) {
      return;
    }
  }
  // Creating the PDF Document
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
    build: (context) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Header(
                  padding: const pw.EdgeInsets.all(height10),
                  textStyle: const pw.TextStyle(fontSize: fontSizeBig * 1.2),
                  text:
                      'Yearly Report - ${year.format(inputList[0].key).toString()}'),
            ),
            pw.SizedBox(height: height20),
            pw.Text('Date: ${day.format(DateTime.now()).toString()}'),
            pw.SizedBox(height: height10),
            pw.Text('Income: ${incomeTotal.toStringAsFixed(2)}'),
            pw.SizedBox(height: height10),
            pw.Text('Expense: ${expenseTotal.toStringAsFixed(2)}'),
            pw.SizedBox(height: height20),
            pw.Text('Summary:'),
            pw.SizedBox(height: height10),
            pw.Table.fromTextArray(
                headers: header,
                data: data,
                headerStyle: pw.TextStyle(color: PdfColor.fromHex('#FFFFFF')),
                headerCellDecoration:
                    pw.BoxDecoration(color: PdfColor.fromHex('#457b9d'))),
          ]);
    },
  ));

  // Create a file path
  final filePath =
      '/storage/emulated/0/Download/Report_${reportFormat.format(DateTime.now()).toString()}.pdf';

  // Save the Excel document to the file
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Show a toast message indicating the file was saved
  // Replace this with your preferred way of showing a message to the user
  debugPrint("File saved to $filePath");
}
