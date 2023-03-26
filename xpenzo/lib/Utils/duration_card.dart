import 'package:flutter/material.dart';
import 'package:xpenso/constants/constant_variables.dart';
import 'package:xpenso/constants/reuseable_widgets.dart';

class DurationCard extends StatefulWidget {
  final String content;
  final Function()? onPressedMinus;
  final Function()? onPressedPlus;
  final Function()? onPressedJump;
  const DurationCard(
      {super.key,
      this.onPressedMinus,
      this.onPressedPlus,
      this.onPressedJump,
      required this.content});

  @override
  State<DurationCard> createState() => _DurationCardState();
}

class _DurationCardState extends State<DurationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: durationCardHeight,
      width: deviceWidth * 0.9,
      decoration: BoxDecoration(
          color: appColor, borderRadius: BorderRadius.circular(height10)),
      child: Row(
        children: [
          MyButton(
              fillColor: transparent,
              width: deviceWidth / 5,
              content: const Icon(
                Icons.arrow_back_ios,
                color: black,
              ),
              onPressed: widget.onPressedMinus),
          SizedBox(
              width: deviceWidth / 3,
              child: Center(
                  child: MyText(
                content: widget.content,
                color: black,
              ))),
          MyButton(
              fillColor: transparent,
              width: deviceWidth / 5,
              content: const Icon(
                Icons.arrow_forward_ios,
                color: black,
              ),
              onPressed: widget.onPressedPlus),
          MyButton(
              fillColor: transparent,
              width: deviceWidth / 6,
              content: const Icon(
                Icons.calendar_month_outlined,
                color: black,
              ),
              onPressed: widget.onPressedJump),
        ],
      ),
    );
  }
}
