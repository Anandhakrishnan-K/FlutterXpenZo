import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xpenso/constants/constant_variables.dart';

//**************** ReUsable text Widget ************/

class MyText extends StatelessWidget {
  final String content;
  final double size;
  final Color color;
  final bool isHeader;
  final TextOverflow overflow;
  final int maxlines;
  const MyText(
      {super.key,
      this.maxlines = 1,
      required this.content,
      this.size = 14,
      this.color = Colors.black,
      this.overflow = TextOverflow.ellipsis,
      this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: GoogleFonts.poppins(
          fontSize: size,
          color: color,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      overflow: overflow,
      maxLines: maxlines,
    );
  }
}

//**************** ReUsable Button Widget ************/

class MyButton extends StatefulWidget {
  final Widget content;
  final Function()? onPressed;
  final double textSize;
  final bool isBold;
  final double height;
  final double width;
  final Color textcolor;
  final Color borderColor;
  final Color fillColor;
  final double rad;

  const MyButton(
      {super.key,
      required this.content,
      this.textSize = 15,
      this.isBold = false,
      this.height = 40,
      this.width = 100,
      this.textcolor = Colors.black,
      this.fillColor = Colors.white,
      this.rad = 5,
      required this.onPressed,
      this.borderColor = Colors.transparent});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          color: widget.fillColor,
          borderRadius: BorderRadius.circular(widget.rad)),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(backgroundColor: widget.fillColor),
        child: widget.content,
      ),
    );
  }
}

//**************** ReUsable ImageIcon Widget ************/

class MyImageIcon extends StatelessWidget {
  final String path;
  final String name;
  final double totalSize;
  final double iconSize;
  final Color color;
  final bool nameVis;
  const MyImageIcon(
      {super.key,
      required this.path,
      this.name = '',
      this.totalSize = 75,
      this.iconSize = 50,
      this.color = Colors.black,
      this.nameVis = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: totalSize,
      child: Column(
        children: [
          Image.asset(
            path,
            width: iconSize,
            height: iconSize,
          ),
          const SizedBox(
            height: height10 / 2,
          ),
          Visibility(
            visible: nameVis,
            child: MyText(
              content: name,
              size: height10,
            ),
          )
        ],
      ),
    );
  }
}
