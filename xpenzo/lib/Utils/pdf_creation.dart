import 'package:flutter/material.dart';
import 'package:xpenso/ListBuilders/month_list.dart';
import 'package:xpenso/ListBuilders/year_list.dart';
import 'package:xpenso/Utils/pdf_apis.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

List<MapEntry<DateTime, MapEntry<double, double>>> emptyList = [];

class CreatePdfReportButton extends StatefulWidget {
  final DateTime? currDate;
  const CreatePdfReportButton({super.key, this.currDate});

  @override
  State<CreatePdfReportButton> createState() => _CreatePdfReportButtonState();
}

class _CreatePdfReportButtonState extends State<CreatePdfReportButton> {
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
                  path: 'assets/icons/pdf.png',
                  name: 'PDF',
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
                  savePDFFile(tmpList);
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

class CreatePdfYearReportButton extends StatefulWidget {
  final DateTime? currDate;
  const CreatePdfYearReportButton({super.key, this.currDate});

  @override
  State<CreatePdfYearReportButton> createState() =>
      _CreatePdfYearReportButtonState();
}

class _CreatePdfYearReportButtonState extends State<CreatePdfYearReportButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: yearTotalListBloc.stateStream,
        initialData: emptyList,
        builder: (context, snapshot) {
          List<MapEntry<DateTime, MapEntry<double, double>>> tmpList =
              snapshot.data!;
          return MyButton(
              fillColor: transparent,
              content: const MyImageIcon(
                  path: 'assets/icons/pdf.png',
                  name: 'PDF',
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
                  savePDFFileYear(tmpList);
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
