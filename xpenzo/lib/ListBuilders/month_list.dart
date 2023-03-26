import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class MonthList extends StatefulWidget {
  const MonthList({super.key});

  @override
  State<MonthList> createState() => _MonthListState();
}

class _MonthListState extends State<MonthList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: height20,
        ),
        Container(
          height: durationCardHeight,
          width: deviceWidth * 0.9,
          decoration: BoxDecoration(
              color: appColor, borderRadius: BorderRadius.circular(height10)),
        ),
        const Expanded(
          child: Center(
            child: MyText(content: 'Month List builder'),
          ),
        ),
      ],
    );
  }
}
